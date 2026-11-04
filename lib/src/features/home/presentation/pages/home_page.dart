import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/brand_app_bar.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../decisions/domain/entities/decision.dart';
import '../../../decisions/domain/entities/decision_enums.dart';
import '../../../decisions/presentation/decision_providers.dart';
import '../../../decisions/presentation/widgets/decision_list_card.dart';
import '../../../decisions/presentation/widgets/insight_card.dart';
import '../widgets/stat_card.dart';

/// The Dashboard tab: where the student's decisions stand, what is due for a
/// look back, and the latest AI checks.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final name = ref.watch(authControllerProvider).valueOrNull?.displayName;
    final decisions = ref.watch(allDecisionsProvider).valueOrNull;
    final insights = (ref.watch(allInsightsProvider).valueOrNull ?? const [])
        .where((i) => i.status == InsightStatus.complete)
        .take(2)
        .toList();

    int count(DecisionStatus status) =>
        decisions?.where((d) => d.status == status).length ?? 0;
    final dueForReview = (decisions ?? const <Decision>[])
        .where((d) =>
            d.status == DecisionStatus.decided &&
            d.scheduledReviewDate != null &&
            isOnOrBeforeToday(d.scheduledReviewDate!))
        .toList();
    void openDecision(Decision d) => context.push('/decisions/${d.localId}');

    return Scaffold(
      appBar: BrandAppBar(
        actions: [
          IconButton(
            tooltip: 'Component sandbox',
            icon: Icon(Icons.settings_outlined, color: colorScheme.primary),
            onPressed: () => context.push('/sandbox'),
          ),
          IconButton(
            tooltip: 'Log out',
            icon: Icon(Icons.logout_rounded, color: colorScheme.primary),
            onPressed: () async {
              await ref.read(authControllerProvider.notifier).logout();
              // The router also does this on its own, except in the web preview.
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ),
      // Colours and label style come from AppTheme (CTA lavender, dark text)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/decisions/new'),
        icon: const Icon(Icons.add),
        label: const Text('New Decision'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 96),
        children: [
          Text(
            name == null ? 'Welcome back' : 'Welcome back, $name',
            style: textTheme.bodyMedium
                ?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 4),
          Text('What are you deciding today?', style: textTheme.headlineMedium),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: StatCard(
                  title: 'Pending',
                  count: '${count(DecisionStatus.pending)}',
                  color: colorScheme.primary,
                  bgColor: colorScheme.surfaceContainer,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatCard(
                  title: 'Decided',
                  count: '${count(DecisionStatus.decided)}',
                  color: colorScheme.primary,
                  bgColor: colorScheme.surfaceContainer,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatCard(
                  title: 'Evaluated',
                  count: '${count(DecisionStatus.evaluated)}',
                  color: colorScheme.onPrimaryContainer,
                  bgColor: colorScheme.primaryContainer, // CTA lavender
                ),
              ),
            ],
          ),
          if (decisions != null && decisions.isEmpty) ...[
            const SizedBox(height: 24),
            EmptyState(
              icon: Icons.edit_note,
              title: 'Record your first decision',
              message: 'Write down a choice you are facing, list your options, '
                  'and ask the AI to check your reasoning for biases.',
              action: AppButton(
                text: 'New decision',
                onPressed: () => context.push('/decisions/new'),
              ),
            ),
          ],
          if (dueForReview.isNotEmpty) ...[
            const SectionHeader(title: 'Ready to evaluate'),
            for (final d in dueForReview)
              DecisionListCard(decision: d, onTap: () => openDecision(d)),
          ],
          if (decisions != null && decisions.isNotEmpty) ...[
            SectionHeader(
              title: 'Recent decisions',
              actionLabel: 'See all',
              onAction: () => context.go('/history'),
            ),
            for (final d in decisions.take(3))
              DecisionListCard(decision: d, onTap: () => openDecision(d)),
          ],
          if (insights.isNotEmpty) ...[
            SectionHeader(
              title: 'Recent insights',
              actionLabel: 'See all',
              onAction: () => context.go('/analyze'),
            ),
            for (final insight in insights)
              InsightCard(
                insight: insight,
                decisionTitle: decisions
                    ?.where((d) => d.localId == insight.decisionLocalId)
                    .firstOrNull
                    ?.title,
                onTap: () =>
                    context.push('/decisions/${insight.decisionLocalId}'),
              ),
          ],
        ],
      ),
    );
  }
}
