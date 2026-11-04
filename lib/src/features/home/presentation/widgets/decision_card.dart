import 'package:flutter/material.dart';

class DecisionCard extends StatelessWidget {
  final String title;
  final String date;
  final String status;
  final Color statusColor;
  final IconData icon;

  const DecisionCard({
    super.key,
    required this.title,
    required this.date,
    required this.status,
    required this.statusColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12), // Moved padding here for list spacing
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainer, // Card colour
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.outline),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colors.secondary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: colors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(date, style: textTheme.bodySmall),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: textTheme.labelMedium?.copyWith(color: statusColor),
            ),
          ),
        ],
      ),
    );
  }
}