import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// flutter_test has its own Evaluation (an accessibility check result).
import 'package:flutter_test/flutter_test.dart' hide Evaluation;
import 'package:hinsight/src/core/routing/app_router.dart';
import 'package:hinsight/src/features/decisions/decisions_providers.dart';
import 'package:hinsight/src/features/decisions/domain/entities/decision.dart';
import 'package:hinsight/src/features/decisions/domain/entities/decision_enums.dart';
import 'package:hinsight/src/features/decisions/presentation/pages/decision_detail_page.dart';
import 'package:hinsight/src/features/tags/domain/entities/tag.dart';

import '../../helpers/fake_decisions.dart';

// Walks the paper's decision flow (III-F) through the real screens, with the
// in-memory store and an instant fake server.

const _elective = DecisionDraft(
  title: 'Pick an elective',
  context: 'Two courses fit my schedule',
  confidenceBefore: 90, // The fake server flags this as overconfidence
  options: [
    OptionDraft(title: 'Data Mining', pros: ['Useful for my thesis']),
    OptionDraft(title: 'Game Design', cons: ['Heavy workload']),
  ],
);

Future<Decision> _seed(
  WidgetTester tester,
  ProviderContainer container, [
  DecisionDraft draft = _elective,
]) async {
  final repo = container.read(decisionRepositoryProvider);
  return (await tester.runAsync(() => repo.createDecision(draft)))!;
}

Future<void> _tapText(WidgetTester tester, String text) async {
  await tester.scrollUntilVisible(find.text(text), 200,
      scrollable: find.byType(Scrollable).last);
  await tester.tap(find.text(text));
  await settle(tester);
}

