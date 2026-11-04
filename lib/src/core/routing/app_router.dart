import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/pages/sandbox_page.dart';
import '../widgets/tab_placeholder_page.dart';
import 'app_shell.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      // The four bottom-nav tabs. Each branch is one tab with its own history;
      // the order must match the destinations in AppShell.
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const HomePage(),
            ),
          ]),
          // Placeholders until the decision screens are built (Phase 6).
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/analyze',
              builder: (context, state) => const TabPlaceholderPage(
                title: 'Proactive Analysis',
                description:
                    'Before you commit to a decision, ask the AI to flag possible '
                    'cognitive biases in your reasoning. It points them out; the '
                    'choice stays yours.',
                icon: Icons.psychology_outlined,
              ),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/insights',
              builder: (context, state) => const TabPlaceholderPage(
                title: 'Cognitive Patterns',
                description:
                    'See which biases show up most often across your decisions, '
                    'so you can spot your own patterns over time.',
                icon: Icons.lightbulb_outline,
              ),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/history',
              builder: (context, state) => const TabPlaceholderPage(
                title: 'Decision History',
                description:
                    'Look back at past decisions, record how they turned out, '
                    'and compare that with how confident you felt at the start.',
                icon: Icons.history,
              ),
            ),
          ]),
        ],
      ),
      // Full-screen pages outside the tabs (no bottom nav)
      GoRoute(
        path: '/sandbox',
        builder: (context, state) => const SandboxPage(),
      ),
      // Auth and Profile routes here later
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
    ],
  );
});
