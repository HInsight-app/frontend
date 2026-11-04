import '../../../../core/database/sync_status.dart';
import '../../../../core/utils/uuid.dart';
import '../../../tags/domain/entities/tag.dart';
import '../../domain/entities/ai_insight.dart';
import '../../domain/entities/decision.dart';
import '../../domain/entities/decision_enums.dart';
import '../../domain/entities/decision_exception.dart';
import '../../domain/entities/evaluation.dart';
import '../../domain/repositories/decision_repository.dart';
import '../local/decision_local_data_source.dart';
import '../remote/decision_remote_data_source.dart';

/// Offline-first: every change is saved on the device and marked for sync
/// (paper III-F). Only AI insights call the server straight away, because the
/// AI runs there; the full background sync comes in Phase 7.
class DecisionRepositoryImpl implements DecisionRepository {
  DecisionRepositoryImpl({
    required this.local,
    required this.remote,
    required this.userId,
    DateTime Function()? clock,
  }) : _now = clock ?? DateTime.now;

  final DecisionLocalDataSource local;
  final DecisionRemoteDataSource remote;
  final String userId;
  final DateTime Function() _now;

  /// A request still "processing" after this long means the app was closed
  /// mid-request, so it no longer blocks a new one.
  static const processingTimeout = Duration(minutes: 3);

  // Database limits (backend migration).
  static const _maxTitleLength = 255;
  static const _maxTagNameLength = 100;
  static final _colorHex = RegExp(r'^#[0-9A-Fa-f]{6}$');

  // --- Reading ---

  @override
  Stream<List<Decision>> watchDecisions({
    DecisionStatus? status,
    String? search,
  }) {
    final query = search?.trim().toLowerCase() ?? '';
    return local.watchDecisions(userId).map((decisions) => decisions
        .where((d) => status == null || d.status == status)
        .where((d) => query.isEmpty || _matches(d, query))
        .toList());
  }

  static bool _matches(Decision d, String query) =>
      d.title.toLowerCase().contains(query) ||
      (d.context?.toLowerCase().contains(query) ?? false) ||
      d.options.any((o) => o.title.toLowerCase().contains(query));

  @override
  Stream<Decision?> watchDecision(int localId) => local
      .watchDecision(localId)
      .map((d) => d == null || !_isVisible(d) ? null : d);

  @override
  Stream<Evaluation?> watchEvaluation(int decisionLocalId) =>
      local.watchEvaluation(decisionLocalId);

  @override
  Stream<List<AiInsight>> watchInsights(int decisionLocalId) =>
      local.watchInsights(decisionLocalId);

  bool _isVisible(Decision d) => d.userId == userId && d.deletedAt == null;

  Future<Decision> _requireDecision(int localId) async {
    final d = await local.getDecision(localId);
    if (d == null || !_isVisible(d)) {
      throw const DecisionException('This decision no longer exists.');
    }
    return d;
  }

  // --- Decision flow ---

  @override
  Future<Decision> createDecision(DecisionDraft draft) async {
    _validate(draft);
    final now = _now();
    return local.putDecision(Decision(
      userId: userId,
      title: draft.title.trim(),
      context: _blankToNull(draft.context),
      confidenceBefore: draft.confidenceBefore,
      scheduledReviewDate: draft.scheduledReviewDate,
      createdAt: now,
      updatedAt: now,
      options: _buildOptions(draft.options, const [], now),
      tagLocalIds: draft.tagLocalIds.toSet().toList(),
    ));
  }

  @override
  Future<Decision> updateDecision(int localId, DecisionDraft draft) async {
    final d = await _requireDecision(localId);
    if (d.status != DecisionStatus.pending) {
      throw const DecisionException(
          "A decision can't be edited after you've committed to an option.");
    }
    _validate(draft);
    final now = _now();
    return local.putDecision(d.copyWith(
      title: draft.title.trim(),
      context: _blankToNull(draft.context),
      confidenceBefore: draft.confidenceBefore,
      scheduledReviewDate: draft.scheduledReviewDate,
      options: _buildOptions(draft.options, d.options, now),
      tagLocalIds: draft.tagLocalIds.toSet().toList(),
      updatedAt: now,
      syncStatus: _afterEdit(d.syncStatus),
    ));
  }

  @override
  Future<void> deleteDecision(int localId) async {
    final d = await _requireDecision(localId);
    if (d.syncStatus == SyncStatus.pendingCreate) {
      // Never reached the server, so there is nothing to tell it.
      await local.deleteDecisionPermanently(localId);
      return;
    }
    final now = _now();
    await local.putDecision(d.copyWith(
      deletedAt: now,
      updatedAt: now,
      syncStatus: SyncStatus.pendingDelete,
    ));
  }

