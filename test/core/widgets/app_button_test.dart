import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hinsight/core.dart';

// Wraps the widget in a minimal app. The default theme is used on purpose:
// AppTheme loads Google Fonts over the network, which tests can't do.
Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
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
