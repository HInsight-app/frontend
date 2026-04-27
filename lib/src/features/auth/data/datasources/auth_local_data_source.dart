import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// The Interface (The Menu)
abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> deleteToken();
}

// The Implementation (The Vault Manager)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;

  // We use a constant key name so we always open the right "drawer" in the vault
  static const String _tokenKey = 'jwt_token';

  AuthLocalDataSourceImpl({required this.secureStorage});

  @override
  Future<void> saveToken(String token) async {
    await secureStorage.write(key: _tokenKey, value: token);
    print('Vault: Token saved securely!');
  }

  @override
  Future<String?> getToken() async {
    return await secureStorage.read(key: _tokenKey);
  }

  @override
  Future<void> deleteToken() async {
    await secureStorage.delete(key: _tokenKey);
    print('Vault: Token deleted (Logged out).');
  }
}
