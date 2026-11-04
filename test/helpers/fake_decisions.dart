import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hinsight/core.dart';
import 'package:hinsight/src/core/routing/app_router.dart';
import 'package:hinsight/src/features/auth/auth.dart';
import 'package:hinsight/src/features/decisions/data/local/memory_decision_local_data_source.dart';
import 'package:hinsight/src/features/decisions/data/remote/fake_decision_remote_data_source.dart';
import 'package:hinsight/src/features/decisions/decisions_providers.dart';

import 'fake_auth.dart';

/// In-memory decision storage and an instant fake server, as provider
/// overrides (main() normally supplies the store).
List<Override> decisionOverrides() => [
      decisionLocalDataSourceProvider
          .overrideWithValue(MemoryDecisionLocalDataSource()),
      decisionRemoteDataSourceProvider
          .overrideWithValue(FakeDecisionRemoteDataSource(latency: Duration.zero)),
    ];

/// Pumps a few frames. pumpAndSettle can't be used: loading spinners never
/// settle.
Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

/// The whole app (real router and theme) with a signed-in student, opened at
/// [location]. Returns the container so tests can reach the repository.
Future<ProviderContainer> pumpSignedInApp(
  WidgetTester tester, {
  String location = '/',
}) async {
  // A tall phone-width screen, so long pages build all their parts.
  tester.view.physicalSize = const Size(420, 2400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final container = ProviderContainer(overrides: [
    authRepositoryProvider
        .overrideWithValue(FakeAuthRepository(savedUser: testUser)),
    ...decisionOverrides(),
  ]);
  addTearDown(container.dispose);
  await tester.pumpWidget(UncontrolledProviderScope(
    container: container,
    child: MaterialApp.router(
      theme: AppTheme.darkTheme,
      routerConfig: container.read(goRouterProvider),
    ),
  ));
  await settle(tester);
  if (location != '/') {
    container.read(goRouterProvider).go(location);
    await settle(tester);
  }
  return container;
}