  @override
  Future<Decision> commitDecision(
    int localId, {
    required String chosenOptionKey,
    String? commitmentNote,
  }) async {
    final d = await _requireDecision(localId);
    if (d.status != DecisionStatus.pending) {
      throw const DecisionException(
          "You've already committed to an option for this decision.");
    }
    if (!d.options.any((o) => o.key == chosenOptionKey)) {
      throw const DecisionException("Choose one of this decision's options.");
    }
    final now = _now();
    return local.putDecision(d.copyWith(
      outcome: DecisionOutcome(
        chosenOptionKey: chosenOptionKey,
        commitmentNote: _blankToNull(commitmentNote),
        decidedAt: now,
      ),
      status: DecisionStatus.decided,
      updatedAt: now,
      syncStatus: _afterEdit(d.syncStatus),
    ));
  }

  @override
  Future<Evaluation> evaluateDecision(
    int localId, {
    required int satisfactionAfter,
    int? confidenceAfter,
    String? hindsightNotes,
  }) async {
    final d = await _requireDecision(localId);
    if (d.status == DecisionStatus.pending) {
      throw const DecisionException(
          'Commit to an option before evaluating the decision.');
    }
    if (d.status == DecisionStatus.evaluated ||
        await local.getEvaluation(localId) != null) {
      throw const DecisionException(
          "You've already evaluated this decision.");
    }
    _checkScale(satisfactionAfter, 'Satisfaction');
    if (confidenceAfter != null) _checkScale(confidenceAfter, 'Confidence');

    final evaluation = await local.putEvaluation(Evaluation(
      decisionLocalId: localId,
      decisionServerId: d.serverId,
      satisfactionAfter: satisfactionAfter,
      confidenceAfter: confidenceAfter,
      hindsightNotes: _blankToNull(hindsightNotes),
      createdAt: _now(),
    ));
    // Status is local only (the server derives it), so this isn't a change
    // to sync and updatedAt stays as it was.
    await local.putDecision(d.copyWith(status: DecisionStatus.evaluated));
    return evaluation;
  }

  @override
  Future<AiInsight> requestInsight(int localId, TriggerContext trigger) async {
    final d = await _requireDecision(localId);
    if (trigger == TriggerContext.preDecision &&
        d.status != DecisionStatus.pending) {
      throw const DecisionException(
          'The pre-decision check is for decisions you haven\'t committed to yet.');
    }
    if (trigger == TriggerContext.postEvaluation &&
        d.status != DecisionStatus.evaluated) {
      throw const DecisionException(
          'Evaluate the decision before asking for a look back.');
    }

    // The paper's race-condition guard: one request at a time per decision
    // and trigger, even across app restarts.
    final now = _now();
    for (final previous in await local.getInsights(localId, trigger)) {
      if (previous.status != InsightStatus.processing) continue;
      if (now.difference(previous.requestedAt) < processingTimeout) {
        throw const DecisionException(
            'The AI is already checking this decision. Please wait.');
      }
      await local.putInsight(previous.copyWith(status: InsightStatus.failed));
    }

    // The server analyses its own copy, so send local changes first. If this
    // fails (e.g. offline), nothing is recorded and the ApiException surfaces.
    final onServer = await _pushDecision(d);
    if (trigger == TriggerContext.postEvaluation) {
      await _pushEvaluation(localId, onServer.serverId!);
    }

    final processing = await local.putInsight(AiInsight(
      decisionLocalId: localId,
      decisionServerId: onServer.serverId!,
      triggerContext: trigger,
      status: InsightStatus.processing,
      requestedAt: now,
    ));
    try {
      final result = await remote.requestInsight(onServer.serverId!, trigger);
      return local.putInsight(processing.copyWith(
        status: InsightStatus.complete,
        serverId: result.serverId,
        modelVersion: result.modelVersion,
        insightText: result.insightText,
        primaryBias: result.primaryBias,
        emotionalTone: result.emotionalTone,
        riskLevel: result.riskLevel,
        actionabilityScore: result.actionabilityScore,
        suggestedAlternative: result.suggestedAlternative,
        modelConfidence: result.modelConfidence,
        generatedAt: result.generatedAt,
      ));
    } catch (_) {
      await local.putInsight(processing.copyWith(status: InsightStatus.failed));
      rethrow;
    }
  }

  /// Makes sure the server has the latest version of [d]. Phase 7's sync
  /// reuses this for every pending decision.
  Future<Decision> _pushDecision(Decision d) async {
    final RemoteDecisionIds ids;
    switch (d.syncStatus) {
      case SyncStatus.synced:
        return d;
      case SyncStatus.pendingCreate:
        ids = await remote.createDecision(d);
      case SyncStatus.pendingUpdate:
        ids = await remote.updateDecision(d);
      case SyncStatus.pendingDelete:
        throw const DecisionException('This decision no longer exists.');
    }

    // The student may have edited the decision while the request was in
    // flight; keep those edits and leave them marked for the next sync.
    final latest = await local.getDecision(d.localId!) ?? d;
    final editedMeanwhile = latest.updatedAt != d.updatedAt;
    return local.putDecision(latest.copyWith(
      serverId: ids.id,
      options: [
        for (final o in latest.options)
          o.copyWith(serverId: ids.optionIds[o.key] ?? o.serverId),
      ],
      syncStatus: editedMeanwhile ? SyncStatus.pendingUpdate : SyncStatus.synced,
    ));
  }

