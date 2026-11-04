import 'package:hinsight/src/features/auth/domain/entities/auth_user.dart';
import 'package:hinsight/src/features/auth/domain/repositories/auth_repository.dart';

const testUser = AuthUser(
  id: '7f8c1c2e-0000-4000-8000-000000000001',
  email: 'owen@binus.ac.id',
  displayName: 'Owen',
);

/// An AuthRepository with no network or storage. [savedUser] is what
/// restoreSession returns; set [error] to make login and register fail.
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({this.savedUser});

  AuthUser? savedUser;
  Object? error;

  String? lastEmail;
  String? lastPassword;
  bool? lastRemember;
  String? lastDisplayName;
  int logoutCalls = 0;

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
    required bool remember,
  }) async {
    lastEmail = email;
    lastPassword = password;
    lastRemember = remember;
    if (error != null) throw error!;
    return savedUser = testUser;
  }

  @override
  Future<AuthUser> register({
    required String displayName,
    required String email,
    required String password,
  }) async {
    lastDisplayName = displayName;
    lastEmail = email;
    lastPassword = password;
    if (error != null) throw error!;
    return savedUser = testUser;
  }

  @override
  Future<AuthUser?> restoreSession() async => savedUser;

  @override
  Future<void> logout() async {
    logoutCalls++;
    savedUser = null;
  }
}
