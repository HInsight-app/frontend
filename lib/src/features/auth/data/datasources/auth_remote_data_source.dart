import 'package:dio/dio.dart';
import '../models/auth_response.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponse> login(String email, String password, bool remember);
  Future<AuthResponse> register(
      String displayName, String email, String password, bool remember);

  /// Ends the session on the server. AuthInterceptor sends its token.
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<AuthResponse> login(
      String email, String password, bool remember) async {
    final response = await dio.post(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
        'remember': remember,
      },
    );

    return AuthResponse.fromJson(response.data);
  }

  @override
  Future<AuthResponse> register(
      String displayName, String email, String password, bool remember) async {
    final response = await dio.post(
      '/auth/register',
      data: {
        'display_name': displayName,
        'email': email,
        'password': password,
        'remember': remember,
      },
    );

    return AuthResponse.fromJson(response.data);
  }

  @override
  Future<void> logout() => dio.post<void>('/auth/logout');
}
