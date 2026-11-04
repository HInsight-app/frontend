import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hinsight/core.dart';
import 'package:hinsight/src/core/routing/app_router.dart';
import 'package:hinsight/src/features/auth/auth.dart';
import 'package:hinsight/src/features/auth/presentation/pages/login_page.dart';
import 'package:hinsight/src/features/home/presentation/pages/home_page.dart';

import '../../helpers/fake_auth.dart';

void main() {
  late FakeAuthRepository auth;

  // Starts signed out, so the real router shows the login page.
  Future<void> pumpLogin(WidgetTester tester) async {
    auth = FakeAuthRepository();
    final container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWithValue(auth)],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        theme: AppTheme.darkTheme,
        routerConfig: container.read(goRouterProvider),
      ),
    ));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(LoginPage), findsOneWidget);
  }

  Future<void> submit(WidgetTester tester, String email, String password) async {
    await tester.enterText(find.byType(TextField).at(0), email);
    await tester.enterText(find.byType(TextField).at(1), password);
    await tester.tap(find.widgetWithText(AppButton, 'Login'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
  }

  testWidgets('a successful login opens the dashboard and greets the user',
      (tester) async {
    await pumpLogin(tester);
    await tester.tap(find.byType(Checkbox)); // Remember me
    await submit(tester, '  owen@binus.ac.id ', ' Secret123 ');

    expect(find.byType(HomePage), findsOneWidget);
    expect(find.text('Welcome back, Owen!'), findsOneWidget);
    expect(auth.lastEmail, 'owen@binus.ac.id'); // Email is trimmed
    expect(auth.lastPassword, ' Secret123 '); // Password is not
    expect(auth.lastRemember, isTrue);
  });

  testWidgets('a refused login shows the backend message and stays put',
      (tester) async {
    await pumpLogin(tester);
    auth.error = const ApiException('invalid credentials', statusCode: 401);
    await submit(tester, 'owen@binus.ac.id', 'wrong-password');

    expect(find.text('invalid credentials'), findsOneWidget);
    expect(find.byType(LoginPage), findsOneWidget);
    expect(auth.lastRemember, isFalse);
  });

  testWidgets('empty fields are caught before calling the backend',
      (tester) async {
    await pumpLogin(tester);
    await submit(tester, '', '');

    expect(find.text('Enter your email and password.'), findsOneWidget);
    expect(auth.lastEmail, isNull);
  });
}
