import 'package:flutter/material.dart';

import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/pill.dart';
import '../../domain/entities/decision.dart';
import '../decision_labels.dart';

/// One decision in a list: date, status, title and a line of context.
class DecisionListCard extends StatelessWidget {
  const DecisionListCard({super.key, required this.decision, this.onTap});

  final Decision decision;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final optionCount = decision.options.length;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(formatDate(decision.createdAt),
                            style: textTheme.labelSmall),
                        const SizedBox(width: 8),
                        Pill(
                          text: decision.status.label,
                          color: decision.status.color,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      decision.title,
                      style: textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (decision.context != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        decision.context!,
                        style: textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 4),
                    Text(
                      optionCount == 1 ? '1 option' : '$optionCount options',
                      style: textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: colors.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
