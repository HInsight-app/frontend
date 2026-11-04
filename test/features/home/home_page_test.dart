import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hinsight/core.dart';
import 'package:hinsight/src/features/home/presentation/controllers/home_controller.dart';
import 'package:hinsight/src/features/home/presentation/pages/home_page.dart';
import 'package:hinsight/src/features/home/presentation/widgets/decision_card.dart';

void main() {
  testWidgets('home page renders one card per decision from the provider',
      (tester) async {
    await tester.pumpWidget(ProviderScope(
      child: MaterialApp(theme: AppTheme.darkTheme, home: const HomePage()),
    ));

    expect(find.text('HInsight'), findsOneWidget);
    expect(find.text('New Decision'), findsOneWidget);

    // Read the provider directly so this test survives changes to the mock data.
    final container = ProviderScope.containerOf(
      tester.element(find.byType(HomePage)),
    );
    final decisions = container.read(recentDecisionsProvider);
    expect(find.byType(DecisionCard), findsNWidgets(decisions.length));
    for (final decision in decisions) {
      expect(find.text(decision.title), findsOneWidget);
    }
  });
}
