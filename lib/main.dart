import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hinsight/core.dart';
import 'src/core/routing/app_router.dart';

void main() {
  // ProviderScope is mandatory for Riverpod
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch your GoRouter provider
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'hinsight', // Updated to match your project
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,

      routerConfig: router,
    );
  }
}
