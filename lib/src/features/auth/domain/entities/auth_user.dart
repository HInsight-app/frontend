/// The signed-in student, as the rest of the app sees them. Mirrors the
/// backend's USERS row (id, email, display_name).
class AuthUser {
  const AuthUser({
    required this.id,
    required this.email,
    required this.displayName,
  });

  final String id; // PostgreSQL UUID
  final String email;
  final String displayName;

  @override
  bool operator ==(Object other) =>
      other is AuthUser &&
      other.id == id &&
      other.email == email &&
      other.displayName == displayName;

  @override
  int get hashCode => Object.hash(id, email, displayName);
}
