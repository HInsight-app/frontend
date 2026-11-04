import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/pill.dart';
import '../../domain/entities/ai_insight.dart';
import '../../domain/entities/decision_enums.dart';
import '../decision_labels.dart';

/// One AI bias check: still running, failed, or its findings. Shows every
/// field the paper lists (III-G), and a warning when the model is unsure.
class InsightCard extends StatelessWidget {
  const InsightCard({
    super.key,
    required this.insight,
    this.decisionTitle,
    this.onTap,
  });

  final AiInsight insight;

  /// Shown when the card appears outside its decision, e.g. on Analyze.
  final String? decisionTitle;
  final VoidCallback? onTap;

  /// Below this the card warns that the finding is uncertain.
  static const lowConfidence = 0.5;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: switch (insight.status) {
            InsightStatus.processing => _Processing(insight: insight),
            InsightStatus.failed => _Failed(insight: insight),
            InsightStatus.complete =>
              _Complete(insight: insight, decisionTitle: decisionTitle),
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.insight, this.trailing});

  final AiInsight insight;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(Icons.auto_awesome, size: 18, color: colors.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '${insight.triggerContext.label} · ${formatDate(insight.requestedAt)}',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class _Processing extends StatelessWidget {
  const _Processing({required this.insight});

  final AiInsight insight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header(insight: insight),
        const SizedBox(height: 12),
        Row(
          children: [
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 12),
            Text('Checking for biases…',
                style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ],
    );
  }
}

class _Failed extends StatelessWidget {
  const _Failed({required this.insight});

  final AiInsight insight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header(
          insight: insight,
          trailing: const Pill(text: 'Not finished', color: AppColors.error),
        ),
        const SizedBox(height: 8),
        Text(
          "This check didn't finish. You can try again.",
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _Complete extends StatelessWidget {
  const _Complete({required this.insight, this.decisionTitle});

  final AiInsight insight;
  final String? decisionTitle;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final bias = insight.primaryBias;
    final confidence = insight.modelConfidence;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header(
          insight: insight,
          trailing: insight.riskLevel == null
              ? null
              : Pill(
                  text: insight.riskLevel!.label,
                  color: insight.riskLevel!.color,
                ),
        ),
        if (decisionTitle != null) ...[
          const SizedBox(height: 8),
          Text(decisionTitle!, style: textTheme.labelLarge),
        ],
        const SizedBox(height: 8),
        Text(bias?.label ?? 'No clear bias found', style: textTheme.titleMedium),
        if (bias != null) ...[
          const SizedBox(height: 2),
          Text(bias.description, style: textTheme.bodySmall),
        ],
        if (insight.insightText != null) ...[
          const SizedBox(height: 12),
          Text(insight.insightText!, style: textTheme.bodyMedium),
        ],
        if (insight.suggestedAlternative != null) ...[
          const SizedBox(height: 12),
          Text('Something to consider', style: textTheme.titleSmall),
          const SizedBox(height: 2),
          Text(insight.suggestedAlternative!, style: textTheme.bodyMedium),
        ],
        const SizedBox(height: 12),
        Wrap(
          spacing: 16,
          runSpacing: 4,
          children: [
            if (confidence != null)
              Text('Model confidence: ${(confidence * 100).round()}%',
                  style: textTheme.labelSmall),
            if (insight.emotionalTone != null)
              Text('Tone: ${insight.emotionalTone!.label}',
                  style: textTheme.labelSmall),
            if (insight.actionabilityScore != null)
              Text('Actionability: ${insight.actionabilityScore}/10',
                  style: textTheme.labelSmall),
          ],
        ),
        if (confidence != null && confidence < InsightCard.lowConfidence) ...[
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.warning_amber_rounded,
                  size: 16, color: AppColors.warning),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'The AI is not very sure about this. Treat it as a question '
                  'to think about, not a finding.',
                  style: textTheme.bodySmall?.copyWith(color: colors.onSurface),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
