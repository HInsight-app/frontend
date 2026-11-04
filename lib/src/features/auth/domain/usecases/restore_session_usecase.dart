import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class RestoreSessionUseCase {
  final AuthRepository repository;

  RestoreSessionUseCase(this.repository);

  Future<AuthUser?> execute() => repository.restoreSession();
}
