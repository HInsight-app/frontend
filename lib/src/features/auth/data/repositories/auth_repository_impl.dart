import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../datasources/auth_local_data_source.dart';
import '../models/auth_response.dart';
import 'package:dio/dio.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<AuthResponse> login(
      String email, String password, bool remember) async {
    try {
      final response = await remoteDataSource.login(email, password, remember);
      await localDataSource.saveToken(response.token);
      return response;
    } on DioException catch (e) {
      // Catch specific Dio errors and throw a cleaner exception
      throw Exception(
          'Login failed: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<AuthResponse> register(
      String name, String email, String password) async {
    try {
      final response = await remoteDataSource.register(name, email, password);
      await localDataSource.saveToken(response.token);
      return response;
    } on DioException catch (e) {
      throw Exception(
          'Registration failed: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
