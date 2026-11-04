import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/brand_app_bar.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/section_header.dart';
import '../../domain/entities/ai_insight.dart';
import '../../domain/entities/decision_enums.dart';
import '../decision_labels.dart';
import '../decision_providers.dart';

/// Which biases come up most across the student's decisions (the design's
/// "Cognitive Patterns"), counted from completed AI checks.
class InsightsPage extends ConsumerWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insights = ref.watch(allInsightsProvider).valueOrNull;
    final decisions = ref.watch(allDecisionsProvider).valueOrNull ?? const [];
    final titles = {for (final d in decisions) d.localId: d.title};
    final completed = insights
            ?.where((i) => i.status == InsightStatus.complete)
            .toList() ??
        const <AiInsight>[];

    return Scaffold(
      appBar: const BrandAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const PageHeading(
            title: 'Cognitive Patterns',
            description: 'See which biases show up most often across your '
                'decisions, so you can spot your own patterns over time.',
          ),
          const SizedBox(height: 24),
          if (insights == null)
            const Center(child: CircularProgressIndicator())
          else if (completed.isEmpty)
            const EmptyState(
              icon: Icons.lightbulb_outline,
              title: 'No patterns yet',
              message: 'Patterns appear here once the AI has checked some of '
                  'your decisions.',
            )
          else ...[
            _Summary(completed: completed),
            const SectionHeader(title: 'Biases flagged'),
            _BiasBreakdown(completed: completed),
            const SectionHeader(title: 'Recent checks'),
            for (final insight in completed.take(10))
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(titles[insight.decisionLocalId] ?? 'Decision'),
                subtitle: Text(
                  '${formatDate(insight.requestedAt)} · '
                  '${insight.primaryBias?.label ?? 'No clear bias'}',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () =>
                    context.push('/decisions/${insight.decisionLocalId}'),
              ),
          ],
        ],
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.completed});

  final List<AiInsight> completed;

  @override
  Widget build(BuildContext context) {
    final flagged = completed.where((i) => i.primaryBias != null).length;
    return Row(
      children: [
        Expanded(child: _Number(value: completed.length, label: 'Checks completed')),
        const SizedBox(width: 12),
        Expanded(child: _Number(value: flagged, label: 'Possible biases flagged')),
      ],
    );
  }
}

class _Number extends StatelessWidget {
  const _Number({required this.value, required this.label});

  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$value',
                style: textTheme.headlineLarge
                    ?.copyWith(color: Theme.of(context).colorScheme.primary)),
            Text(label, style: textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

/// One bar per bias: the share of completed checks that flagged it.
class _BiasBreakdown extends StatelessWidget {
  const _BiasBreakdown({required this.completed});

  final List<AiInsight> completed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final counts = {
      for (final bias in BiasType.values)
        bias: completed.where((i) => i.primaryBias == bias).length,
    };
    final ranked = BiasType.values.where((b) => counts[b]! > 0).toList()
      ..sort((a, b) => counts[b]!.compareTo(counts[a]!));

    if (ranked.isEmpty) {
      return Text('No biases were flagged in your checks so far.',
          style: textTheme.bodySmall);
    }
    return Column(
      children: [
        for (final bias in ranked)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(bias.label, style: textTheme.titleSmall)),
                    Text(
                      '${counts[bias]} of ${completed.length} checks',
                      style: textTheme.labelSmall,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: counts[bias]! / completed.length,
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(3),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
