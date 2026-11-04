import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/brand_app_bar.dart';
import '../../../../core/widgets/empty_state.dart';
import '../decision_providers.dart';
import '../widgets/ai_notice.dart';
import '../widgets/insight_card.dart';

/// Every AI bias check across the student's decisions, newest first
/// (the design's "Proactive Analysis").
class AnalyzePage extends ConsumerWidget {
  const AnalyzePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insights = ref.watch(allInsightsProvider).valueOrNull;
    final decisions = ref.watch(allDecisionsProvider).valueOrNull ?? const [];
    final titles = {for (final d in decisions) d.localId: d.title};

    return Scaffold(
      appBar: const BrandAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const PageHeading(
            title: 'Proactive Analysis',
            description: 'Before you commit to a decision, ask the AI to flag '
                'possible cognitive biases in your reasoning. Every check you '
                'have run is listed here.',
          ),
          const SizedBox(height: 24),
          const AiNotice(),
          const SizedBox(height: 16),
          if (insights == null)
            const Center(child: CircularProgressIndicator())
          else if (insights.isEmpty)
            const EmptyState(
              icon: Icons.psychology_outlined,
              title: 'No checks yet',
              message: "Open a decision and tap 'Check for biases'.",
            )
          else
            for (final insight in insights)
              InsightCard(
                insight: insight,
                decisionTitle: titles[insight.decisionLocalId],
                onTap: () => context.push('/decisions/${insight.decisionLocalId}'),
              ),
        ],
      ),
    );
  }
}
