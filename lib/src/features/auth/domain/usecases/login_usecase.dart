import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<AuthUser> execute({
    required String email,
    required String password,
    required bool remember,
  }) {
    return repository.login(
      email: email,
      password: password,
      remember: remember,
    );
  }
}
