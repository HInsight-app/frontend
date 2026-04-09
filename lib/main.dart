import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:hinsight/core.dart';
import 'src/core/routing/app_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Remove '#' from all url
  usePathUrlStrategy();

  await dotenv.load(fileName: ".env");
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

      theme: AppTheme.darkTheme,

      routerConfig: router,
    );
  }
}
