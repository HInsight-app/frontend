// flutter_test has its own Evaluation (an accessibility check result).
import 'package:flutter_test/flutter_test.dart' hide Evaluation;
import 'package:hinsight/src/core/database/sync_status.dart';
import 'package:hinsight/src/core/network/api_exception.dart';
import 'package:hinsight/src/features/decisions/data/local/memory_decision_local_data_source.dart';
import 'package:hinsight/src/features/decisions/data/remote/decision_remote_data_source.dart';
import 'package:hinsight/src/features/decisions/data/remote/fake_decision_remote_data_source.dart';
import 'package:hinsight/src/features/decisions/data/repositories/decision_repository_impl.dart';
import 'package:hinsight/src/features/decisions/data/repositories/sync_repository_impl.dart';
import 'package:hinsight/src/features/decisions/domain/entities/ai_insight.dart';
import 'package:hinsight/src/features/decisions/domain/entities/decision.dart';
import 'package:hinsight/src/features/decisions/domain/entities/decision_enums.dart';
import 'package:hinsight/src/features/decisions/domain/entities/decision_exception.dart';

/// A fake server that lets a test act while a create request is "in flight".
class _SlowRemote extends FakeDecisionRemoteDataSource {
  _SlowRemote() : super(latency: Duration.zero);

  Future<void> Function()? duringCreate;

  @override
  Future<RemoteDecisionIds> createDecision(
    Decision decision, {
    required List<String> tagServerIds,
  }) async {
    await duringCreate?.call();
    return super.createDecision(decision, tagServerIds: tagServerIds);
  }
}

