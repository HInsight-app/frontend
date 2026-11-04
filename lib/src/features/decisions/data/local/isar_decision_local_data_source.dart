import 'dart:async';

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/database/sync_status.dart';
import '../../../tags/data/local/isar_tag.dart';
import '../../../tags/domain/entities/tag.dart';
import '../../domain/entities/ai_insight.dart';
import '../../domain/entities/decision.dart';
import '../../domain/entities/decision_enums.dart';
import '../../domain/entities/evaluation.dart';
import 'decision_local_data_source.dart';
import 'isar_ai_insight.dart';
import 'isar_decision.dart';
import 'isar_evaluation.dart';

/// Opens the app's Isar database in its documents folder.
Future<Isar> openHInsightIsar() async {
  final dir = await getApplicationDocumentsDirectory();
  return Isar.open(
    [IsarDecisionSchema, IsarEvaluationSchema, IsarAiInsightSchema, IsarTagSchema],
    directory: dir.path,
    name: 'hinsight',
  );
}

/// The real on-device store (phones only: Isar doesn't run on web).
class IsarDecisionLocalDataSource implements DecisionLocalDataSource {
  IsarDecisionLocalDataSource(this.isar);

  final Isar isar;

  @override
  Stream<List<Decision>> watchDecisions(String userId) => isar.isarDecisions
      .where()
      .userIdEqualTo(userId)
      .filter()
      .deletedAtIsNull()
      .sortByUpdatedAtDesc()
      .watch(fireImmediately: true)
      .map((rows) => rows.map(_toDecision).toList());

  @override
  Stream<Decision?> watchDecision(int localId) => isar.isarDecisions
      .watchObject(localId, fireImmediately: true)
      .map((row) => row == null ? null : _toDecision(row));

  @override
  Future<Decision?> getDecision(int localId) async {
    final row = await isar.isarDecisions.get(localId);
    return row == null ? null : _toDecision(row);
  }

  @override
  Future<Decision> putDecision(Decision decision) async {
    final id = await isar.writeTxn(
      () => isar.isarDecisions.put(_fromDecision(decision)),
    );
    return decision.copyWith(localId: id);
  }

  @override
  Future<void> deleteDecisionPermanently(int localId) {
    return isar.writeTxn(() async {
      await isar.isarDecisions.delete(localId);
      await isar.isarEvaluations.deleteByDecisionLocalId(localId);
      await isar.isarAiInsights
          .where()
          .decisionLocalIdEqualToAnyTriggerContext(localId)
          .deleteAll();
    });
  }

  @override
  Future<Evaluation?> getEvaluation(int decisionLocalId) async {
    final row = await isar.isarEvaluations.getByDecisionLocalId(decisionLocalId);
    return row == null ? null : _toEvaluation(row);
  }

  @override
  Stream<Evaluation?> watchEvaluation(int decisionLocalId) => isar.isarEvaluations
      .where()
      .decisionLocalIdEqualTo(decisionLocalId)
      .watch(fireImmediately: true)
      .map((rows) => rows.isEmpty ? null : _toEvaluation(rows.first));

  @override
  Future<Evaluation> putEvaluation(Evaluation evaluation) async {
    final id = await isar.writeTxn(
      () => isar.isarEvaluations.put(_fromEvaluation(evaluation)),
    );
    return evaluation.copyWith(localId: id);
  }

  @override
  Stream<List<AiInsight>> watchInsights(int decisionLocalId) => isar.isarAiInsights
      .where()
      .decisionLocalIdEqualToAnyTriggerContext(decisionLocalId)
      .sortByRequestedAtDesc()
      .watch(fireImmediately: true)
      .map((rows) => rows.map(_toInsight).toList());

  @override
  Stream<List<AiInsight>> watchInsightsOfUser(String userId) {
    // Re-query when insights change, or decisions (a deletion hides insights).
    final subscriptions = <StreamSubscription<void>>[];
    late final StreamController<List<AiInsight>> controller;
    Future<void> emit() async {
      final insights = await _insightsOfUser(userId);
      if (!controller.isClosed) controller.add(insights);
    }

    controller = StreamController<List<AiInsight>>(
      onListen: () {
        subscriptions
          ..add(isar.isarAiInsights.watchLazy().listen((_) => emit()))
          ..add(isar.isarDecisions.watchLazy().listen((_) => emit()));
        emit();
      },
      onCancel: () async {
        for (final s in subscriptions) {
          await s.cancel();
        }
      },
    );
    return controller.stream;
  }

