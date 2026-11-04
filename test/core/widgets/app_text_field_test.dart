import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hinsight/core.dart';

Widget _wrap(Widget child) =>
    MaterialApp(theme: AppTheme.darkTheme, home: Scaffold(body: child));

bool _isObscured(WidgetTester tester) =>
    tester.widget<TextField>(find.byType(TextField)).obscureText;

void main() {
  testWidgets('shows its label and hint and writes to the controller',
      (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(_wrap(AppTextField(
      label: 'Email',
      hint: 'example@gmail.com',
      controller: controller,
    )));

    expect(find.text('Email'), findsOneWidget);
    expect(find.text('example@gmail.com'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'owen@binus.ac.id');
    expect(controller.text, 'owen@binus.ac.id');
  });

  testWidgets('a normal field is not obscured and has no visibility toggle',
      (tester) async {
    await tester.pumpWidget(_wrap(const AppTextField(label: 'Name', hint: 'Name')));

    expect(_isObscured(tester), isFalse);
    expect(find.byType(IconButton), findsNothing);
  });

  testWidgets('a password field starts hidden and the eye icon toggles it',
      (tester) async {
    await tester.pumpWidget(_wrap(
      const AppTextField(label: 'Password', hint: 'Password', isPassword: true),
    ));

    expect(_isObscured(tester), isTrue);
    expect(find.byIcon(Icons.visibility_off), findsOneWidget);

    await tester.tap(find.byType(IconButton));
    await tester.pump();
    expect(_isObscured(tester), isFalse);
    expect(find.byIcon(Icons.visibility), findsOneWidget);

    await tester.tap(find.byType(IconButton));
    await tester.pump();
    expect(_isObscured(tester), isTrue);
  });
}
