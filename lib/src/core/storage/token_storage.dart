import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// The device's encrypted key-value store (Keystore on Android, Keychain on iOS).
final secureStorageProvider = Provider<FlutterSecureStorage>(
  (ref) => const FlutterSecureStorage(),
);

final tokenStorageProvider = Provider<TokenStorage>(
  (ref) => TokenStorage(ref.watch(secureStorageProvider)),
);

/// Reads and writes the login token the backend issues. The token is always
/// kept in memory; it is also written to the device only when the user asks
/// to be remembered, so an unremembered session ends when the app closes.
class TokenStorage {
  TokenStorage(this._storage);

  final FlutterSecureStorage _storage;
  String? _memoryToken;

  static const tokenKey = 'jwt_token';

  Future<String?> read() async =>
      _memoryToken ?? await _storage.read(key: tokenKey);

  Future<void> save(String token, {required bool persist}) async {
    _memoryToken = token;
    if (persist) {
      await _storage.write(key: tokenKey, value: token);
    } else {
      // Don't leave an older remembered token behind.
      await _storage.delete(key: tokenKey);
    }
  }

  Future<void> delete() async {
    _memoryToken = null;
    await _storage.delete(key: tokenKey);
  }
}
