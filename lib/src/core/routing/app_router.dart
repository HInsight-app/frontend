import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/domain/entities/auth_user.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/decisions/presentation/pages/analyze_page.dart';
import '../../features/decisions/presentation/pages/commit_decision_page.dart';
import '../../features/decisions/presentation/pages/decision_detail_page.dart';
import '../../features/decisions/presentation/pages/decision_form_page.dart';
import '../../features/decisions/presentation/pages/evaluate_decision_page.dart';
import '../../features/decisions/presentation/pages/history_page.dart';
import '../../features/decisions/presentation/pages/insights_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/pages/sandbox_page.dart';
import 'app_shell.dart';
import 'auth_redirect_enabled.dart';

export 'auth_redirect_enabled.dart';

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
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/analyze',
              builder: (context, state) => const AnalyzePage(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/insights',
              builder: (context, state) => const InsightsPage(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/history',
              builder: (context, state) => const HistoryPage(),
            ),
          ]),
        ],
      ),
      // Full-screen pages outside the tabs (no bottom nav).
      // '/decisions/new' must come before '/decisions/:id', which would match it.
      GoRoute(
        path: '/decisions/new',
        builder: (context, state) => const DecisionFormPage(),
      ),
      GoRoute(
        path: '/decisions/:id',
        builder: (context, state) =>
            DecisionDetailPage(decisionId: _decisionId(state)),
        routes: [
          GoRoute(
            path: 'edit',
            builder: (context, state) =>
                DecisionFormPage(decisionId: _decisionId(state)),
          ),
          GoRoute(
            path: 'commit',
            builder: (context, state) =>
                CommitDecisionPage(decisionId: _decisionId(state)),
          ),
          GoRoute(
            path: 'evaluate',
            builder: (context, state) =>
                EvaluateDecisionPage(decisionId: _decisionId(state)),
          ),
        ],
      ),
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

/// The decision's local id from the URL. A malformed id becomes -1, which no
/// decision has, so the page shows "This decision no longer exists".
int _decisionId(GoRouterState state) =>
    int.tryParse(state.pathParameters['id'] ?? '') ?? -1;