  Future<List<AiInsight>> _insightsOfUser(String userId) async {
    final ids = await isar.isarDecisions
        .where()
        .userIdEqualTo(userId)
        .filter()
        .deletedAtIsNull()
        .localIdProperty()
        .findAll();
    // anyOf() with no items matches everything, so stop here.
    if (ids.isEmpty) return const [];
    final rows = await isar.isarAiInsights
        .filter()
        .anyOf(ids, (q, int id) => q.decisionLocalIdEqualTo(id))
        .sortByRequestedAtDesc()
        .findAll();
    return rows.map(_toInsight).toList();
  }

  @override
  Future<List<AiInsight>> getInsights(
    int decisionLocalId,
    TriggerContext trigger,
  ) async {
    final rows = await isar.isarAiInsights
        .where()
        .decisionLocalIdTriggerContextEqualTo(decisionLocalId, trigger)
        .sortByRequestedAtDesc()
        .findAll();
    return rows.map(_toInsight).toList();
  }

  @override
  Future<AiInsight> putInsight(AiInsight insight) async {
    final id = await isar.writeTxn(
      () => isar.isarAiInsights.put(_fromInsight(insight)),
    );
    return insight.copyWith(localId: id);
  }

  @override
  Stream<List<Tag>> watchTags(String userId) => isar.isarTags
      .where()
      .userIdEqualToAnyName(userId)
      .filter()
      .not()
      .syncStatusEqualTo(SyncStatus.pendingDelete)
      .sortByName()
      .watch(fireImmediately: true)
      .map((rows) => rows.map(_toTag).toList());

  @override
  Future<List<Tag>> getTags(String userId) async {
    final rows = await isar.isarTags.where().userIdEqualToAnyName(userId).findAll();
    return rows.map(_toTag).toList();
  }

  @override
  Future<Tag?> getTag(int localId) async {
    final row = await isar.isarTags.get(localId);
    return row == null ? null : _toTag(row);
  }

  @override
  Future<Tag> putTag(Tag tag) async {
    final id = await isar.writeTxn(() => isar.isarTags.put(_fromTag(tag)));
    return tag.copyWith(localId: id);
  }

  @override
  Future<void> deleteTagPermanently(int localId) =>
      isar.writeTxn(() => isar.isarTags.delete(localId));

  // --- Mapping between Isar records and domain entities ---

  // OPTIONS.pros / cons are single TEXT columns, so each list is stored as
  // one item per line.
  static String? _joinLines(List<String> items) =>
      items.isEmpty ? null : items.join('\n');

  static List<String> _splitLines(String? text) => text == null || text.isEmpty
      ? const []
      : text.split('\n').where((line) => line.trim().isNotEmpty).toList();

  static Decision _toDecision(IsarDecision row) => Decision(
        localId: row.localId,
        serverId: row.serverId,
        userId: row.userId,
        title: row.title,
        context: row.context,
        confidenceBefore: row.confidenceBefore,
        scheduledReviewDate: row.scheduledReviewDate,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        deletedAt: row.deletedAt,
        options: [
          for (final o in row.options)
            DecisionOption(
              key: o.localKey,
              serverId: o.serverId,
              title: o.title,
              pros: _splitLines(o.pros),
              cons: _splitLines(o.cons),
              createdAt: o.createdAt,
            ),
        ],
        outcome: row.outcome == null
            ? null
            : DecisionOutcome(
                chosenOptionKey: row.outcome!.chosenOptionKey,
                commitmentNote: row.outcome!.commitmentNote,
                decidedAt: row.outcome!.decidedAt,
              ),
        tagLocalIds: List.of(row.tagLocalIds),
        status: row.status,
        syncStatus: row.syncStatus,
      );

