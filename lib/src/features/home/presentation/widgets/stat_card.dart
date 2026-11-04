import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String count;
  final Color color;
  final Color bgColor;

  const StatCard({
    super.key,
    required this.title,
    required this.count,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            count,
            style: textTheme.headlineLarge?.copyWith(color: color), // 32 Extrabold
          ),
          const SizedBox(height: 4),
          // Three cards share a row on the dashboard; on a narrow phone the
          // label shrinks rather than breaking mid-word.
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: textTheme.titleSmall?.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
} 