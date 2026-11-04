import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/pill.dart';
import '../../../../core/widgets/section_header.dart';
import '../../decisions_providers.dart';
import '../../domain/entities/decision.dart';
import '../../domain/entities/decision_enums.dart';
import '../../domain/entities/evaluation.dart';
import '../../domain/usecases/decision_usecases.dart';
import '../decision_labels.dart';
import '../decision_providers.dart';
import '../widgets/ai_notice.dart';
import '../widgets/insight_card.dart';

/// One decision and its next step in the paper's flow (III-F): check for
/// biases and commit while pending, evaluate once decided, then look back.
class DecisionDetailPage extends ConsumerWidget {
  const DecisionDetailPage({super.key, required this.decisionId});

  final int decisionId;

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete this decision?'),
        content: const Text(
            'Its options, evaluation and AI insights are deleted too.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    await DeleteDecisionUseCase(ref.read(decisionRepositoryProvider))
        .execute(decisionId);
    showAppSnackBar(messenger, 'Decision deleted.');
    if (context.mounted) {
      context.canPop() ? context.pop() : context.go('/history');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final decision = ref.watch(decisionProvider(decisionId));
    final d = decision.valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Decision'),
        actions: [
          if (d?.status == DecisionStatus.pending)
            IconButton(
              tooltip: 'Edit decision',
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => context.push('/decisions/$decisionId/edit'),
            ),
          if (d != null)
            IconButton(
              tooltip: 'Delete decision',
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _delete(context, ref),
            ),
        ],
      ),
      body: decision.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (d) => d == null
            ? Center(
                child: Text('This decision no longer exists.',
                    style: Theme.of(context).textTheme.bodyMedium),
              )
            : _DecisionBody(decision: d),
      ),
    );
  }
}

class _DecisionBody extends ConsumerWidget {
  const _DecisionBody({required this.decision});

  final Decision decision;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final id = decision.localId!;
    final evaluation = ref.watch(evaluationProvider(id)).valueOrNull;
    final insights = ref.watch(insightsProvider(id)).valueOrNull ?? const [];
    final tags = ref.watch(tagsProvider).valueOrNull ?? const [];
    final tagNames = [
      for (final tag in tags)
        if (decision.tagLocalIds.contains(tag.localId)) tag.name,
    ];

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Row(
          children: [
            Pill(text: decision.status.label, color: decision.status.color),
            const SizedBox(width: 8),
            Text('Created ${formatDate(decision.createdAt)}',
                style: textTheme.labelSmall),
          ],
        ),
        const SizedBox(height: 12),
        Text(decision.title, style: textTheme.headlineSmall),
        if (decision.context != null) ...[
          const SizedBox(height: 8),
          Text(decision.context!, style: textTheme.bodyMedium),
        ],
        const SizedBox(height: 12),
        Wrap(
          spacing: 16,
          runSpacing: 4,
          children: [
            if (decision.confidenceBefore != null)
              Text('Initial confidence: ${decision.confidenceBefore}%',
                  style: textTheme.labelSmall),
            if (decision.scheduledReviewDate != null)
              Text('Look back on ${formatDate(decision.scheduledReviewDate!)}',
                  style: textTheme.labelSmall),
          ],
        ),
        if (tagNames.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [for (final name in tagNames) Chip(label: Text(name))],
          ),
        ],
        const SectionHeader(title: 'Options'),
        if (decision.options.isEmpty)
          Text('No options yet. Edit the decision to add some.',
              style: textTheme.bodySmall),
        for (final option in decision.options)
          _OptionView(
            option: option,
            chosen: decision.outcome?.chosenOptionKey == option.key,
          ),
        if (decision.outcome != null) _CommitmentView(outcome: decision.outcome!),
        if (evaluation != null)
          _EvaluationView(evaluation: evaluation, decision: decision),
        const SizedBox(height: 8),
        _NextStep(decision: decision),
        const SectionHeader(title: 'AI bias check'),
        const AiNotice(),
        const SizedBox(height: 12),
        _InsightButton(decision: decision, insightsSoFar: insights.length),
        const SizedBox(height: 12),
        for (final insight in insights) InsightCard(insight: insight),
      ],
    );
  }
}

class _OptionView extends StatelessWidget {
  const _OptionView({required this.option, required this.chosen});

