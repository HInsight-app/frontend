import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/storage/token_storage.dart';
import '../models/auth_response.dart';

// The Interface (The Menu)
abstract class AuthLocalDataSource {
  /// Saves the session. With [persist] it is also written to the device.
  Future<void> saveSession(AuthResponse session, {required bool persist});

  /// The session written to the device by an earlier run, or null.
  Future<AuthResponse?> readSavedSession();

  Future<void> clearSession();
}

// The Implementation (The Vault Manager)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final TokenStorage tokenStorage;
  final FlutterSecureStorage secureStorage;

  // The token lives in TokenStorage (shared with the Dio interceptor); the
  // user's id, email and name are kept next to it under this key.
  static const String _userKey = 'auth_user';

  AuthLocalDataSourceImpl({
    required this.tokenStorage,
    required this.secureStorage,
  });

  @override
  Future<void> saveSession(AuthResponse session, {required bool persist}) async {
    await tokenStorage.save(session.token, persist: persist);
    if (persist) {
      await secureStorage.write(
        key: _userKey,
        value: jsonEncode(session.user.toJson()),
      );
    } else {
      await secureStorage.delete(key: _userKey);
    }
  }

  @override
  Future<AuthResponse?> readSavedSession() async {
    final token = await tokenStorage.read();
    final userJson = await secureStorage.read(key: _userKey);
    if (token == null || token.isEmpty || userJson == null) return null;

    try {
      final user = AuthUserModel.fromJson(
        jsonDecode(userJson) as Map<String, dynamic>,
      );
      return AuthResponse(user: user, token: token);
    } on FormatException {
      return null; // Unreadable saved data: treat as signed out
    } on TypeError {
      return null;
    }
  }

  @override
  Future<void> clearSession() async {
    await tokenStorage.delete();
    await secureStorage.delete(key: _userKey);
  }
}
