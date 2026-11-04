import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hinsight/src/core/database/sync_status.dart';
import 'package:hinsight/src/core/network/connection_status.dart';
import 'package:hinsight/src/features/auth/auth.dart';
import 'package:hinsight/src/features/decisions/data/remote/fake_decision_remote_data_source.dart';
import 'package:hinsight/src/features/decisions/decisions_providers.dart';
import 'package:hinsight/src/features/decisions/domain/entities/decision.dart';
import 'package:hinsight/src/features/decisions/presentation/sync_controller.dart';

import '../../helpers/fake_auth.dart';
import '../../helpers/fake_decisions.dart';

// testWidgets runs on fake time, so the controller's timers can be stepped
// through with tester.pump(duration).

const _timing = SyncTiming(
  afterChange: Duration(seconds: 2),
  firstRetry: Duration(seconds: 15),
  maxRetry: Duration(minutes: 1),
);

const _draft = DecisionDraft(title: 'Pick an elective');

void main() {
  late FakeDecisionRemoteDataSource server;

  ProviderContainer containerFor({AuthUser? user = testUser}) {
    server = FakeDecisionRemoteDataSource(latency: Duration.zero);
    return ProviderContainer(overrides: [
      authRepositoryProvider.overrideWithValue(FakeAuthRepository(savedUser: user)),
      ...decisionOverrides(server: server, autoSync: true),
      syncTimingProvider.overrideWithValue(_timing),
    ]);
  }

  /// Starts the controller as the app does, once the session is restored.
  /// Each test disposes the container at the end, so no timer outlives it.
  Future<void> run(WidgetTester tester, ProviderContainer c) async {
    c.listen(syncControllerProvider, (_, __) {});
    await tester.pump(const Duration(milliseconds: 10));
  }

  Future<Decision> stored(ProviderContainer c, Decision d) async =>
      (await c.read(decisionLocalDataSourceProvider).getDecision(d.localId!))!;

  testWidgets('syncs what was waiting as soon as the student is signed in',
      (tester) async {
    final c = containerFor();
    final waiting = await c.read(decisionLocalDataSourceProvider).putDecision(
        Decision(
            userId: testUser.id,
            title: 'Saved before the app closed',
            createdAt: DateTime(2026, 11, 4),
            updatedAt: DateTime(2026, 11, 4)));

    await run(tester, c);

    expect((await stored(c, waiting)).syncStatus, SyncStatus.synced);
    c.dispose();
  });

  testWidgets('a change is sent shortly after it is saved', (tester) async {
    final c = containerFor();
    await run(tester, c);

    final d = await c.read(decisionRepositoryProvider).createDecision(_draft);
    await tester.pump(const Duration(seconds: 1));
    expect(c.read(syncControllerProvider).pending, 1);
    expect((await stored(c, d)).syncStatus, SyncStatus.pendingCreate);

    await tester.pump(const Duration(seconds: 1));
    expect((await stored(c, d)).syncStatus, SyncStatus.synced);
    expect(c.read(syncControllerProvider).pending, 0);
    c.dispose();
  });

  testWidgets('offline: says so, and syncs as soon as a call gets through',
      (tester) async {
    final c = containerFor();
    await run(tester, c);
    server.failWith = FakeDecisionRemoteDataSource.offline;
    final d = await c.read(decisionRepositoryProvider).createDecision(_draft);
    await tester.pump(const Duration(seconds: 3));

    final state = c.read(syncControllerProvider);
    expect(state.offline, isTrue);
    expect(state.pending, 1);
    expect(state.lastReport!.offline, isTrue);
    expect(c.read(connectionStatusProvider), ConnectionStatus.offline);

    // What ConnectivityInterceptor does when any API call succeeds again.
    server.failWith = null;
    c.read(connectionStatusProvider.notifier).reportOnline();
    await tester.pump(const Duration(milliseconds: 10));

    expect((await stored(c, d)).syncStatus, SyncStatus.synced);
    expect(c.read(syncControllerProvider).offline, isFalse);
    c.dispose();
  });

  testWidgets('after a failure it tries again, waiting longer each time',
      (tester) async {
    final c = containerFor();
    await run(tester, c);
    server.failWith = FakeDecisionRemoteDataSource.offline;
    final d = await c.read(decisionRepositoryProvider).createDecision(_draft);
    await tester.pump(const Duration(seconds: 2)); // 1st try fails
    await tester.pump(const Duration(seconds: 15)); // 2nd try fails
    server.failWith = null;

    await tester.pump(const Duration(seconds: 29)); // The 3rd waits 30 s
    expect((await stored(c, d)).syncStatus, SyncStatus.pendingCreate);

    await tester.pump(const Duration(seconds: 1));
    expect((await stored(c, d)).syncStatus, SyncStatus.synced);
    c.dispose();
  });

  testWidgets('a change made while offline is retried, not forgotten',
      (tester) async {
    final c = containerFor();
    await run(tester, c);
    // Known to be offline, with nothing waiting and so no retry planned.
    c.read(connectionStatusProvider.notifier).reportOffline();
    await tester.pump(const Duration(milliseconds: 10));

    final d = await c.read(decisionRepositoryProvider).createDecision(_draft);
    await tester.pump(const Duration(seconds: 15));

    expect((await stored(c, d)).syncStatus, SyncStatus.synced);
    c.dispose();
  });

  testWidgets('nothing is synced while signed out', (tester) async {
    final c = containerFor(user: null);
    await run(tester, c);
    final d = await c.read(decisionRepositoryProvider).createDecision(_draft);
    await tester.pump(const Duration(seconds: 30));

    expect((await stored(c, d)).syncStatus, SyncStatus.pendingCreate);
    expect(server.decisionCount, 0);
    c.dispose();
  });

  testWidgets('the dashboard banner says what is waiting, and Try again works',
      (tester) async {
    final offlineServer = FakeDecisionRemoteDataSource(latency: Duration.zero)
      ..failWith = FakeDecisionRemoteDataSource.offline;
    final c = await pumpSignedInApp(tester,
        server: offlineServer,
        autoSync: true,
        overrides: [syncTimingProvider.overrideWithValue(_timing)]);
    await c.read(decisionRepositoryProvider).createDecision(_draft);
    await tester.pump(const Duration(seconds: 3));

    expect(find.text("You're offline"), findsOneWidget);
    expect(find.textContaining('1 change saved on this phone'), findsOneWidget);

    offlineServer.failWith = null;
    await tester.tap(find.text('Try again'));
    await settle(tester);

    expect(find.text("You're offline"), findsNothing);
    expect(c.read(syncControllerProvider).pending, 0);
    await tester.pumpWidget(const SizedBox());
    c.dispose();
  });

  testWidgets('the banner says when the server\'s newer copy was kept',
      (tester) async {
    final c = await pumpSignedInApp(tester,
        autoSync: true,
        overrides: [syncTimingProvider.overrideWithValue(_timing)]);
    final remote =
        c.read(decisionRemoteDataSourceProvider) as FakeDecisionRemoteDataSource;
    final repo = c.read(decisionRepositoryProvider);
    final d = await repo.createDecision(_draft);
    await tester.pump(const Duration(seconds: 3));

    // Another device changes it later than the phone's edit below.
    remote.editElsewhere((await stored(c, d)).serverId!,
        title: 'Renamed on the laptop',
        at: DateTime.now().add(const Duration(days: 1)));
    await repo.updateDecision(d.localId!, _draft.copyWith(title: 'Mine'));
    await tester.pump(const Duration(seconds: 3));

    expect((await stored(c, d)).title, 'Renamed on the laptop');
    expect(find.text('Updated from the server'), findsOneWidget);
    expect(find.textContaining('"Mine" was changed somewhere else'),
        findsOneWidget);
    await tester.tap(find.text('OK'));
    await tester.pump();
    expect(find.text('Updated from the server'), findsNothing);
    await tester.pumpWidget(const SizedBox());
    c.dispose();
  });
}
