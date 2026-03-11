import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/pages/home_page.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    // debugLogDiagnostics prints every routing event to your terminal. Invaluable for debugging.
    debugLogDiagnostics: true, 
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      // You will add your Auth and Profile routes here later
    ],
  );
});