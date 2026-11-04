import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../storage/token_storage.dart';
import 'auth_interceptor.dart';
import 'connection_status.dart';
import 'connectivity_interceptor.dart';

/// The backend address from `.env` (loaded in main()).
final baseUrlProvider = Provider<String>((ref) {
  final url = dotenv.env['BASE_URL']?.trim();
  if (url == null || url.isEmpty) {
    throw StateError(
      'BASE_URL is not set. Copy .env.example to .env and fill in BASE_URL '
      '(see the comments in .env.example for which address to use).',
    );
  }
  return url;
});

/// The one HTTP client every repository uses. It sends the login token,
/// signs the user out when the backend says the session has ended (the
/// router then shows the login page), and notices when the server can or
/// can't be reached (the sync starts again when it can).
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: ref.watch(baseUrlProvider),
    connectTimeout: const Duration(seconds: 10),
    // Generous because AI analysis waits on Gemini.
    receiveTimeout: const Duration(seconds: 60),
    contentType: Headers.jsonContentType,
  ));

  dio.interceptors
    ..add(AuthInterceptor(
      tokenStorage: ref.watch(tokenStorageProvider),
      onUnauthorized: () =>
          ref.read(authControllerProvider.notifier).onSessionExpired(),
    ))
    ..add(ConnectivityInterceptor(
      onOnline: () => ref.read(connectionStatusProvider.notifier).reportOnline(),
      onOffline: () =>
          ref.read(connectionStatusProvider.notifier).reportOffline(),
    ));

  ref.onDispose(dio.close);
  return dio;
});
