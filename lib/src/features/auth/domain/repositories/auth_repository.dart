import '../../data/models/auth_response.dart';

// The Interface (Contract)
// This strictly defines what the repository MUST be able to do.
abstract class AuthRepository {
  Future<AuthResponse> login(String email, String password, bool remember);
  Future<AuthResponse> register(String name, String email, String password);
}
