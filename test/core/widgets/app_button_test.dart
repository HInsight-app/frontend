import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hinsight/core.dart';

// Wraps the widget in a minimal app with the real theme (its fonts are bundled).
Widget _wrap(Widget child) =>
    MaterialApp(theme: AppTheme.darkTheme, home: Scaffold(body: child));

ButtonStyle _styleOf(WidgetTester tester) =>
    tester.widget<ElevatedButton>(find.byType(ElevatedButton)).style!;

void main() {
  testWidgets('each type uses its colours from the theme', (tester) async {
    await tester.pumpWidget(_wrap(AppButton(text: 'Primary', onPressed: () {})));
    expect(_styleOf(tester).backgroundColor!.resolve({}), AppColors.cta);
    expect(_styleOf(tester).foregroundColor!.resolve({}), AppColors.background);

    await tester.pumpWidget(_wrap(AppButton(
      text: 'Secondary',
      type: ButtonType.secondary,
      onPressed: () {},
    )));
    expect(_styleOf(tester).backgroundColor!.resolve({}), AppColors.secondary);

    await tester.pumpWidget(_wrap(AppButton(
      text: 'Outline',
      type: ButtonType.outline,
      onPressed: () {},
    )));
    final shape = _styleOf(tester).shape!.resolve({}) as RoundedRectangleBorder;
    expect(_styleOf(tester).backgroundColor!.resolve({}), Colors.transparent);
    expect(shape.side.color, AppColors.border);
  });

  testWidgets('shows its text and calls onPressed when tapped', (tester) async {
    var taps = 0;
    await tester.pumpWidget(_wrap(AppButton(text: 'Login', onPressed: () => taps++)));

    expect(find.text('Login'), findsOneWidget);
    await tester.tap(find.byType(AppButton));
    expect(taps, 1);
  });

  testWidgets('shows a spinner and ignores taps while loading', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _wrap(AppButton(text: 'Login', isLoading: true, onPressed: () => taps++)),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Login'), findsNothing);
    await tester.tap(find.byType(AppButton));
    expect(taps, 0);
  });

  testWidgets('shows an icon only when one is given', (tester) async {
    await tester.pumpWidget(_wrap(AppButton(text: 'No icon', onPressed: () {})));
    expect(find.byType(FaIcon), findsNothing);

    await tester.pumpWidget(_wrap(AppButton(
      text: 'Continue with Google',
      icon: FontAwesomeIcons.google,
      onPressed: () {},
    )));
    expect(find.byType(FaIcon), findsOneWidget);
  });
}
