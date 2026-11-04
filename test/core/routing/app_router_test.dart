import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hinsight/core.dart';
import 'package:hinsight/src/core/routing/app_router.dart';
import 'package:hinsight/src/core/widgets/tab_placeholder_page.dart';
import 'package:hinsight/src/features/auth/presentation/pages/login_page.dart';
import 'package:hinsight/src/features/auth/presentation/pages/register_page.dart';
import 'package:hinsight/src/features/home/presentation/pages/home_page.dart';
import 'package:hinsight/src/features/home/presentation/pages/sandbox_page.dart';

// Uses the real router from goRouterProvider and the real theme.
void main() {
  late ProviderContainer container;

  setUp(() => container = ProviderContainer());
  tearDown(() => container.dispose());

  Future<void> pumpRouter(WidgetTester tester) async {
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

  testWidgets('starts on the home page', (tester) async {
    await pumpRouter(tester);
    await waitForTransition(tester);

    expect(find.byType(HomePage), findsOneWidget);
  });

  final routes = <String, Type>{
    '/login': LoginPage,
    '/register': RegisterPage,
    '/sandbox': SandboxPage,
    '/': HomePage,
    '/analyze': TabPlaceholderPage,
    '/insights': TabPlaceholderPage,
    '/history': TabPlaceholderPage,
  };

  routes.forEach((path, page) {
    testWidgets('$path renders $page without errors', (tester) async {
      await pumpRouter(tester);
      container.read(goRouterProvider).go(path);
      await waitForTransition(tester);

      expect(find.byType(page), findsOneWidget);
    });
  });

  testWidgets('the tabs show the bottom nav; full-screen pages do not',
      (tester) async {
    await pumpRouter(tester);
    await waitForTransition(tester);
    expect(find.byType(NavigationBar), findsOneWidget);

    container.read(goRouterProvider).go('/login');
    await waitForTransition(tester);
    expect(find.byType(NavigationBar), findsNothing);
  });

  testWidgets('tapping a tab switches pages and keeps the others alive',
      (tester) async {
    await pumpRouter(tester);
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
