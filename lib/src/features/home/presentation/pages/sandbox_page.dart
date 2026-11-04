import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hinsight/core.dart';

import '../../../decisions/data/remote/fake_decision_remote_data_source.dart';
import '../../../decisions/decisions_providers.dart';
import '../../../decisions/domain/entities/ai_insight.dart';
import '../../../decisions/domain/entities/decision_enums.dart';
import '../../../decisions/presentation/sync_controller.dart';
import '../../../decisions/presentation/widgets/insight_card.dart';

class SandboxPage extends StatelessWidget {
  const SandboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UI Component Sandbox'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.p24),
        children: [
          Text('Buttons', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSizes.p16),
          AppButton(
            text: 'Primary Button',
            onPressed: () {},
          ),
          const SizedBox(height: AppSizes.p16),
          AppButton(
            text: 'Secondary Button',
            type: ButtonType.secondary,
            onPressed: () {},
          ),
          const SizedBox(height: AppSizes.p16),
          AppButton(
            text: 'Outline Button',
            type: ButtonType.outline,
            onPressed: () {},
          ),
          const SizedBox(height: AppSizes.p16),
          AppButton(
            text: 'Loading State',
            isLoading: true,
            onPressed: () {},
          ),
          const Divider(height: 64),
          Text('Input Fields',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSizes.p16),
          const AppTextField(
            label: 'Decision Title',
            hint: 'e.g., Should I buy a new laptop?',
            prefixIcon: Icons.settings,
          ),
          const SizedBox(height: AppSizes.p16),
          const AppTextField(
            label: 'Notes',
            hint: 'Brain dump here...',
            maxLines: 4,
          ),
          const Divider(height: 64),
          Text('AI Insight', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSizes.p16),
          InsightCard(insight: _sampleInsight),
          const _SimulateOffline(),
        ],
      ),
    );
  }
}

/// Makes the fake server unreachable, to try working offline and then
/// syncing (a task scenario for the user tests). Hidden with the real server.
class _SimulateOffline extends ConsumerStatefulWidget {
  const _SimulateOffline();

  @override
  ConsumerState<_SimulateOffline> createState() => _SimulateOfflineState();
}

class _SimulateOfflineState extends ConsumerState<_SimulateOffline> {
  @override
  Widget build(BuildContext context) {
    final server = ref.watch(decisionRemoteDataSourceProvider);
    if (server is! FakeDecisionRemoteDataSource) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 64),
        Text('Sync', style: Theme.of(context).textTheme.headlineSmall),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Simulate offline'),
          subtitle: const Text(
              'The fake server stops answering. Changes stay on this device '
              'until you switch this off.'),
          value: server.failWith != null,
          onChanged: (offline) {
            setState(() => server.failWith =
                offline ? FakeDecisionRemoteDataSource.offline : null);
            // Back "online": sync now instead of waiting for the next retry.
            if (!offline) ref.read(syncControllerProvider.notifier).syncNow();
          },
        ),
      ],
    );
  }
}

// A finished check, to see how InsightCard looks. It flags a bias and asks a
// question rather than recommending a choice (paper I-C).
final _sampleInsight = AiInsight(
  decisionLocalId: 1,
  decisionServerId: 'sample',
  triggerContext: TriggerContext.preDecision,
  status: InsightStatus.complete,
  requestedAt: DateTime(2026, 11, 4),
  insightText: "You mention the months you've already spent on this thesis "
      'topic. Is that time something you can get back, or only something '
      'you could lose more of?',
  primaryBias: BiasType.sunkCost,
  emotionalTone: EmotionalTone.uncertain,
  riskLevel: RiskLevel.medium,
  actionabilityScore: 6,
  suggestedAlternative:
      'Compare the topics only on what happens from today onward.',
  modelConfidence: 0.42,
);