  static IsarDecision _fromDecision(Decision d) {
    final row = IsarDecision()
      ..serverId = d.serverId
      ..userId = d.userId
      ..title = d.title
      ..context = d.context
      ..confidenceBefore = d.confidenceBefore
      ..scheduledReviewDate = d.scheduledReviewDate
      ..createdAt = d.createdAt
      ..updatedAt = d.updatedAt
      ..deletedAt = d.deletedAt
      ..options = [
        for (final o in d.options)
          IsarOption()
            ..localKey = o.key
            ..serverId = o.serverId
            ..title = o.title
            ..pros = _joinLines(o.pros)
            ..cons = _joinLines(o.cons)
            ..createdAt = o.createdAt,
      ]
      ..outcome = d.outcome == null
          ? null
          : (IsarDecisionOutcome()
            ..chosenOptionKey = d.outcome!.chosenOptionKey
            ..commitmentNote = d.outcome!.commitmentNote
            ..decidedAt = d.outcome!.decidedAt)
      ..tagLocalIds = List.of(d.tagLocalIds)
      ..status = d.status
      ..syncStatus = d.syncStatus;
    if (d.localId != null) row.localId = d.localId!;
    return row;
  }

  static Evaluation _toEvaluation(IsarEvaluation row) => Evaluation(
        localId: row.localId,
        serverId: row.serverId,
        decisionLocalId: row.decisionLocalId,
        decisionServerId: row.decisionServerId,
        satisfactionAfter: row.satisfactionAfter,
        confidenceAfter: row.confidenceAfter,
        hindsightNotes: row.hindsightNotes,
        createdAt: row.createdAt,
        syncStatus: row.syncStatus,
      );

  static IsarEvaluation _fromEvaluation(Evaluation e) {
    final row = IsarEvaluation()
      ..serverId = e.serverId
      ..decisionLocalId = e.decisionLocalId
      ..decisionServerId = e.decisionServerId
      ..satisfactionAfter = e.satisfactionAfter
      ..confidenceAfter = e.confidenceAfter
      ..hindsightNotes = e.hindsightNotes
      ..createdAt = e.createdAt
      ..syncStatus = e.syncStatus;
    if (e.localId != null) row.localId = e.localId!;
    return row;
  }

  static AiInsight _toInsight(IsarAiInsight row) => AiInsight(
        localId: row.localId,
        serverId: row.serverId,
        decisionLocalId: row.decisionLocalId,
        decisionServerId: row.decisionServerId,
        triggerContext: row.triggerContext,
        status: row.status,
        requestedAt: row.requestedAt,
        modelVersion: row.modelVersion,
        insightText: row.insightText,
        primaryBias: row.primaryBias,
        emotionalTone: row.emotionalTone,
        riskLevel: row.riskLevel,
        actionabilityScore: row.actionabilityScore,
        suggestedAlternative: row.suggestedAlternative,
        modelConfidence: row.modelConfidence,
        generatedAt: row.generatedAt,
      );

  static IsarAiInsight _fromInsight(AiInsight i) {
    final row = IsarAiInsight()
      ..serverId = i.serverId
      ..decisionLocalId = i.decisionLocalId
      ..decisionServerId = i.decisionServerId
      ..triggerContext = i.triggerContext
      ..status = i.status
      ..requestedAt = i.requestedAt
      ..modelVersion = i.modelVersion
      ..insightText = i.insightText
      ..primaryBias = i.primaryBias
      ..emotionalTone = i.emotionalTone
      ..riskLevel = i.riskLevel
      ..actionabilityScore = i.actionabilityScore
      ..suggestedAlternative = i.suggestedAlternative
      ..modelConfidence = i.modelConfidence
      ..generatedAt = i.generatedAt;
    if (i.localId != null) row.localId = i.localId!;
    return row;
  }

  static Tag _toTag(IsarTag row) => Tag(
        localId: row.localId,
        serverId: row.serverId,
        userId: row.userId,
        name: row.name,
        colorHex: row.colorHex,
        syncStatus: row.syncStatus,
      );

  static IsarTag _fromTag(Tag t) {
    final row = IsarTag()
      ..serverId = t.serverId
      ..userId = t.userId
      ..name = t.name
      ..colorHex = t.colorHex
      ..syncStatus = t.syncStatus;
    if (t.localId != null) row.localId = t.localId!;
    return row;
  }
}
