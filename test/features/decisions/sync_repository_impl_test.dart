// flutter_test has its own Evaluation (an accessibility check result).
import 'package:flutter_test/flutter_test.dart' hide Evaluation;
import 'package:hinsight/src/core/database/sync_status.dart';
import 'package:hinsight/src/core/network/api_exception.dart';
import 'package:hinsight/src/features/decisions/data/local/memory_decision_local_data_source.dart';
import 'package:hinsight/src/features/decisions/data/remote/decision_remote_data_source.dart';
import 'package:hinsight/src/features/decisions/data/remote/fake_decision_remote_data_source.dart';
import 'package:hinsight/src/features/decisions/data/repositories/decision_repository_impl.dart';
import 'package:hinsight/src/features/decisions/data/repositories/sync_repository_impl.dart';
import 'package:hinsight/src/features/decisions/domain/entities/decision.dart';
import 'package:hinsight/src/features/decisions/domain/entities/decision_enums.dart';
import 'package:hinsight/src/features/tags/domain/entities/tag.dart';

/// The fake server, plus hooks to act while a request is "in flight" or to
/// refuse one.
class _HookedServer extends FakeDecisionRemoteDataSource {
  _HookedServer(DateTime Function() clock)
      : super(latency: Duration.zero, clock: clock);

  Future<void> Function(Decision sent)? whileSending;
  ApiException? Function(Decision sent)? refuse;
  Future<void> Function(Tag sent)? whileSendingTag;
  ApiException? tagError;

  Future<void> _before(Decision d) async {
    final error = refuse?.call(d);
    if (error != null) throw error;
    await whileSending?.call(d);
  }

  @override
  Future<RemoteDecisionIds> createDecision(
    Decision decision, {
    required List<String> tagServerIds,
  }) async {
    await _before(decision);
    return super.createDecision(decision, tagServerIds: tagServerIds);
  }

  @override
  Future<RemoteDecisionIds> updateDecision(
    Decision decision, {
    required List<String> tagServerIds,
  }) async {
    await _before(decision);
    return super.updateDecision(decision, tagServerIds: tagServerIds);
  }

  @override
  Future<String> createTag(Tag tag) async {
    if (tagError != null) throw tagError!;
    await whileSendingTag?.call(tag);
    return super.createTag(tag);
  }
}

