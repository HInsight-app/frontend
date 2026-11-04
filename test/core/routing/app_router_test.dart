import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hinsight/core.dart';
import 'package:hinsight/src/core/routing/app_router.dart';
import 'package:hinsight/src/features/auth/auth.dart';
import 'package:hinsight/src/features/auth/presentation/pages/login_page.dart';
import 'package:hinsight/src/features/auth/presentation/pages/register_page.dart';
import 'package:hinsight/src/features/decisions/presentation/pages/analyze_page.dart';
import 'package:hinsight/src/features/decisions/presentation/pages/decision_detail_page.dart';
import 'package:hinsight/src/features/decisions/presentation/pages/decision_form_page.dart';
import 'package:hinsight/src/features/decisions/presentation/pages/history_page.dart';
import 'package:hinsight/src/features/decisions/presentation/pages/insights_page.dart';
import 'package:hinsight/src/features/home/presentation/pages/home_page.dart';
import 'package:hinsight/src/features/home/presentation/pages/sandbox_page.dart';

import '../../helpers/fake_auth.dart';
import '../../helpers/fake_decisions.dart';

// Uses the real router from goRouterProvider and the real theme, with a fake
// auth repository so tests choose whether the user is signed in.
void main() {
  late ProviderContainer container;
  late FakeAuthRepository auth;

  tearDown(() => container.dispose());

  Future<void> pumpRouter(WidgetTester tester, {required bool signedIn}) async {
    auth = FakeAuthRepository(savedUser: signedIn ? testUser : null);
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(auth),
        ...decisionOverrides(),
      ],
    );
    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        theme: AppTheme.darkTheme,
        routerConfig: container.read(goRouterProvider),
      ),
    ));
  }

  // pumpAndSettle can't be used: the sandbox shows a spinner that never stops.
  Future<void> waitForTransition(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
  }

  testWidgets('a remembered user starts on the dashboard', (tester) async {
    await pumpRouter(tester, signedIn: true);
    await waitForTransition(tester);

    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets('a signed-out user starts on the login page', (tester) async {
    await pumpRouter(tester, signedIn: false);
    await waitForTransition(tester);

    expect(find.byType(LoginPage), findsOneWidget);
  });

  testWidgets('a signed-out user cannot open a tab directly', (tester) async {
    await pumpRouter(tester, signedIn: false);
    container.read(goRouterProvider).go('/history');
    await waitForTransition(tester);

    expect(find.byType(LoginPage), findsOneWidget);
  });

  final signedInRoutes = <String, Type>{
    '/': HomePage,
    '/analyze': AnalyzePage,
    '/insights': InsightsPage,
    '/history': HistoryPage,
    '/sandbox': SandboxPage,
    '/decisions/new': DecisionFormPage,
    // Not '/decisions/new' by mistake: a real id opens the decision page.
    '/decisions/7': DecisionDetailPage,
  };
  signedInRoutes.forEach((path, page) {
    testWidgets('$path renders $page when signed in', (tester) async {
      await pumpRouter(tester, signedIn: true);
      container.read(goRouterProvider).go(path);
      await waitForTransition(tester);

      expect(find.byType(page), findsOneWidget);
    });
  });

  final signedOutRoutes = <String, Type>{
    '/login': LoginPage,
    '/register': RegisterPage,
  };
  signedOutRoutes.forEach((path, page) {
    testWidgets('$path renders $page when signed out', (tester) async {
      await pumpRouter(tester, signedIn: false);
      container.read(goRouterProvider).go(path);
      await waitForTransition(tester);

      expect(find.byType(page), findsOneWidget);
    });
  });

  testWidgets('logging out from the dashboard returns to login',
      (tester) async {
    await pumpRouter(tester, signedIn: true);
    await waitForTransition(tester);

    await tester.tap(find.byTooltip('Log out'));
    await waitForTransition(tester);

    expect(find.byType(LoginPage), findsOneWidget);
    expect(auth.logoutCalls, 1);
  });

  testWidgets('the tabs show the bottom nav; full-screen pages do not',
      (tester) async {
    await pumpRouter(tester, signedIn: true);
    await waitForTransition(tester);
    expect(find.byType(NavigationBar), findsOneWidget);

    container.read(goRouterProvider).go('/sandbox');
    await waitForTransition(tester);
    expect(find.byType(NavigationBar), findsNothing);
  });

  testWidgets('tapping a tab switches pages and keeps the others alive',
      (tester) async {
    await pumpRouter(tester, signedIn: true);
    await waitForTransition(tester);

    await tester.tap(find.text('History'));
    await waitForTransition(tester);
    expect(find.text('Decision History'), findsOneWidget);
    expect(container.read(goRouterProvider).state.uri.path, '/history');

    await tester.tap(find.text('Dashboard'));
    await waitForTransition(tester);
    expect(find.byType(HomePage), findsOneWidget);
    // indexedStack keeps visited tabs in the tree, just hidden.
    expect(find.text('Decision History', skipOffstage: false), findsOneWidget);
  });
}
