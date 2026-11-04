import 'package:flutter_test/flutter_test.dart';
import 'package:hinsight/src/core/database/sync_status.dart';
import 'package:hinsight/src/features/decisions/data/local/isar_ai_insight.dart';
import 'package:hinsight/src/features/decisions/data/local/isar_decision.dart';
import 'package:hinsight/src/features/decisions/data/local/isar_evaluation.dart';
import 'package:hinsight/src/features/decisions/domain/entities/decision_enums.dart';
import 'package:hinsight/src/features/tags/data/local/isar_tag.dart';
import 'package:isar/isar.dart';

import '../../helpers/isar_test_db.dart';

// These tests open a real Isar database, so they check the generated schema
// and its indexes, not just the Dart classes.

IsarDecision _offlineDecision(String title) {
  final now = DateTime.now();
  return IsarDecision()
    ..userId = 'user-1'
    ..title = title
    ..createdAt = now
    ..updatedAt = now
    ..options = []
    ..tagLocalIds = []
    ..status = DecisionStatus.pending
    ..syncStatus = SyncStatus.pendingCreate;
}

IsarEvaluation _offlineEvaluation(int decisionLocalId) {
  return IsarEvaluation()
    ..decisionLocalId = decisionLocalId
    ..satisfactionAfter = 70
    ..createdAt = DateTime.now()
    ..syncStatus = SyncStatus.pendingCreate;
}

IsarTag _offlineTag(String userId, String name) {
  return IsarTag()
    ..userId = userId
    ..name = name
    ..syncStatus = SyncStatus.pendingCreate;
}

void main() {
  late Isar isar;

  setUp(() async {
    isar = await openTestIsar([
      IsarDecisionSchema,
      IsarEvaluationSchema,
      IsarAiInsightSchema,
      IsarTagSchema,
    ]);
  });
  tearDown(() => closeTestIsar(isar));

  test('many records can wait offline at once (serverId still null)', () async {
    await isar.writeTxn(() async {
      final first = await isar.isarDecisions.put(_offlineDecision('Pick an elective'));
      final second =
          await isar.isarDecisions.put(_offlineDecision('Take the internship'));
      await isar.isarEvaluations.put(_offlineEvaluation(first));
      await isar.isarEvaluations.put(_offlineEvaluation(second));
      await isar.isarTags.put(_offlineTag('user-1', 'Academic'));
      await isar.isarTags.put(_offlineTag('user-1', 'Career'));
    });

    expect(await isar.isarDecisions.count(), 2);
    expect(await isar.isarEvaluations.count(), 2);
    expect(await isar.isarTags.count(), 2);
  });

  // A unique-index violation aborts its whole transaction, so each duplicate
  // insert gets a transaction of its own.

  test('a decision can have only one evaluation', () async {
    late int id;
    await isar.writeTxn(() async {
      id = await isar.isarDecisions.put(_offlineDecision('Pick an elective'));
      await isar.isarEvaluations.put(_offlineEvaluation(id));
    });

    await expectLater(
      isar.writeTxn(() => isar.isarEvaluations.put(_offlineEvaluation(id))),
      throwsA(isA<IsarError>()),
    );
    expect(await isar.isarEvaluations.count(), 1);
  });

  test('tag names are unique per user, not across users', () async {
    await isar.writeTxn(() async {
      await isar.isarTags.put(_offlineTag('user-1', 'Academic'));
      await isar.isarTags.put(_offlineTag('user-2', 'Academic'));
    });

    await expectLater(
      isar.writeTxn(() => isar.isarTags.put(_offlineTag('user-1', 'Academic'))),
      throwsA(isA<IsarError>()),
    );
    expect(await isar.isarTags.count(), 2);
  });

  test('an AI insight is saved as processing, then completed', () async {
    late int decisionId;
    late int insightId;
    await isar.writeTxn(() async {
      decisionId = await isar.isarDecisions.put(_offlineDecision('Pick an elective'));
      // Saved before the server answers: no server id or results yet.
      insightId = await isar.isarAiInsights.put(IsarAiInsight()
        ..decisionLocalId = decisionId
        ..decisionServerId = 'decision-uuid'
        ..triggerContext = TriggerContext.preDecision
        ..status = InsightStatus.processing
        ..requestedAt = DateTime.now());
    });

    // The double-request guard: is something already processing?
    final processing = await isar.isarAiInsights
        .where()
        .decisionLocalIdTriggerContextEqualTo(
          decisionId,
          TriggerContext.preDecision,
        )
        .filter()
        .statusEqualTo(InsightStatus.processing)
        .count();
    expect(processing, 1);

    await isar.writeTxn(() async {
      final insight = (await isar.isarAiInsights.get(insightId))!
        ..serverId = 'insight-uuid'
        ..status = InsightStatus.complete
        ..insightText = 'You mostly listed reasons that support your first choice.'
        ..primaryBias = BiasType.confirmation
        ..riskLevel = RiskLevel.medium
        ..modelConfidence = 0.8
        ..generatedAt = DateTime.now();
      await isar.isarAiInsights.put(insight);
    });

    final saved = (await isar.isarAiInsights.get(insightId))!;
    expect(saved.status, InsightStatus.complete);
    expect(saved.primaryBias, BiasType.confirmation);
    expect(saved.serverId, 'insight-uuid');
  });
}
