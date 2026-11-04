import '../entities/auth_user.dart';

// The Interface (Contract)
// This strictly defines what the repository MUST be able to do.
// Failed API calls throw an ApiException with a message safe to show the user.
abstract class AuthRepository {
  /// Signs in and saves the session. With [remember] it survives an app
  /// restart (and the backend keeps it for 7 days instead of 24 hours).
  Future<AuthUser> login({
    required String email,
    required String password,
    required bool remember,
  });

  /// Creates the account and signs in, remembered like [login] with remember.
  Future<AuthUser> register({
    required String displayName,
    required String email,
    required String password,
  });

  /// The remembered user from a previous app run, or null.
  Future<AuthUser?> restoreSession();

  /// Forgets the session on this device.
  Future<void> logout();
}