  Future<void> _pushEvaluation(int decisionLocalId, String decisionServerId) async {
    final e = await local.getEvaluation(decisionLocalId);
    if (e == null || e.syncStatus != SyncStatus.pendingCreate) return;
    final id = await remote.createEvaluation(decisionServerId, e);
    await local.putEvaluation(e.copyWith(
      serverId: id,
      decisionServerId: decisionServerId,
      syncStatus: SyncStatus.synced,
    ));
  }

  // --- Tags ---

  @override
  Stream<List<Tag>> watchTags() => local.watchTags(userId);

  @override
  Future<Tag> createTag(String name, {String? colorHex}) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) throw const DecisionException('Give the tag a name.');
    if (trimmed.length > _maxTagNameLength) {
      throw const DecisionException('Tag names can be at most 100 characters.');
    }
    if (colorHex != null && !_colorHex.hasMatch(colorHex)) {
      throw const DecisionException('Tag colours must look like #8771FF.');
    }

    for (final tag in await local.getTags(userId)) {
      if (tag.name.toLowerCase() != trimmed.toLowerCase()) continue;
      if (tag.syncStatus != SyncStatus.pendingDelete) {
        throw DecisionException('You already have a tag called "${tag.name}".');
      }
      // Deleted but not yet synced: bring it back instead of duplicating it.
      return local.putTag(tag.copyWith(
        colorHex: colorHex ?? tag.colorHex,
        syncStatus:
            tag.serverId == null ? SyncStatus.pendingCreate : SyncStatus.synced,
      ));
    }
    return local.putTag(Tag(userId: userId, name: trimmed, colorHex: colorHex));
  }

  @override
  Future<void> deleteTag(int localId) async {
    final tag = await local.getTag(localId);
    if (tag == null || tag.userId != userId) return;

    final now = _now();
    for (final d in await local.watchDecisions(userId).first) {
      if (!d.tagLocalIds.contains(localId)) continue;
      await local.putDecision(d.copyWith(
        tagLocalIds: d.tagLocalIds.where((id) => id != localId).toList(),
        updatedAt: now,
        syncStatus: _afterEdit(d.syncStatus),
      ));
    }

    if (tag.syncStatus == SyncStatus.pendingCreate) {
      await local.deleteTagPermanently(localId);
    } else {
      await local.putTag(tag.copyWith(syncStatus: SyncStatus.pendingDelete));
    }
  }

  // --- Helpers ---

  /// A synced record becomes pendingUpdate; one never sent stays pendingCreate.
  static SyncStatus _afterEdit(SyncStatus current) =>
      current == SyncStatus.synced ? SyncStatus.pendingUpdate : current;

  static String? _blankToNull(String? text) {
    final trimmed = text?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }

  static void _checkScale(int value, String name) {
    if (value < 1 || value > 100) {
      throw DecisionException('$name must be between 1 and 100.');
    }
  }

  static void _validate(DecisionDraft draft) {
    final title = draft.title.trim();
    if (title.isEmpty) {
      throw const DecisionException('Give the decision a title.');
    }
    if (title.length > _maxTitleLength) {
      throw const DecisionException('Titles can be at most 255 characters.');
    }
    if (draft.confidenceBefore != null) {
      _checkScale(draft.confidenceBefore!, 'Confidence');
    }

    final seen = <String>{};
    for (final option in draft.options) {
      final optionTitle = option.title.trim();
      if (optionTitle.isEmpty) {
        throw const DecisionException('Every option needs a title.');
      }
      if (optionTitle.length > _maxTitleLength) {
        throw const DecisionException(
            'Option titles can be at most 255 characters.');
      }
      // The database allows each option title only once per decision.
      if (!seen.add(optionTitle.toLowerCase())) {
        throw DecisionException(
            'Two options are called "$optionTitle". Give each a different title.');
      }
    }
  }

  static List<DecisionOption> _buildOptions(
    List<OptionDraft> drafts,
    List<DecisionOption> existing,
    DateTime now,
  ) {
    List<String> clean(List<String> items) => [
          for (final item in items)
            if (item.trim().isNotEmpty) item.trim(),
        ];

    return [
      for (final draft in drafts)
        () {
          final match = existing.where((o) => o.key == draft.key).firstOrNull;
          return DecisionOption(
            key: match?.key ?? newUuidV4(),
            serverId: match?.serverId,
            title: draft.title.trim(),
            pros: clean(draft.pros),
            cons: clean(draft.cons),
            createdAt: match?.createdAt ?? now,
          );
        }(),
    ];
  }
}
