/*
INI PLACEHOLDER BISA DIGANTI SEMUANYA
*/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../controllers/home_controller.dart';
import '../widgets/decision_card.dart';
import '../widgets/stat_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final decisions = ref.watch(recentDecisionsProvider);

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'HInsight',
          style: textTheme.headlineSmall?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined, color: colorScheme.primary),
            onPressed: () {
              context.push('/sandbox');
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 2,
        icon: const Icon(Icons.add),
        label: const Text(
          'New Decision',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back,',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'What are we tracking today?',
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: colorScheme.onSurface,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 32),

            // Stats Row
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'In Progress',
                    count: '4',
                    color: colorScheme.primary,
                    bgColor: colorScheme.primaryContainer,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: StatCard(
                    title: 'Resolved',
                    count: '12',
                    color: colorScheme.onPrimary,
                    bgColor: colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 36),

            Text(
              'Recent Activity',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),

            ...decisions.map((decision) => DecisionCard(
                  title: decision.title,
                  date: decision.date,
                  status: decision.status,
                  statusColor: decision.statusColor,
                  icon: decision.icon,
                )),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