void main() {
  late MemoryDecisionLocalDataSource local;
  late _HookedServer server;
  late DateTime now;
  late SyncRepositoryImpl sync;
  late DecisionRepositoryImpl repo;

  setUp(() {
    local = MemoryDecisionLocalDataSource();
    now = DateTime(2026, 11, 4, 10);
    server = _HookedServer(() => now);
    sync = SyncRepositoryImpl(
        local: local, remote: server, userId: 'u1', clock: () => now);
    repo = DecisionRepositoryImpl(
        local: local, remote: server, sync: sync, userId: 'u1', clock: () => now);
  });

  const draft = DecisionDraft(
    title: 'Pick an elective',
    confidenceBefore: 60,
    options: [
      OptionDraft(title: 'Data Mining', pros: ['Thesis topic'], cons: ['Workload']),
      OptionDraft(title: 'Game Design'),
    ],
  );

  void later([int minutes = 1]) => now = now.add(Duration(minutes: minutes));

  Future<Decision> stored(Decision d) async => (await local.getDecision(d.localId!))!;

  /// A decision that is already on the server.
  Future<Decision> synced([DecisionDraft from = draft]) async {
    final d = await repo.createDecision(from);
    await sync.syncPendingChanges();
    return stored(d);
  }

  group('sending new records (pendingCreate → POST)', () {
    test('tags, then decisions, then evaluations, each with server ids',
        () async {
      final tag = await repo.createTag('Academic');
      final d = await repo.createDecision(draft.copyWith(tagLocalIds: [tag.localId!]));
      await repo.commitDecision(d.localId!, chosenOptionKey: d.options.last.key);
      await repo.evaluateDecision(d.localId!, satisfactionAfter: 70);

      final report = await sync.syncPendingChanges();

      expect(report.sent, 3);
      expect(report.failures, isEmpty);
      expect(report.remaining, 0);
      expect(report.reachedServer, isTrue);

      final after = await stored(d);
      final tagAfter = (await local.getTag(tag.localId!))!;
      final evaluation = (await local.getEvaluation(d.localId!))!;
      expect(after.syncStatus, SyncStatus.synced);
      expect(after.options.every((o) => o.serverId != null), isTrue);
      expect(tagAfter.syncStatus, SyncStatus.synced);
      expect(evaluation.syncStatus, SyncStatus.synced);
      expect(evaluation.decisionServerId, after.serverId);

      final onServer = server.serverCopy(after.serverId!)!;
      expect(onServer.tagIds, [tagAfter.serverId]);
      expect(onServer.outcome!.chosenOptionId, after.options.last.serverId);
      expect(server.serverEvaluation(after.serverId!)!.serverId,
          evaluation.serverId);
    });

    test('only the signed-in user\'s changes are sent', () async {
      final theirs = await DecisionRepositoryImpl(
              local: local, remote: server, sync: sync, userId: 'u2')
          .createDecision(draft);

      await sync.syncPendingChanges();

      expect((await stored(theirs)).syncStatus, SyncStatus.pendingCreate);
      expect(server.decisionCount, 0);
    });

    test('only one sync runs at a time, so nothing is created twice',
        () async {
      final slow = FakeDecisionRemoteDataSource(
          latency: const Duration(milliseconds: 20));
      final slowSync = SyncRepositoryImpl(local: local, remote: slow, userId: 'u1');
      await repo.createDecision(draft);

      await Future.wait(
          [slowSync.syncPendingChanges(), slowSync.syncPendingChanges()]);

      expect(slow.decisionCount, 1);
    });
  });

  group('sending edits (pendingUpdate → PUT, last write wins)', () {
    test('an edit reaches the server with its updated_at', () async {
      final d = await synced();
      later();
      await repo.updateDecision(d.localId!, draft.copyWith(title: 'Pick one elective'));

      final report = await sync.syncPendingChanges();

      final after = await stored(d);
      expect(report.sent, 1);
      expect(after.syncStatus, SyncStatus.synced);
      final onServer = server.serverCopy(after.serverId!)!;
      expect(onServer.title, 'Pick one elective');
      expect(onServer.updatedAt, after.updatedAt);
    });

    test('409: the server\'s newer copy replaces the one on the phone',
        () async {
      final d = await synced();
      later(5);
      // Edited as the form does, keeping each option's key.
      await repo.updateDecision(
        d.localId!,
        DecisionDraft(title: 'From the phone', options: [
          for (final o in d.options)
            OptionDraft(key: o.key, title: o.title, pros: o.pros, cons: o.cons),
        ]),
      );
      server.editElsewhere(d.serverId!,
          title: 'From the laptop', at: now.add(const Duration(minutes: 5)));

      final report = await sync.syncPendingChanges();

      final after = await stored(d);
      expect(report.serverVersionsKept, ['From the phone']);
      expect(after.title, 'From the laptop');
      expect(after.syncStatus, SyncStatus.synced);
      // Options keep their local keys, matched by server id.
      expect(after.options.map((o) => o.key), d.options.map((o) => o.key));
    });

    test('a newer edit on the phone wins over an older one on the server',
        () async {
      final d = await synced();
      server.editElsewhere(d.serverId!,
          title: 'From the laptop', at: now.add(const Duration(minutes: 5)));
      later(10);
      await repo.updateDecision(d.localId!, draft.copyWith(title: 'From the phone'));

      final report = await sync.syncPendingChanges();

      expect(report.serverVersionsKept, isEmpty);
      expect(server.serverCopy(d.serverId!)!.title, 'From the phone');
    });

    test('a conflict never undoes a commitment made on the phone', () async {
      final d = await synced();
      later(5);
      await repo.commitDecision(d.localId!, chosenOptionKey: d.options.first.key);
      server.editElsewhere(d.serverId!,
          title: 'Renamed elsewhere', at: now.add(const Duration(minutes: 5)));

      await sync.syncPendingChanges();

      final merged = await stored(d);
      expect(merged.title, 'Renamed elsewhere');
      expect(merged.status, DecisionStatus.decided);
      expect(merged.chosenOption!.title, 'Data Mining');
      expect(merged.syncStatus, SyncStatus.pendingUpdate);

      await sync.syncPendingChanges(); // Sent again as the newer change
      final onServer = server.serverCopy(d.serverId!)!;
      expect((await stored(d)).syncStatus, SyncStatus.synced);
      expect(onServer.title, 'Renamed elsewhere');
      expect(onServer.outcome, isNotNull);
    });

    test('a decision deleted on another device is removed from the phone',
        () async {
      final d = await synced();
      later();
      await repo.updateDecision(d.localId!, draft.copyWith(title: 'Edited'));
      server.editElsewhere(d.serverId!,
          at: now.add(const Duration(minutes: 1)), delete: true);

      await sync.syncPendingChanges();

      expect(await local.getDecision(d.localId!), isNull);
    });

    test('404: a server that lost the decision gets it again, as new',
        () async {
      final d = await synced();
      server.reset(); // e.g. its database was reset
      later();
      await repo.updateDecision(d.localId!, draft.copyWith(title: 'Edited'));

      final report = await sync.syncPendingChanges();

      final after = await stored(d);
      expect(report.failures, isEmpty);
      expect(after.syncStatus, SyncStatus.synced);
      expect(after.serverId, isNot(d.serverId));
      expect(server.serverCopy(after.serverId!)!.title, 'Edited');
    });

    test('404: the evaluation is sent again with its decision', () async {
      final tag = await repo.createTag('Academic');
      final d = await repo.createDecision(draft.copyWith(tagLocalIds: [tag.localId!]));
      await repo.commitDecision(d.localId!, chosenOptionKey: d.options.first.key);
      await repo.evaluateDecision(d.localId!, satisfactionAfter: 70);
      await sync.syncPendingChanges();
      server.reset();
      later();
      await repo.deleteTag(tag.localId!); // Changes the decision too

      final report = await sync.syncPendingChanges();

      final after = await stored(d);
      final evaluation = (await local.getEvaluation(d.localId!))!;
      expect(report.remaining, 0);
      expect(after.syncStatus, SyncStatus.synced);
      expect(evaluation.syncStatus, SyncStatus.synced);
      expect(server.serverEvaluation(after.serverId!)!.serverId,
          evaluation.serverId);
    });
  });

  group('sending deletions (pendingDelete → DELETE)', () {
    test('the server is told first, then the decision leaves the phone',
        () async {
      final d = await synced();
      await repo.commitDecision(d.localId!, chosenOptionKey: d.options.first.key);
      await repo.evaluateDecision(d.localId!, satisfactionAfter: 70);
      await sync.syncPendingChanges();
      later();
      await repo.deleteDecision(d.localId!);

      final report = await sync.syncPendingChanges();

      expect(report.sent, 1);
      expect(server.serverCopy(d.serverId!)!.deletedAt, isNotNull);
      expect(await local.getDecision(d.localId!), isNull);
      expect(await local.getEvaluation(d.localId!), isNull);
    });

    test('404: already gone on the server, so it just leaves the phone',
        () async {
      final d = await synced();
      server.reset();
      await repo.deleteDecision(d.localId!);

      final report = await sync.syncPendingChanges();

      expect(report.failures, isEmpty);
      expect(await local.getDecision(d.localId!), isNull);
    });

    test('409: a newer change on the server brings the decision back',
        () async {
      final d = await synced();
      later(5);
      await repo.deleteDecision(d.localId!);
      server.editElsewhere(d.serverId!,
          title: 'Still deciding', at: now.add(const Duration(minutes: 5)));

      final report = await sync.syncPendingChanges();

      final back = await stored(d);
      expect(report.serverVersionsKept, ['Pick an elective']);
      expect(back.deletedAt, isNull);
      expect(back.title, 'Still deciding');
      expect(back.syncStatus, SyncStatus.synced);
      expect(await repo.watchDecisions().first, hasLength(1));
    });
  });

  group('changes made while a request is out', () {
    test('a deletion during an edit\'s request is still sent', () async {
      final d = await synced();
      later();
      await repo.updateDecision(d.localId!, draft.copyWith(title: 'Edited'));
      server.whileSending = (_) async {
        server.whileSending = null;
        later();
        await repo.deleteDecision(d.localId!);
      };

      await sync.syncPendingChanges();
      // It must stay marked for deletion, not become a plain edit.
      expect((await stored(d)).syncStatus, SyncStatus.pendingDelete);

      await sync.syncPendingChanges();
      expect(server.serverCopy(d.serverId!)!.deletedAt, isNotNull);
      expect(await local.getDecision(d.localId!), isNull);
    });

    test('an edit during a create is kept and sent next', () async {
      final d = await repo.createDecision(draft);
      server.whileSending = (_) async {
        server.whileSending = null;
        later();
        await repo.updateDecision(d.localId!, draft.copyWith(title: 'Edited'));
      };

      final first = await sync.syncPendingChanges();
      expect(first.remaining, 1);
      expect((await stored(d)).syncStatus, SyncStatus.pendingUpdate);

      await sync.syncPendingChanges();
      final after = await stored(d);
      expect(after.syncStatus, SyncStatus.synced);
      expect(server.serverCopy(after.serverId!)!.title, 'Edited');
    });
  });

  group('failures', () {
    test('offline: stops at once and keeps every change on the phone',
        () async {
      final a = await repo.createDecision(draft);
      final b = await repo.createDecision(draft.copyWith(title: 'Pick a club'));
      server.failWith = FakeDecisionRemoteDataSource.offline;

      final report = await sync.syncPendingChanges();

      expect(report.offline, isTrue);
      expect(report.stopMessage, contains("Can't reach the server"));
      expect(report.reachedServer, isFalse);
      expect(report.remaining, 2);
      expect(report.shouldRetry, isTrue);
      expect((await stored(a)).syncStatus, SyncStatus.pendingCreate);
      expect((await stored(b)).syncStatus, SyncStatus.pendingCreate);
    });

    test('an ended session (401) stops the sync', () async {
      await repo.createDecision(draft);
      server.failWith =
          const ApiException('Your session has ended.', statusCode: 401);

      final report = await sync.syncPendingChanges();

      expect(report.offline, isFalse);
      expect(report.stopMessage, 'Your session has ended.');
      expect(report.remaining, 1);
    });

    test('a refused decision is reported and doesn\'t hold up the others',
        () async {
      final refused = await repo.createDecision(draft.copyWith(title: 'Refused'));
      final fine = await repo.createDecision(draft);
      server.refuse = (d) => d.title == 'Refused'
          ? const ApiException('Something went wrong (error 500).',
              statusCode: 500)
          : null;

      final report = await sync.syncPendingChanges();

      expect(report.failures,
          ['"Refused": Something went wrong (error 500).']);
      expect(report.shouldRetry, isTrue);
      expect(report.remaining, 1);
      expect((await stored(refused)).syncStatus, SyncStatus.pendingCreate);
      expect((await stored(fine)).syncStatus, SyncStatus.synced);
    });

    test('a decision waits for a tag that couldn\'t be sent', () async {
      final tag = await repo.createTag('Academic');
      final d = await repo.createDecision(draft.copyWith(tagLocalIds: [tag.localId!]));
      server.tagError =
          const ApiException('Something went wrong.', statusCode: 500);

      final report = await sync.syncPendingChanges();

      expect(report.failures, [
        'Tag "Academic": Something went wrong.',
        '"Pick an elective" waits until its tags are synced.',
      ]);
      expect((await stored(d)).serverId, isNull);
      expect(server.decisionCount, 0);
    });
  });

  group('tags', () {
    test('a deleted tag is deleted on the server, then on the phone',
        () async {
      final tag = await repo.createTag('Academic');
      await sync.syncPendingChanges();
      final serverId = (await local.getTag(tag.localId!))!.serverId!;
      await repo.deleteTag(tag.localId!);

      await sync.syncPendingChanges();

      expect(server.serverTag(serverId), isNull);
      expect(await local.getTag(tag.localId!), isNull);
    });

    test('a tag deleted on the phone while being created is deleted there too',
        () async {
      final tag = await repo.createTag('Academic');
      server.whileSendingTag = (_) => repo.deleteTag(tag.localId!);

      final report = await sync.syncPendingChanges();

      expect(report.remaining, 0);
      expect(await local.getTag(tag.localId!), isNull);
      expect(server.tagCount, 0); // The server's copy was deleted right away
    });
  });

  test('counts the changes still waiting', () async {
    await repo.createTag('Academic');
    await repo.createDecision(draft);
    expect(await sync.watchPendingChanges().first, 2);

    await sync.syncPendingChanges();
    expect(await sync.watchPendingChanges().first, 0);
  });
}
