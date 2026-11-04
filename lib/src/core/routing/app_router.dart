import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/domain/entities/auth_user.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/pages/sandbox_page.dart';
import '../widgets/tab_placeholder_page.dart';
import 'app_shell.dart';

/// Whether signed-out users are sent to the login page. Off only in web debug
/// builds: web is a UI preview (Isar doesn't run there) and the backend sends
/// no CORS headers, so logging in from a browser can't work.
final authRedirectEnabledProvider = Provider<bool>(
  (ref) => !(kIsWeb && kDebugMode),
);

const _authPages = {'/login', '/register'};

/// Where to send the user given the session, or null to stay on [location].
String? authRedirect(AsyncValue<AuthUser?> session, String location) {
  // Still checking for a saved session at startup.
  if (!session.hasValue && !session.hasError) {
    return location == '/splash' ? null : '/splash';
  }

  final signedIn = session.valueOrNull != null;
  if (!signedIn) return _authPages.contains(location) ? null : '/login';
  if (_authPages.contains(location) || location == '/splash') return '/';
  return null;
}

final goRouterProvider = Provider<GoRouter>((ref) {
  // GoRouter re-runs redirect whenever this notifier changes, i.e. on sign in,
  // sign out or an expired session.
  final session = ValueNotifier(ref.read(authControllerProvider));
  ref.listen(authControllerProvider, (_, next) => session.value = next);
  ref.onDispose(session.dispose);

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    refreshListenable: session,
    redirect: ref.watch(authRedirectEnabledProvider)
        ? (context, state) => authRedirect(session.value, state.matchedLocation)
        : null,
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashPage(),
      ),
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
