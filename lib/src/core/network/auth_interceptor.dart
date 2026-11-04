import 'package:dio/dio.dart';

import '../storage/token_storage.dart';

/// Adds the login token to every API request, and ends the session when the
/// backend rejects it (401), as the paper describes in III-D.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({required this.tokenStorage, required this.onUnauthorized});

  final TokenStorage tokenStorage;

  /// Called after a rejected token is deleted, e.g. to show the login page.
  final void Function() onUnauthorized;

  // Login and registration don't need a token. Sending a stale one there could
  // make a wrong-password 401 look like an expired session.
  static const _publicPaths = {'/auth/login', '/auth/register'};

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!_publicPaths.contains(options.path)) {
      final token = await tokenStorage.read();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Only a request that carried a token can mean "your session expired".
    final sentToken = err.requestOptions.headers.containsKey('Authorization');
    if (err.response?.statusCode == 401 && sentToken) {
      await tokenStorage.delete();
      onUnauthorized();
    }
    handler.next(err);
  }
}
