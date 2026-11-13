import 'package:dio/dio.dart';

import '../../../../core/network/api_exception.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
    required bool remember,
  }) async {
    try {
      final session = await remoteDataSource.login(email, password, remember);
      await localDataSource.saveSession(session, persist: remember);
      return session.user.toEntity();
    } on DioException catch (e) {
      // Turns the backend's {"error": ...} into a message for the user
      throw ApiException.fromDioException(e);
    }
  }

  @override
  Future<AuthUser> register({
    required String displayName,
    required String email,
    required String password,
  }) async {
    try {
      // A new account stays signed in, like ticking "Remember me".
      final session =
          await remoteDataSource.register(displayName, email, password, true);
      await localDataSource.saveSession(session, persist: true);
      return session.user.toEntity();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  @override
  Future<AuthUser?> restoreSession() async {
    final session = await localDataSource.readSavedSession();
    return session?.user.toEntity();
  }

  @override
  Future<void> logout() async {
    try {
      // Revokes the session on the server too (paper III-D), while the token
      // is still saved. Best effort, and never a long wait when offline.
      await remoteDataSource.logout().timeout(const Duration(seconds: 5));
    } on Exception catch (_) {
      // The server's session still expires on its own.
    }
    await localDataSource.clearSession();
  }
}
