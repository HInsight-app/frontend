import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// The device's encrypted key-value store (Keystore on Android, Keychain on iOS).
final secureStorageProvider = Provider<FlutterSecureStorage>(
  (ref) => const FlutterSecureStorage(),
);

final tokenStorageProvider = Provider<TokenStorage>(
  (ref) => TokenStorage(ref.watch(secureStorageProvider)),
);

/// Reads and writes the login token (JWT) the backend issues.
class TokenStorage {
  TokenStorage(this._storage);

  final FlutterSecureStorage _storage;

  /// Same key AuthLocalDataSourceImpl writes, so tokens saved by the login
  /// page are found here. Phase 3 makes the auth feature use this class.
  static const tokenKey = 'jwt_token';

  Future<String?> read() => _storage.read(key: tokenKey);

  Future<void> save(String token) => _storage.write(key: tokenKey, value: token);

  Future<void> delete() => _storage.delete(key: tokenKey);
}
