import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/auth_user.dart';

part 'auth_response.freezed.dart';
part 'auth_response.g.dart';

/// What /auth/login and /auth/register return: `{"user": {...}, "token": "..."}`.
@freezed
class AuthResponse with _$AuthResponse {
  const factory AuthResponse({
    required AuthUserModel user,
    required String token,
  }) = _AuthResponse;

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
}

/// The backend's user object. Also saved on the device so a remembered
/// session can show who is signed in without a network call.
@freezed
class AuthUserModel with _$AuthUserModel {
  const AuthUserModel._();

  const factory AuthUserModel({
    required String id,
    required String email,
    // Freezed copies this annotation to the generated field, where it applies;
    // the analyzer only sees it on the parameter, hence the ignore.
    // ignore: invalid_annotation_target
    @JsonKey(name: 'display_name') required String displayName,
  }) = _AuthUserModel;

  factory AuthUserModel.fromJson(Map<String, dynamic> json) =>
      _$AuthUserModelFromJson(json);

  AuthUser toEntity() => AuthUser(id: id, email: email, displayName: displayName);
}