void main() {
  testWidgets('creating a decision opens its page', (tester) async {
    final container = await pumpSignedInApp(tester, location: '/decisions/new');

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'Take the internship');
    await tester.enterText(fields.at(2), 'Accept the offer');
    await tester.enterText(fields.at(3), 'Stay for the semester');
    await _tapText(tester, 'Save decision');

    expect(find.byType(DecisionDetailPage), findsOneWidget);
    expect(find.text('Take the internship'), findsOneWidget);
    expect(find.text('Accept the offer'), findsOneWidget);
    final saved =
        await container.read(decisionRepositoryProvider).watchDecisions().first;
    expect(saved.single.options, hasLength(2));
  });

  testWidgets('an option left completely empty is ignored', (tester) async {
    final container = await pumpSignedInApp(tester, location: '/decisions/new');

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'Join the robotics club');
    await tester.enterText(fields.at(2), 'Join this semester');
    await _tapText(tester, 'Save decision');

    expect(find.byType(DecisionDetailPage), findsOneWidget);
    final saved =
        await container.read(decisionRepositoryProvider).watchDecisions().first;
    expect(saved.single.options.single.title, 'Join this semester');
  });

  testWidgets('the form explains a broken rule instead of saving',
      (tester) async {
    final container = await pumpSignedInApp(tester, location: '/decisions/new');

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'Pick an elective');
    await tester.enterText(fields.at(2), 'Data Mining');
    await tester.enterText(fields.at(3), 'data mining');
    await _tapText(tester, 'Save decision');

    expect(find.textContaining('Two options are called'), findsOneWidget);
    expect(
        await container.read(decisionRepositoryProvider).watchDecisions().first,
        isEmpty);
  });

  testWidgets('checking for biases shows the insight with its warning',
      (tester) async {
    final container = await pumpSignedInApp(tester);
    final d = await _seed(tester, container);
    container.read(goRouterProvider).go('/decisions/${d.localId}');
    await settle(tester);

    expect(find.text('About AI insights'), findsOneWidget);
    await _tapText(tester, 'Check for biases');

    expect(find.text('Overconfidence Bias'), findsOneWidget);
    expect(find.textContaining('Sample analysis'), findsOneWidget);
    expect(find.textContaining('The AI is not very sure'), findsOneWidget);
    expect(find.text('Check for biases again'), findsOneWidget);
  });

  testWidgets('commit, evaluate, then look back with the AI', (tester) async {
    final container = await pumpSignedInApp(tester);
    final d = await _seed(tester, container);
    container.read(goRouterProvider).go('/decisions/${d.localId}');
    await settle(tester);

    // Commit: choose an option
    await _tapText(tester, 'Commit to an option');
    await tester.tap(find.text('Game Design'));
    await tester.pump();
    await _tapText(tester, 'Commit');
    expect(find.text('Decided'), findsOneWidget);
    expect(find.text('Chosen'), findsOneWidget);
    expect(find.byTooltip('Edit decision'), findsNothing);

    // Evaluate with the default scores: the notes are required
    await _tapText(tester, 'Evaluate this decision');
    await _tapText(tester, 'Save evaluation');
    expect(find.textContaining("know now that you didn't when you decided"),
        findsOneWidget);
    expect(find.text('Save evaluation'), findsOneWidget); // Still on the form
    await tester.enterText(
        find.byType(TextField).last, 'The workload was fine after all');
    await _tapText(tester, 'Save evaluation');
    expect(find.text('Evaluated'), findsOneWidget);
    expect(find.textContaining('Satisfaction: 50%'), findsOneWidget);

    // Look back
    await _tapText(tester, 'Look back with AI');
    expect(find.textContaining('Looking back ·'), findsOneWidget);
  });

  testWidgets('history searches and filters decisions', (tester) async {
    final container = await pumpSignedInApp(tester);
    await _seed(tester, container);
    final repo = container.read(decisionRepositoryProvider);
    await tester.runAsync(() async {
      final d = await repo.createDecision(const DecisionDraft(
        title: 'Join the robotics club',
        options: [OptionDraft(title: 'Join'), OptionDraft(title: 'Skip')],
      ));
      await repo.commitDecision(d.localId!, chosenOptionKey: d.options.first.key);
    });
    container.read(goRouterProvider).go('/history');
    await settle(tester);

    expect(find.text('Pick an elective'), findsOneWidget);
    expect(find.text('Join the robotics club'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Decided'));
    await settle(tester);
    expect(find.text('Pick an elective'), findsNothing);
    expect(find.text('Join the robotics club'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'All'));
    await tester.enterText(find.byType(TextField), 'elective');
    await settle(tester);
    expect(find.text('Pick an elective'), findsOneWidget);
    expect(find.text('Join the robotics club'), findsNothing);
  });

  testWidgets('Analyze and Insights list the checks across decisions',
      (tester) async {
    final container = await pumpSignedInApp(tester);
    final d = await _seed(tester, container);
    await tester.runAsync(() => container
        .read(decisionRepositoryProvider)
        .requestInsight(d.localId!, TriggerContext.preDecision));

    container.read(goRouterProvider).go('/analyze');
    await settle(tester);
    expect(find.text('Pick an elective'), findsOneWidget); // Decision title
    expect(find.text('Overconfidence Bias'), findsOneWidget);

    container.read(goRouterProvider).go('/insights');
    await settle(tester);
    expect(find.text('Overconfidence Bias'), findsOneWidget);
    expect(find.text('1 of 1 checks'), findsOneWidget);
  });

  testWidgets('typing a search keeps the list on screen (no spinner flash)',
      (tester) async {
    final container = await pumpSignedInApp(tester);
    await _seed(tester, container);
    container.read(goRouterProvider).go('/history');
    await settle(tester);

    await tester.enterText(find.byType(TextField), 'elec');
    await tester.pump(); // The first frame after the keystroke

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Pick an elective'), findsOneWidget);
  });

  testWidgets('a decision not yet on the server says so until it syncs',
      (tester) async {
    final container = await pumpSignedInApp(tester);
    final d = await _seed(tester, container);
    container.read(goRouterProvider).go('/decisions/${d.localId}');
    await settle(tester);
    expect(find.text('Not synced yet'), findsOneWidget);

    await tester.runAsync(
        () => container.read(syncRepositoryProvider).syncPendingChanges());
    await settle(tester);
    expect(find.text('Not synced yet'), findsNothing);
  });

  testWidgets('a review date that has passed can still be changed',
      (tester) async {
    final container = await pumpSignedInApp(tester);
    final past = DateTime.now().subtract(const Duration(days: 3));
    final d = await _seed(tester, container,
        _elective.copyWith(scheduledReviewDate: past));
    container.read(goRouterProvider).go('/decisions/${d.localId}/edit');
    await settle(tester);

    // The picker used to fail here: its first allowed day is today.
    await _tapText(tester, 'Change');

    expect(tester.takeException(), isNull);
    expect(find.byType(DatePickerDialog), findsOneWidget);
  });

  testWidgets('commit and evaluate pages say when the decision is gone',
      (tester) async {
    final container = await pumpSignedInApp(tester);
    for (final page in ['commit', 'evaluate']) {
      container.read(goRouterProvider).go('/decisions/999/$page');
      await settle(tester);
      expect(find.text('This decision no longer exists.'), findsOneWidget,
          reason: page);
      expect(find.byType(CircularProgressIndicator), findsNothing,
          reason: page);
    }
  });

  testWidgets('with fewer than two options the page asks for more, not a commit',
      (tester) async {
    final container = await pumpSignedInApp(tester);
    final d = await _seed(
      tester,
      container,
      const DecisionDraft(
          title: 'Join a club', options: [OptionDraft(title: 'Robotics')]),
    );
    container.read(goRouterProvider).go('/decisions/${d.localId}');
    await settle(tester);

    expect(find.text('Commit to an option'), findsNothing);
    expect(find.textContaining('Add at least 2 options'), findsOneWidget);
    await _tapText(tester, 'Add options');
    expect(find.text('Edit decision'), findsOneWidget);

    // Reaching the commit page anyway (a saved link): the commit is refused.
    container.read(goRouterProvider).go('/decisions/${d.localId}/commit');
    await settle(tester);
    await tester.tap(find.text('Robotics'));
    await tester.pump();
    await _tapText(tester, 'Commit');
    expect(find.textContaining('Add at least 2 options'), findsOneWidget);
    final stored = await tester.runAsync(
        () => container.read(decisionRepositoryProvider).watchDecision(d.localId!).first);
    expect(stored!.status, DecisionStatus.pending);
  });

  testWidgets('the commit page flags an option without pros or cons',
      (tester) async {
    final container = await pumpSignedInApp(tester);
    final d = await _seed(
      tester,
      container,
      const DecisionDraft(title: 'Pick a laptop', options: [
        OptionDraft(title: 'Light one', pros: ['Easy to carry']),
        OptionDraft(title: 'Cheap one'),
      ]),
    );
    container.read(goRouterProvider).go('/decisions/${d.localId}/commit');
    await settle(tester);

    expect(find.text('1 pro · 0 cons'), findsOneWidget);
    expect(find.text('No pros or cons listed'), findsOneWidget);

    // Only a nudge: committing to it still works.
    await tester.tap(find.text('Cheap one'));
    await tester.pump();
    await _tapText(tester, 'Commit');
    expect(find.text('Decided'), findsOneWidget);
  });

  testWidgets('long-pressing a tag asks first, then deletes it everywhere',
      (tester) async {
    final container = await pumpSignedInApp(tester);
    final repo = container.read(decisionRepositoryProvider);
    final d = (await tester.runAsync(() async {
      final academic = await repo.createTag('Academic');
      await repo.createTag('Career');
      return repo.createDecision(_elective.copyWith(
          tagLocalIds: [academic.localId!]));
    }))!;
    container.read(goRouterProvider).go('/decisions/${d.localId}/edit');
    await settle(tester);
    expect(find.text('Long-press a tag to delete it.'), findsOneWidget);

    // Cancelling keeps it.
    await tester.longPress(find.widgetWithText(FilterChip, 'Academic'));
    await settle(tester);
    expect(find.text('Delete the tag "Academic"?'), findsOneWidget);
    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await settle(tester);
    expect(find.widgetWithText(FilterChip, 'Academic'), findsOneWidget);

    await tester.longPress(find.widgetWithText(FilterChip, 'Academic'));
    await settle(tester);
    await tester.tap(find.widgetWithText(TextButton, 'Delete'));
    await settle(tester);
    expect(find.widgetWithText(FilterChip, 'Academic'), findsNothing);
    expect(find.widgetWithText(FilterChip, 'Career'), findsOneWidget);

    // Saving the open form must not put the deleted tag back.
    await _tapText(tester, 'Save changes');
    final stored = await tester.runAsync(() => repo.watchDecision(d.localId!).first);
    expect(stored!.tagLocalIds, isEmpty);
    expect(await tester.runAsync(() => repo.watchTags().first),
        [isA<Tag>().having((t) => t.name, 'name', 'Career')]);
  });

  testWidgets('deleting a decision asks first, then removes it',
      (tester) async {
    final container = await pumpSignedInApp(tester);
    final d = await _seed(tester, container);
    container.read(goRouterProvider).go('/history');
    await settle(tester);
    await tester.tap(find.text('Pick an elective'));
    await settle(tester);

    await tester.tap(find.byTooltip('Delete decision'));
    await settle(tester);
    expect(find.text('Delete this decision?'), findsOneWidget);
    await tester.tap(find.widgetWithText(TextButton, 'Delete'));
    await settle(tester);

    expect(find.text('Decision deleted.'), findsOneWidget);
    expect(find.text('No decisions yet'), findsOneWidget); // Back on History
    expect(
        await container
            .read(decisionRepositoryProvider)
            .watchDecision(d.localId!)
            .first,
        isNull);
  });
}
