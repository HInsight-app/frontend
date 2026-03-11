import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/core/routing/app_router.dart';

void main() {
  // ProviderScope is mandatory. It holds the state for the entire Riverpod ecosystem.
  runApp(const ProviderScope(child: MainApp()));
}

// ConsumerWidget lets us watch Riverpod providers
class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the GoRouter provider we created in app_router.dart
    final router = ref.watch(goRouterProvider);

    // MaterialApp.router replaces the standard MaterialApp
    return MaterialApp.router(
      title: 'Frontend Enterprise App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Hand over complete routing control to GoRouter
      routerConfig: router, 
      debugShowCheckedModeBanner: false,
    );
  }
}