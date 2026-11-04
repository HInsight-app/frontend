import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AiInsightCard extends StatelessWidget {
  final String insightText;
  final bool isLoading;

  // Optional AI Flags (Your backend Go/Gemini API will provide these)
  final String? primaryBias;
  final String? emotionalTone;
  final String? riskLevel;

  const AiInsightCard({
    super.key,
    required this.insightText,
    this.isLoading = false,
    this.primaryBias,
    this.emotionalTone,
    this.riskLevel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.12),
            theme.colorScheme.surfaceContainer, // Card colour
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. The Header
          Row(
            children: [
              Icon(Icons.auto_awesome,
                  color: theme.colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'AI Analysis',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: Center(child: CircularProgressIndicator()),
            )
          else ...[
            // The Main AI Text
            Text(
              insightText,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.5,
                color: theme.colorScheme.onSurface,
              ),
            ),

            if (primaryBias != null ||
                emotionalTone != null ||
                riskLevel != null) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  // Bias Flag (Red/Warning)
                  if (primaryBias != null)
                    Chip(
                      label: Text(primaryBias!,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold)),
                      backgroundColor: theme.colorScheme.errorContainer,
                      labelStyle:
                          TextStyle(color: theme.colorScheme.onErrorContainer),
                      side: BorderSide.none,
                      padding: EdgeInsets.zero,
                    ),

                  // Tone Flag (Blue/Info)
                  if (emotionalTone != null)
                    Chip(
                      label: Text(emotionalTone!,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold)),
                      backgroundColor: theme.colorScheme.secondaryContainer,
                      labelStyle: TextStyle(
                          color: theme.colorScheme.onSecondaryContainer),
                      side: BorderSide.none,
                      padding: EdgeInsets.zero,
                    ),

                  // Risk Flag (Yellow/Warning)
                  if (riskLevel != null)
                    Chip(
                      avatar: const Icon(Icons.warning_amber_rounded,
                          size: 16, color: AppColors.warning),
                      label: Text(riskLevel!,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold)),
                      backgroundColor:
                          AppColors.warning.withValues(alpha: 0.15),
                      labelStyle: const TextStyle(color: AppColors.warning),
                      side: BorderSide.none,
                      padding: EdgeInsets.zero,
                    ),
                ],
              ),
            ]
          ],
        ],
      ),
    );
  }
}
