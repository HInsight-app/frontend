import 'package:dio/dio.dart';
import '../models/auth_response.dart';

// The Interface
abstract class AuthRemoteDataSource {
  Future<AuthResponse> login(String email, String password, bool remember);
  Future<AuthResponse> register(String name, String email, String password);
}

// The Implementation
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

    // Converts the raw JSON into your Freezed object
    return AuthResponse.fromJson(response.data);
  }

  @override
  Future<AuthResponse> register(
      String name, String email, String password) async {
    // NOTE: Replace '/register' with your backend's actual endpoint path
    final response = await dio.post(
      '/auth/register',
      data: {
        'display_name': name,
        'email': email,
        'password': password,
      },
    );

    return AuthResponse.fromJson(response.data);
  }
}
