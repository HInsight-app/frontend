import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth_providers.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/restore_session_usecase.dart';

/// The current session: loading while the saved session is checked at
/// startup, then the signed-in user, or null when signed out. The router
/// watches this to decide between the login page and the app.
final authControllerProvider =
    AsyncNotifierProvider<AuthController, AuthUser?>(AuthController.new);

class AuthController extends AsyncNotifier<AuthUser?> {
  @override
  Future<AuthUser?> build() async {
    try {
      return await RestoreSessionUseCase(ref.read(authRepositoryProvider))
          .execute();
    } catch (_) {
      // Storage or configuration problem: start signed out rather than stuck.
      return null;
    }
  }

  /// Throws ApiException when the backend refuses (e.g. wrong password).
  Future<AuthUser> login({
    required String email,
    required String password,
    required bool remember,
  }) async {
    final user = await LoginUseCase(ref.read(authRepositoryProvider)).execute(
      email: email,
      password: password,
      remember: remember,
    );
    state = AsyncData(user);
    return user;
  }

  /// Throws ApiException when the backend refuses (e.g. email already used).
  Future<AuthUser> register({
    required String displayName,
    required String email,
    required String password,
  }) async {
    final user =
        await RegisterUseCase(ref.read(authRepositoryProvider)).execute(
      displayName: displayName,
      email: email,
      password: password,
    );
    state = AsyncData(user);
    return user;
  }

  Future<void> logout() async {
    await LogoutUseCase(ref.read(authRepositoryProvider)).execute();
    state = const AsyncData(null);
  }

  /// Called by the Dio interceptor when the backend rejects the token.
  Future<void> onSessionExpired() => logout();
}
