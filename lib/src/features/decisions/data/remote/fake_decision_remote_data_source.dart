import 'package:flutter/foundation.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/utils/uuid.dart';
import '../../../tags/domain/entities/tag.dart';
import '../../domain/entities/decision.dart';
import '../../domain/entities/decision_enums.dart';
import '../../domain/entities/evaluation.dart';
import 'decision_remote_data_source.dart';

/// Stands in for the backend until its decision endpoints exist. It keeps
/// "server" copies in memory (so they are gone when the app restarts) and
/// follows the rules docs/SYNC_API.md asks of the real server, including
/// last-write-wins with 409 Conflict. Insights are samples made from simple
/// rules, clearly labelled as such: it is not the AI.
class FakeDecisionRemoteDataSource implements DecisionRemoteDataSource {
  FakeDecisionRemoteDataSource({
    this.latency = const Duration(milliseconds: 800),
    DateTime Function()? clock,
  }) : _now = clock ?? DateTime.now;

  final Duration latency;
  final DateTime Function() _now;

  final _decisions = <String, _StoredDecision>{};
  final _evaluations = <String, Evaluation>{}; // By decision id
  final _tags = <String, Tag>{};

  /// Set to make every call fail, e.g. to test going offline.
  ApiException? failWith;

  static const offline = ApiException(
    "Can't reach the server. Check your internet connection.",
    isConnectionProblem: true,
  );

  static const _notFound = ApiException('Not found', statusCode: 404);

  Future<void> _call() async {
    await Future<void>.delayed(latency);
    if (failWith != null) throw failWith!;
  }

  /// 404 if the server never had it; 409 with its copy if it was deleted, so
  /// the app removes it too instead of sending it again as new.
  _StoredDecision _live(String? id) {
    final stored = _decisions[id];
    if (stored == null) throw _notFound;
    if (stored.deletedAt != null) {
      throw DecisionConflictException(stored.toRemote());
    }
    return stored;
  }

  RemoteDecisionIds _store(Decision decision, String id, List<String> tagIds) {
    final previous = _decisions[id];
    final optionIds = {
      for (final option in decision.options)
        // Keep the id of an option the server already has.
        option.key: previous?.decision.options
                .where((o) => o.key == option.key)
                .firstOrNull
                ?.serverId ??
            newUuidV4(),
    };
    _decisions[id] = _StoredDecision(
      decision: decision.copyWith(
        serverId: id,
        options: [
          for (final o in decision.options) o.copyWith(serverId: optionIds[o.key]),
        ],
      ),
      tagIds: List.of(tagIds),
    );
    return RemoteDecisionIds(id: id, optionIds: optionIds);
  }

  @override
  Future<RemoteDecisionIds> createDecision(
    Decision decision, {
    required List<String> tagServerIds,
  }) async {
    await _call();
    return _store(decision, newUuidV4(), tagServerIds);
  }

  @override
  Future<RemoteDecisionIds> updateDecision(
    Decision decision, {
    required List<String> tagServerIds,
  }) async {
    await _call();
    final stored = _decisions[decision.serverId];
    if (stored == null) throw _notFound;
    // Last write wins (paper III-F): a copy changed after this one stays,
    // and a newer change brings back a decision deleted elsewhere.
    if (stored.updatedAt.isAfter(decision.updatedAt)) {
      throw DecisionConflictException(stored.toRemote());
    }
    return _store(decision, decision.serverId!, tagServerIds);
  }

  @override
  Future<void> deleteDecision(String serverId, {required DateTime updatedAt}) async {
    await _call();
    final stored = _decisions[serverId];
    if (stored == null) throw _notFound;
    if (stored.deletedAt != null) return; // Already deleted: nothing to do
    if (stored.updatedAt.isAfter(updatedAt)) {
      throw DecisionConflictException(stored.toRemote());
    }
    // Soft delete, like DECISIONS.deleted_at.
    stored.deletedAt = _now();
    stored.decision = stored.decision.copyWith(updatedAt: updatedAt);
  }

  @override
  Future<String> createEvaluation(
    String decisionServerId,
    Evaluation evaluation,
  ) async {
    await _call();
    _live(decisionServerId);
    // One evaluation per decision: a retried request gets the same one back.
    final existing = _evaluations[decisionServerId];
    if (existing != null) return existing.serverId!;
    final id = newUuidV4();
    _evaluations[decisionServerId] = evaluation.copyWith(serverId: id);
    return id;
  }

  @override
  Future<RemoteInsight> requestInsight(
    String decisionServerId,
    TriggerContext trigger,
  ) async {
    await _call();
    final stored = _live(decisionServerId);
    return sampleInsight(
      stored.decision,
      trigger,
      _evaluations[decisionServerId],
      id: newUuidV4(),
      now: _now(),
    );
  }

  @override
  Future<String> createTag(Tag tag) async {
    await _call();
    for (final entry in _tags.entries) {
      if (entry.value.userId == tag.userId &&
          entry.value.name.toLowerCase() == tag.name.toLowerCase()) {
        return entry.key; // UNIQUE(user_id, name): the existing tag
      }
    }
    final id = newUuidV4();
    _tags[id] = tag.copyWith(serverId: id);
    return id;
  }

  @override
  Future<void> deleteTag(String serverId) async {
    await _call();
    if (_tags.remove(serverId) == null) throw _notFound;
    for (final stored in _decisions.values) {
      stored.tagIds.remove(serverId); // ON DELETE CASCADE
    }
  }

  // --- For tests and the sandbox page ---

  /// The server's copy of a decision, or null if it never had it.
  @visibleForTesting
  RemoteDecision? serverCopy(String id) => _decisions[id]?.toRemote();