  final DecisionOption option;
  final bool chosen;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    Widget item(String text, Color color) => Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Icon(Icons.circle, size: 8, color: color),
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(text, style: textTheme.bodyMedium)),
            ],
          ),
        );

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: chosen ? colors.primary : colors.outline,
          width: chosen ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(option.title, style: textTheme.titleMedium)),
                if (chosen) Pill(text: 'Chosen', color: colors.primary),
              ],
            ),
            for (final pro in option.pros) item(pro, AppColors.success),
            for (final con in option.cons) item(con, AppColors.error),
            if (option.pros.isEmpty && option.cons.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('No pros or cons listed.', style: textTheme.bodySmall),
              ),
          ],
        ),
      ),
    );
  }
}

class _CommitmentView extends StatelessWidget {
  const _CommitmentView({required this.outcome});

  final DecisionOutcome outcome;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Committed on ${formatDate(outcome.decidedAt)}',
                style: textTheme.titleSmall),
            if (outcome.commitmentNote != null) ...[
              const SizedBox(height: 4),
              Text(outcome.commitmentNote!, style: textTheme.bodyMedium),
            ],
          ],
        ),
      ),
    );
  }
}

class _EvaluationView extends StatelessWidget {
  const _EvaluationView({required this.evaluation, required this.decision});

  final Evaluation evaluation;
  final Decision decision;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final before = decision.confidenceBefore;
    final after = evaluation.confidenceAfter;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Evaluated on ${formatDate(evaluation.createdAt)}',
                style: textTheme.titleSmall),
            const SizedBox(height: 8),
            if (evaluation.satisfactionAfter != null)
              Text('Satisfaction: ${evaluation.satisfactionAfter}%',
                  style: textTheme.bodyMedium),
            if (after != null)
              Text(
                before == null
                    ? 'Confidence afterwards: $after%'
                    : 'Confidence: $before% before, $after% afterwards',
                style: textTheme.bodyMedium,
              ),
            if (evaluation.hindsightNotes != null) ...[
              const SizedBox(height: 8),
              Text(evaluation.hindsightNotes!, style: textTheme.bodyMedium),
            ],
          ],
        ),
      ),
    );
  }
}

/// The button for the next step of the flow, if there is one.
class _NextStep extends StatelessWidget {
  const _NextStep({required this.decision});

  final Decision decision;

  @override
  Widget build(BuildContext context) {
    final id = decision.localId!;
    switch (decision.status) {
      case DecisionStatus.pending:
        if (decision.options.isEmpty) return const SizedBox.shrink();
        return AppButton(
          text: 'Commit to an option',
          onPressed: () => context.push('/decisions/$id/commit'),
        );
      case DecisionStatus.decided:
        return AppButton(
          text: 'Evaluate this decision',
          onPressed: () => context.push('/decisions/$id/evaluate'),
        );
      case DecisionStatus.evaluated:
        return const SizedBox.shrink();
    }
  }
}

/// Asks the AI for a check: before committing, or looking back after
/// evaluating. Between those (decided) there is nothing to ask.
class _InsightButton extends ConsumerStatefulWidget {
  const _InsightButton({required this.decision, required this.insightsSoFar});

  final Decision decision;
  final int insightsSoFar;

  @override
  ConsumerState<_InsightButton> createState() => _InsightButtonState();
}

class _InsightButtonState extends ConsumerState<_InsightButton> {
  bool _requesting = false;

  TriggerContext? get _trigger => switch (widget.decision.status) {
        DecisionStatus.pending => TriggerContext.preDecision,
        DecisionStatus.decided => null,
        DecisionStatus.evaluated => TriggerContext.postEvaluation,
      };

  Future<void> _request(TriggerContext trigger) async {
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _requesting = true);
    try {
      await RequestInsightUseCase(ref.read(decisionRepositoryProvider))
          .execute(widget.decision.localId!, trigger);
    } catch (e) {
      // e.g. offline (ApiException) or a check already running
      showAppSnackBar(messenger, e.toString(), isError: true);
    } finally {
      if (mounted) setState(() => _requesting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final trigger = _trigger;
    if (trigger == null) {
      return Text(
        'The before-deciding check is closed now that you have committed. '
        'Evaluate the decision to ask the AI to look back with you.',
        style: Theme.of(context).textTheme.bodySmall,
      );
    }
    final again = widget.insightsSoFar > 0;
    return AppButton(
      type: ButtonType.secondary,
      text: trigger == TriggerContext.preDecision
          ? (again ? 'Check for biases again' : 'Check for biases')
          : 'Look back with AI',
      isLoading: _requesting,
      onPressed: () => _request(trigger),
    );
  }
}
