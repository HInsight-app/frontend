import '../repositories/auth_repository.dart';
import '../../data/models/auth_response.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<AuthResponse> execute(
      String name, String email, String password) async {
    return await repository.register(name, email, password);
  }
}
