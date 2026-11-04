import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<AuthUser> execute({
    required String displayName,
    required String email,
    required String password,
  }) {
    return repository.register(
      displayName: displayName,
      email: email,
      password: password,
    );
  }
}