  @visibleForTesting
  Evaluation? serverEvaluation(String decisionServerId) =>
      _evaluations[decisionServerId];

  @visibleForTesting
  Tag? serverTag(String id) => _tags[id];

  @visibleForTesting
  int get decisionCount => _decisions.length;

  @visibleForTesting
  int get tagCount => _tags.length;

  /// Changes the server's copy as if another device had, at [at].
  @visibleForTesting
  void editElsewhere(String id, {required DateTime at, String? title, bool delete = false}) {
    final stored = _decisions[id]!;
    stored.decision = stored.decision.copyWith(
      title: title ?? stored.decision.title,
      updatedAt: at,
    );
    if (delete) stored.deletedAt = at;
  }

  /// Forgets everything, like a server whose database was reset.
  @visibleForTesting
  void reset() {
    _decisions.clear();
    _evaluations.clear();
    _tags.clear();
  }
}

class _StoredDecision {
  _StoredDecision({required this.decision, required this.tagIds});

  Decision decision; // With server ids filled in
  final List<String> tagIds;
  DateTime? deletedAt;

  DateTime get updatedAt => decision.updatedAt;

  RemoteDecision toRemote() {
    final d = decision;
    final chosen = d.chosenOption;
    return RemoteDecision(
      id: d.serverId!,
      title: d.title,
      context: d.context,
      confidenceBefore: d.confidenceBefore,
      scheduledReviewDate: d.scheduledReviewDate,
      createdAt: d.createdAt,
      updatedAt: d.updatedAt,
      deletedAt: deletedAt,
      options: [
        for (final o in d.options)
          RemoteOption(
            id: o.serverId!,
            title: o.title,
            pros: o.pros,
            cons: o.cons,
            createdAt: o.createdAt,
          ),
      ],
      outcome: d.outcome == null || chosen == null
          ? null
          : RemoteOutcome(
              chosenOptionId: chosen.serverId!,
              commitmentNote: d.outcome!.commitmentNote,
              decidedAt: d.outcome!.decidedAt,
            ),
      tagIds: List.of(tagIds),
    );
  }
}

/// Builds a placeholder insight from keyword rules, so the screens can be
/// built and tried before the backend calls Gemini. Its text says so, and its
/// low model confidence makes the app show the AI-limitations warning.
RemoteInsight sampleInsight(
  Decision decision,
  TriggerContext trigger,
  Evaluation? evaluation, {
  required String id,
  required DateTime now,
}) {
  const label = 'Sample analysis: the AI service is not connected yet, so this '
      'was produced by simple rules, not by the AI. ';

  BiasType? bias;
  String finding;
  String? prompt;

  if (trigger == TriggerContext.postEvaluation) {
    final before = decision.confidenceBefore;
    final after = evaluation?.confidenceAfter;
    if (before != null && after != null && before - after >= 20) {
      bias = BiasType.overconfidence;
      finding = 'You felt $before% sure before deciding and $after% sure '
          'afterwards. Looking back, were you more certain than the facts '
          'supported at the time?';
      prompt = 'Next time, note what would change your mind before you commit.';
    } else {
      finding = 'Your confidence before and after deciding is similar. '
          'What helped you judge this decision well?';
    }
  } else {
    final text = [
      decision.title,
      decision.context ?? '',
      for (final o in decision.options) ...[o.title, ...o.pros, ...o.cons],
    ].join(' ').toLowerCase();
    bool mentions(List<String> words) => words.any(text.contains);

    if (mentions(['already spent', 'already paid', 'invested', 'so far',
        'wasted', 'sudah keluar', 'terlanjur'])) {
      bias = BiasType.sunkCost;
      finding = 'You mention what you have already put in. Is that cost '
          'something you can still get back, or only something you can lose '
          'more of?';
      prompt = 'Compare the options only on what happens from today onward.';
    } else if ((decision.confidenceBefore ?? 0) >= 85) {
      bias = BiasType.overconfidence;
      finding = 'You are ${decision.confidenceBefore}% sure already. What '
          'would have to be true for your preferred option to go badly?';
      prompt = 'Write down one way your favourite option could fail.';
    } else if (mentions(['lose', 'losing', 'miss out', 'rugi', 'kehilangan'])) {
      bias = BiasType.lossAversion;
      finding = 'Your notes focus on what you might lose. Are you giving the '
          'possible gains the same weight?';
      prompt = 'List what each option could gain you, not only what it risks.';
    } else if (_onlyOneSideArgued(decision.options)) {
      bias = BiasType.confirmation;
      finding = 'One option has only pros and the others have few. Did you '
          'look for reasons against the option you prefer?';
      prompt = 'Add at least one con to the option you lean towards.';
    } else {
      finding = 'No clear sign of the biases this check looks for. Your '
          'options have reasons on both sides.';
    }
  }

  return RemoteInsight(
    serverId: id,
    modelVersion: 'sample-rules-v1',
    insightText: label + finding,
    generatedAt: now,
    primaryBias: bias,
    emotionalTone: (decision.confidenceBefore ?? 50) < 40
        ? EmotionalTone.uncertain
        : EmotionalTone.neutral,
    riskLevel: bias == null ? RiskLevel.low : RiskLevel.medium,
    actionabilityScore: bias == null ? 3 : 6,
    suggestedAlternative: prompt,
    modelConfidence: 0.3,
  );
}

bool _onlyOneSideArgued(List<DecisionOption> options) {
  if (options.length < 2) return false;
  final favoured = options.where((o) => o.pros.length >= 2 && o.cons.isEmpty);
  final others = options.where((o) => o.pros.isEmpty);
  return favoured.length == 1 && others.length == options.length - 1;
}
