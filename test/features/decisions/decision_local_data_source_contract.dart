// flutter_test has its own Evaluation (an accessibility check result).
import 'package:flutter_test/flutter_test.dart' hide Evaluation;
import 'package:hinsight/src/core/database/sync_status.dart';
import 'package:hinsight/src/features/decisions/data/local/decision_local_data_source.dart';
import 'package:hinsight/src/features/decisions/domain/entities/ai_insight.dart';
import 'package:hinsight/src/features/decisions/domain/entities/decision.dart';
import 'package:hinsight/src/features/decisions/domain/entities/decision_enums.dart';
import 'package:hinsight/src/features/decisions/domain/entities/evaluation.dart';
import 'package:hinsight/src/features/tags/domain/entities/tag.dart';

/// Behaviour every DecisionLocalDataSource must have, so the Isar store
/// (phones) and the in-memory store (web preview) can't drift apart.
void runDecisionLocalDataSourceContract(
  String name, {
  required Future<DecisionLocalDataSource> Function() open,
  required Future<void> Function() close,
}) {
  group('$name meets the DecisionLocalDataSource contract', () {
    late DecisionLocalDataSource store;

    setUp(() async => store = await open());
    tearDown(close);

    final t0 = DateTime(2026, 11, 4, 9, 30);

    Decision decision(String title, {String userId = 'u1', DateTime? updatedAt}) =>
        Decision(
          userId: userId,
          title: title,
          createdAt: t0,
          updatedAt: updatedAt ?? t0,
        );

    test('saves and reads back every decision field', () async {
      final original = Decision(
        userId: 'u1',
        title: 'Pick an elective',
        context: 'Two courses fit my schedule',
        confidenceBefore: 60,
        scheduledReviewDate: DateTime(2026, 12, 1),
        createdAt: t0,
        updatedAt: t0,
        options: [
          DecisionOption(
            key: 'opt-1',
            title: 'Data Mining',
            pros: ['Useful for the thesis', 'Good lecturer'],
            cons: ['Heavy workload'],
            createdAt: t0,
          ),
          DecisionOption(key: 'opt-2', title: 'Game Design', createdAt: t0),
        ],
        outcome: DecisionOutcome(
          chosenOptionKey: 'opt-1',
          commitmentNote: 'Fits my thesis topic',
          decidedAt: t0,
        ),
        tagLocalIds: [3, 5],
        status: DecisionStatus.decided,
        syncStatus: SyncStatus.pendingUpdate,
      );

      final saved = await store.putDecision(original);

      expect(saved.localId, isNotNull);
      expect(await store.getDecision(saved.localId!), saved);
      expect(saved.copyWith(localId: null), original);
    });

    test('lists one user\'s decisions, newest first, without deleted ones',
        () async {
      await store.putDecision(decision('Older', updatedAt: t0));
      await store.putDecision(
          decision('Newer', updatedAt: t0.add(const Duration(hours: 1))));
      await store.putDecision(decision('Someone else', userId: 'u2'));
      await store.putDecision(decision('Deleted').copyWith(deletedAt: t0));

      final titles =
          (await store.watchDecisions('u1').first).map((d) => d.title);
      expect(titles, ['Newer', 'Older']);
    });

    test('watching emits again after a change', () async {
      final saved = await store.putDecision(decision('Draft title'));
      final titles = store
          .watchDecision(saved.localId!)
          .map((d) => d?.title)
          .take(2)
          .toList();

      await Future<void>.delayed(const Duration(milliseconds: 50));
      await store.putDecision(saved.copyWith(title: 'Final title'));

      expect(await titles, ['Draft title', 'Final title']);
    });

    test('permanent delete also removes the evaluation and insights', () async {
      final saved = await store.putDecision(decision('Pick an elective'));
      final id = saved.localId!;
      await store.putEvaluation(Evaluation(decisionLocalId: id, createdAt: t0));
      await store.putInsight(AiInsight(
        decisionLocalId: id,
        decisionServerId: 's1',
        triggerContext: TriggerContext.preDecision,
        status: InsightStatus.complete,
        requestedAt: t0,
      ));

      await store.deleteDecisionPermanently(id);

      expect(await store.getDecision(id), isNull);
      expect(await store.getEvaluation(id), isNull);
      expect(await store.getInsights(id, TriggerContext.preDecision), isEmpty);
    });

    test('keeps one evaluation per decision and reads it back', () async {
      final id = (await store.putDecision(decision('Pick an elective'))).localId!;
      final saved = await store.putEvaluation(Evaluation(
        decisionLocalId: id,
        satisfactionAfter: 80,
        confidenceAfter: 70,
        hindsightNotes: 'Glad I chose it',
        createdAt: t0,
      ));

      expect(await store.getEvaluation(id), saved);
      expect(await store.watchEvaluation(id).first, saved);
    });

    test('returns insights for one trigger, newest first', () async {
      final id = (await store.putDecision(decision('Pick an elective'))).localId!;
      AiInsight insight(TriggerContext trigger, int minute) => AiInsight(
            decisionLocalId: id,
            decisionServerId: 's1',
            triggerContext: trigger,
            status: InsightStatus.complete,
            requestedAt: t0.add(Duration(minutes: minute)),
          );
      await store.putInsight(insight(TriggerContext.preDecision, 1));
      await store.putInsight(insight(TriggerContext.preDecision, 2));
      await store.putInsight(insight(TriggerContext.postEvaluation, 3));

      final pre = await store.getInsights(id, TriggerContext.preDecision);
      expect(pre.map((i) => i.requestedAt.minute), [32, 31]);
      expect(await store.watchInsights(id).first, hasLength(3));
    });

    test('tags: sorted by name, hiding those waiting to be deleted', () async {
      await store.putTag(const Tag(userId: 'u1', name: 'Career'));
      await store.putTag(const Tag(userId: 'u1', name: 'Academic'));
      await store.putTag(const Tag(
          userId: 'u1', name: 'Old', syncStatus: SyncStatus.pendingDelete));
      await store.putTag(const Tag(userId: 'u2', name: 'Finance'));

      final visible = await store.watchTags('u1').first;
      expect(visible.map((t) => t.name), ['Academic', 'Career']);
      expect(await store.getTags('u1'), hasLength(3));
    });

    test('tags: a user can\'t have two tags with the same name', () async {
      await store.putTag(const Tag(userId: 'u1', name: 'Academic'));

      await expectLater(
        store.putTag(const Tag(userId: 'u1', name: 'Academic')),
        throwsA(anything),
      );
    });
  });
}
