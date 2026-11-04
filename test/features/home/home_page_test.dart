import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hinsight/src/features/decisions/decisions_providers.dart';
import 'package:hinsight/src/features/decisions/domain/entities/decision.dart';
import 'package:hinsight/src/features/decisions/presentation/pages/decision_form_page.dart';
import 'package:hinsight/src/features/home/presentation/pages/home_page.dart';

import '../../helpers/fake_decisions.dart';

void main() {
  testWidgets('a new student sees an invitation to record a decision',
      (tester) async {
    await pumpSignedInApp(tester);

    expect(find.byType(HomePage), findsOneWidget);
    expect(find.text('Welcome back, Owen'), findsOneWidget);
    expect(find.text('Record your first decision'), findsOneWidget);
  });

  testWidgets('shows counts, recent decisions and what is due for review',
      (tester) async {
    final container = await pumpSignedInApp(tester);
    final repo = container.read(decisionRepositoryProvider);
    await tester.runAsync(() async {
      await repo.createDecision(const DecisionDraft(title: 'Pick an elective'));
      final internship = await repo.createDecision(DecisionDraft(
        title: 'Take the internship',
        scheduledReviewDate: DateTime.now().subtract(const Duration(days: 1)),
        options: const [OptionDraft(title: 'Yes'), OptionDraft(title: 'No')],
      ));
      await repo.commitDecision(internship.localId!,
          chosenOptionKey: internship.options.first.key);
    });
    await settle(tester);

    // Pending, Decided and Evaluated counts
    expect(find.text('Pending'), findsWidgets);
    expect(find.text('Ready to evaluate'), findsOneWidget);
    expect(find.text('Take the internship'), findsNWidgets(2)); // Due + recent
    expect(find.text('Pick an elective'), findsOneWidget);
  });

  testWidgets('the New Decision button opens the form', (tester) async {
    await pumpSignedInApp(tester);

    await tester.tap(find.byType(FloatingActionButton));
    await settle(tester);

    expect(find.byType(DecisionFormPage), findsOneWidget);
  });
}
