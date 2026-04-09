import '../repositories/auth_repository.dart';
import '../../data/models/auth_response.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<AuthResponse> execute(
      String email, String password, bool remember) async {
    return await repository.login(email, password, remember);
  }
}
