import 'package:flutter/material.dart';

/// The app bar on the main tabs: the HInsight name in the brand purple.
class BrandAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BrandAppBar({super.key, this.actions});

  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        'HInsight',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
      ),
      actions: actions,
    );
  }
}

/// The large title and short description at the top of a tab.
class PageHeading extends StatelessWidget {
  const PageHeading({super.key, required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: textTheme.headlineLarge),
        const SizedBox(height: 8),
        Text(description, style: textTheme.bodySmall),
      ],
    );
  }
}