void main() {
  late MemoryDecisionLocalDataSource local;
  late _SlowRemote remote;
  late DateTime now;
  late DecisionRepositoryImpl repo;

  DecisionRepositoryImpl repositoryFor(String userId) => DecisionRepositoryImpl(
        local: local,
        remote: remote,
        sync: SyncRepositoryImpl(
            local: local, remote: remote, userId: userId, clock: () => now),
        userId: userId,
        clock: () => now,
      );

  setUp(() {
    local = MemoryDecisionLocalDataSource();
    remote = _SlowRemote();
    now = DateTime(2026, 11, 4, 10);
    repo = repositoryFor('u1');
  });

  const twoOptions = DecisionDraft(
    title: '  Pick an elective  ',
    context: '   ',
    confidenceBefore: 60,
    options: [
      OptionDraft(title: 'Data Mining', pros: ['Thesis topic', '  '], cons: ['Workload']),
      OptionDraft(title: 'Game Design'),
    ],
  );

  Matcher brokenRule(String containing) => throwsA(
      isA<DecisionException>().having((e) => e.message, 'message', contains(containing)));

  Future<Decision> committed() async {
    final d = await repo.createDecision(twoOptions);
    return repo.commitDecision(d.localId!, chosenOptionKey: d.options.first.key);
  }

  group('creating and editing', () {
    test('saves a cleaned-up decision marked for sync', () async {
      final d = await repo.createDecision(twoOptions);

      expect(d.title, 'Pick an elective');
      expect(d.context, isNull);
      expect(d.status, DecisionStatus.pending);
      expect(d.syncStatus, SyncStatus.pendingCreate);
      expect(d.options.first.pros, ['Thesis topic']);
      expect(d.options.map((o) => o.key).toSet(), hasLength(2));
    });

    test('rejects a missing title, a bad confidence and duplicate options',
        () async {
      expect(repo.createDecision(const DecisionDraft(title: ' ')),
          brokenRule('title'));
      expect(
          repo.createDecision(
              const DecisionDraft(title: 'X', confidenceBefore: 101)),
          brokenRule('between 1 and 100'));
      expect(
          repo.createDecision(const DecisionDraft(title: 'X', options: [
            OptionDraft(title: 'Internship'),
            OptionDraft(title: ' internship '),
          ])),
          brokenRule('Two options'));
      expect(
          repo.createDecision(
              const DecisionDraft(title: 'X', options: [OptionDraft(title: '')])),
          brokenRule('needs a title'));
    });

    test('editing keeps existing option ids and marks a synced decision',
        () async {
      final d = await repo.createDecision(twoOptions);
      await local.putDecision(d.copyWith(syncStatus: SyncStatus.synced));
      final kept = d.options.first;

      now = now.add(const Duration(minutes: 5));
      final edited = await repo.updateDecision(
        d.localId!,
        DecisionDraft(title: 'Pick an elective', options: [
          OptionDraft(key: kept.key, title: 'Data Mining (Mon)'),
          const OptionDraft(title: 'Ethics'),
        ]),
      );

      expect(edited.options.first.key, kept.key);
      expect(edited.options.first.createdAt, kept.createdAt);
      expect(edited.options.last.key, isNot(kept.key));
      expect(edited.syncStatus, SyncStatus.pendingUpdate);
      expect(edited.updatedAt, now);
    });

    test('an unsynced decision stays pendingCreate when edited', () async {
      final d = await repo.createDecision(twoOptions);
      final edited =
          await repo.updateDecision(d.localId!, const DecisionDraft(title: 'New'));
      expect(edited.syncStatus, SyncStatus.pendingCreate);
    });

    test('a committed decision can no longer be edited', () async {
      final d = await committed();
      expect(repo.updateDecision(d.localId!, const DecisionDraft(title: 'New')),
          brokenRule("can't be edited"));
    });
  });

  group('deleting', () {
    test('a decision never synced is removed completely', () async {
      final d = await repo.createDecision(twoOptions);
      await repo.deleteDecision(d.localId!);
      expect(await local.getDecision(d.localId!), isNull);
    });

    test('a synced decision is hidden and marked for the server', () async {
      final d = await repo.createDecision(twoOptions);
      await local.putDecision(d.copyWith(syncStatus: SyncStatus.synced));

      await repo.deleteDecision(d.localId!);

      final stored = await local.getDecision(d.localId!);
      expect(stored!.syncStatus, SyncStatus.pendingDelete);
      expect(stored.deletedAt, now);
      expect(await repo.watchDecisions().first, isEmpty);
      expect(await repo.watchDecision(d.localId!).first, isNull);
    });
  });

  group('committing and evaluating', () {
    test('committing records the choice and the status becomes decided',
        () async {
      final d = await repo.createDecision(twoOptions);
      final c = await repo.commitDecision(d.localId!,
          chosenOptionKey: d.options.last.key, commitmentNote: ' Sounds fun ');

      expect(c.status, DecisionStatus.decided);
      expect(c.chosenOption!.title, 'Game Design');
      expect(c.outcome!.commitmentNote, 'Sounds fun');
      expect(c.outcome!.decidedAt, now);
    });

    test('only one of the decision\'s options can be chosen, once', () async {
      final d = await repo.createDecision(twoOptions);
      expect(repo.commitDecision(d.localId!, chosenOptionKey: 'nope'),
          brokenRule("this decision's options"));

      await repo.commitDecision(d.localId!, chosenOptionKey: d.options.first.key);
      expect(repo.commitDecision(d.localId!, chosenOptionKey: d.options.first.key),
          brokenRule('already committed'));
    });

    test('evaluating needs a commit first and happens only once', () async {
      final pending = await repo.createDecision(twoOptions);
      expect(repo.evaluateDecision(pending.localId!, satisfactionAfter: 50),
          brokenRule('Commit to an option'));

      final d = await committed();
      expect(repo.evaluateDecision(d.localId!, satisfactionAfter: 0),
          brokenRule('between 1 and 100'));

      final e = await repo.evaluateDecision(d.localId!,
          satisfactionAfter: 80, confidenceAfter: 70, hindsightNotes: ' Good ');
      expect(e.hindsightNotes, 'Good');
      expect(e.syncStatus, SyncStatus.pendingCreate);

      final after = await local.getDecision(d.localId!);
      expect(after!.status, DecisionStatus.evaluated);
      // Status is local only: no sync change, no new updatedAt.
      expect(after.syncStatus, d.syncStatus);
      expect(after.updatedAt, d.updatedAt);

      expect(repo.evaluateDecision(d.localId!, satisfactionAfter: 90),
          brokenRule('already evaluated'));
    });
  });

  group('listing', () {
    test('filters by status and searches titles, context and options',
        () async {
      await repo.createDecision(twoOptions);
      await repo.createDecision(const DecisionDraft(
          title: 'Take the internship', context: 'Offer from a startup'));
      final c = await committed();

      expect((await repo.watchDecisions(status: DecisionStatus.decided).first)
          .map((d) => d.localId), [c.localId]);
      expect(await repo.watchDecisions(search: 'STARTUP').first, hasLength(1));
      expect(await repo.watchDecisions(search: 'game design').first, hasLength(2));
    });

    test('another user\'s decisions are invisible', () async {
      final mine = await repo.createDecision(twoOptions);
      final other = repositoryFor('u2');

      expect(await other.watchDecisions().first, isEmpty);
      expect(other.deleteDecision(mine.localId!), brokenRule('no longer exists'));
    });
  });

  group('AI insights', () {
    test('a request sends the decision to the server, then stores the result',
        () async {
      final d = await repo.createDecision(twoOptions);

      final insight = await repo.requestInsight(d.localId!, TriggerContext.preDecision);

      final stored = await local.getDecision(d.localId!);
      expect(stored!.serverId, isNotNull);
      expect(stored.syncStatus, SyncStatus.synced);
      expect(stored.options.every((o) => o.serverId != null), isTrue);
      expect(insight.status, InsightStatus.complete);
      expect(insight.decisionServerId, stored.serverId);
      expect(insight.insightText, startsWith('Sample analysis'));
    });

    test('pre-decision is only before committing; look back only after evaluating',
        () async {
      final d = await committed();
      expect(repo.requestInsight(d.localId!, TriggerContext.preDecision),
          brokenRule("haven't committed"));
      expect(repo.requestInsight(d.localId!, TriggerContext.postEvaluation),
          brokenRule('Evaluate the decision'));
    });

    test('a second request while one is processing is refused', () async {
      final d = await repo.createDecision(twoOptions);
      await local.putInsight(AiInsight(
        decisionLocalId: d.localId!,
        decisionServerId: 's1',
        triggerContext: TriggerContext.preDecision,
        status: InsightStatus.processing,
        requestedAt: now.subtract(const Duration(minutes: 1)),
      ));

      expect(repo.requestInsight(d.localId!, TriggerContext.preDecision),
          brokenRule('already checking'));
    });

    test('a request stuck from an earlier run is marked failed and retried',
        () async {
      final d = await repo.createDecision(twoOptions);
      final stuck = await local.putInsight(AiInsight(
        decisionLocalId: d.localId!,
        decisionServerId: 's1',
        triggerContext: TriggerContext.preDecision,
        status: InsightStatus.processing,
        requestedAt: now.subtract(DecisionRepositoryImpl.processingTimeout),
      ));

      final fresh = await repo.requestInsight(d.localId!, TriggerContext.preDecision);

      final all = await local.getInsights(d.localId!, TriggerContext.preDecision);
      expect(all.firstWhere((i) => i.localId == stuck.localId).status,
          InsightStatus.failed);
      expect(fresh.status, InsightStatus.complete);
    });

    test('offline: nothing is recorded and the error reaches the caller',
        () async {
      final d = await repo.createDecision(twoOptions);
      remote.failWith = const ApiException("Can't reach the server.",
          isConnectionProblem: true);

      await expectLater(repo.requestInsight(d.localId!, TriggerContext.preDecision),
          throwsA(isA<ApiException>()));
      expect(await local.getInsights(d.localId!, TriggerContext.preDecision), isEmpty);
      expect((await local.getDecision(d.localId!))!.syncStatus,
          SyncStatus.pendingCreate);
    });

    test('a failed AI call leaves a failed insight behind', () async {
      final d = await repo.createDecision(twoOptions);
      await repo.requestInsight(d.localId!, TriggerContext.preDecision);
      now = now.add(const Duration(minutes: 1)); // So "newest" is unambiguous
      remote.failWith = const ApiException('Gemini is unavailable', statusCode: 503);

      await expectLater(repo.requestInsight(d.localId!, TriggerContext.preDecision),
          throwsA(isA<ApiException>()));
      final latest =
          (await local.getInsights(d.localId!, TriggerContext.preDecision)).first;
      expect(latest.status, InsightStatus.failed);
    });

    test('edits made while the decision is being sent are kept for next sync',
        () async {
      final d = await repo.createDecision(twoOptions);
      remote.duringCreate = () async {
        now = now.add(const Duration(seconds: 1));
        await repo.updateDecision(
            d.localId!, twoOptions.copyWith(title: 'Edited meanwhile'));
      };

      await repo.requestInsight(d.localId!, TriggerContext.preDecision);

      final stored = await local.getDecision(d.localId!);
      expect(stored!.title, 'Edited meanwhile');
      expect(stored.serverId, isNotNull);
      expect(stored.syncStatus, SyncStatus.pendingUpdate);
    });

    test('a decision deleted while it is being sent is not brought back',
        () async {
      final d = await repo.createDecision(twoOptions);
      remote.duringCreate = () => repo.deleteDecision(d.localId!);

      await expectLater(repo.requestInsight(d.localId!, TriggerContext.preDecision),
          brokenRule('no longer exists'));

      expect(await repo.watchDecisions().first, isEmpty);
      expect(await local.getInsights(d.localId!, TriggerContext.preDecision),
          isEmpty);
      // The server got it before the delete, so it is deleted there next.
      remote.duringCreate = null;
      final serverId = (await local.getDecision(d.localId!))!.serverId!;
      await repo.sync.syncPendingChanges();
      expect(remote.serverCopy(serverId)!.deletedAt, isNotNull);
      expect(await local.getDecision(d.localId!), isNull);
    });

    test('a server that forgot the decision gets it again, then answers',
        () async {
      final d = await repo.createDecision(twoOptions);
      await repo.requestInsight(d.localId!, TriggerContext.preDecision);
      final firstServerId = (await local.getDecision(d.localId!))!.serverId;
      remote.reset(); // e.g. the fake server after an app restart
      now = now.add(const Duration(minutes: 1));

      final insight =
          await repo.requestInsight(d.localId!, TriggerContext.preDecision);

      final stored = await local.getDecision(d.localId!);
      expect(insight.status, InsightStatus.complete);
      expect(stored!.serverId, isNot(firstServerId));
      expect(insight.decisionServerId, stored.serverId);
      expect(stored.syncStatus, SyncStatus.synced);
    });

    test('a decision deleted on another device is removed here', () async {
      final d = await repo.createDecision(twoOptions);
      await repo.requestInsight(d.localId!, TriggerContext.preDecision);
      final serverId = (await local.getDecision(d.localId!))!.serverId!;
      remote.editElsewhere(serverId,
          at: now.add(const Duration(minutes: 1)), delete: true);
      now = now.add(const Duration(minutes: 2));

      await expectLater(repo.requestInsight(d.localId!, TriggerContext.preDecision),
          brokenRule('deleted on another device'));
      expect(await local.getDecision(d.localId!), isNull);
    });

    test('a look back sends the evaluation and compares confidence', () async {
      final d = await committed();
      await repo.evaluateDecision(d.localId!,
          satisfactionAfter: 40, confidenceAfter: 30);

      final insight =
          await repo.requestInsight(d.localId!, TriggerContext.postEvaluation);

      final evaluation = await local.getEvaluation(d.localId!);
      expect(evaluation!.syncStatus, SyncStatus.synced);
      expect(evaluation.serverId, isNotNull);
      expect(insight.primaryBias, BiasType.overconfidence); // 60% → 30%
    });
  });

  group('tags', () {
    test('names are unique per user, ignoring case; colours are checked',
        () async {
      await repo.createTag('Academic');
      expect(repo.createTag(' academic '), brokenRule('already have a tag'));
      expect(repo.createTag('Career', colorHex: 'purple'), brokenRule('#8771FF'));
    });

    test('deleting a tag removes it from decisions', () async {
      final tag = await repo.createTag('Academic');
      final d = await repo.createDecision(
          twoOptions.copyWith(tagLocalIds: [tag.localId!]));
      await local.putDecision(d.copyWith(syncStatus: SyncStatus.synced));

      await repo.deleteTag(tag.localId!);

      final stored = await local.getDecision(d.localId!);
      expect(stored!.tagLocalIds, isEmpty);
      expect(stored.syncStatus, SyncStatus.pendingUpdate);
      expect(await local.getTag(tag.localId!), isNull); // Never synced
    });

    test('re-creating a tag waiting to be deleted brings it back', () async {
      final tag = await repo.createTag('Academic');
      await local.putTag(tag.copyWith(serverId: 't1', syncStatus: SyncStatus.synced));
      await repo.deleteTag(tag.localId!);
      expect(await repo.watchTags().first, isEmpty);

      final back = await repo.createTag('ACADEMIC');

      expect(back.localId, tag.localId);
      expect(back.syncStatus, SyncStatus.synced);
      expect(await repo.watchTags().first, hasLength(1));
    });
  });
}
