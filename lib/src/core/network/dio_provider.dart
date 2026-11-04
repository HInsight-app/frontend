import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../storage/token_storage.dart';
import 'auth_interceptor.dart';

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

/// The one HTTP client every repository uses. It sends the login token and
/// signs the user out when the backend says the session has ended (the
/// router then shows the login page).
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: ref.watch(baseUrlProvider),
    connectTimeout: const Duration(seconds: 10),
    // Generous because AI analysis waits on Gemini.
    receiveTimeout: const Duration(seconds: 60),
    contentType: Headers.jsonContentType,
  ));

  dio.interceptors.add(AuthInterceptor(
    tokenStorage: ref.watch(tokenStorageProvider),
    onUnauthorized: () =>
        ref.read(authControllerProvider.notifier).onSessionExpired(),
  ));

  ref.onDispose(dio.close);
  return dio;
});
