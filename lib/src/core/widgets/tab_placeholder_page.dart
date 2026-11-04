import 'package:flutter/material.dart';

/// Stands in for a bottom-nav tab whose real screen comes in Phase 6, and says
/// what the tab will do.
class TabPlaceholderPage extends StatelessWidget {
  const TabPlaceholderPage({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'HInsight',
          style: textTheme.headlineSmall?.copyWith(
            color: colors.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(title, style: textTheme.headlineLarge),
          const SizedBox(height: 8),
          Text(description, style: textTheme.bodySmall),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colors.surfaceContainer,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.outline),
            ),
            child: Column(
              children: [
                Icon(icon, size: 48, color: colors.primary),
                const SizedBox(height: 12),
                Text('Coming soon', style: textTheme.titleMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
