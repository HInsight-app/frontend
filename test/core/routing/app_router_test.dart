import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hinsight/src/core/routing/app_router.dart';
import 'package:hinsight/src/features/auth/presentation/pages/login_page.dart';
import 'package:hinsight/src/features/auth/presentation/pages/register_page.dart';
import 'package:hinsight/src/features/home/presentation/pages/home_page.dart';
import 'package:hinsight/src/features/home/presentation/pages/sandbox_page.dart';

// Uses the real router from goRouterProvider but the default theme, because
// AppTheme loads Google Fonts over the network, which tests can't do.
void main() {
  late ProviderContainer container;

  setUp(() => container = ProviderContainer());
  tearDown(() => container.dispose());

  Future<void> pumpRouter(WidgetTester tester) async {
    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(routerConfig: container.read(goRouterProvider)),
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
  };

  routes.forEach((path, page) {
    testWidgets('$path renders $page without errors', (tester) async {
      await pumpRouter(tester);
      container.read(goRouterProvider).go(path);
      await waitForTransition(tester);

      expect(find.byType(page), findsOneWidget);
    });
  });
}
