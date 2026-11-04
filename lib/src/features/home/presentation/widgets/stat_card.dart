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
      padding: const EdgeInsets.all(20),
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
          Text(
            title,
            style: textTheme.titleSmall?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
} 