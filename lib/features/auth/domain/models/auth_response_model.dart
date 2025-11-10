// lib/features/auth/domain/models/auth_response_model.dart
import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';

part 'auth_response_model.g.dart';

@JsonSerializable()
class AuthResponseModel {
  final String? token;
  @JsonKey(name: 'access_token')
  final String? accessToken;
  final UserModel? user;

  AuthResponseModel({
    this.token,
    this.accessToken,
    this.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseModelToJson(this);

  /// Obtiene el token (puede venir como 'token' o 'access_token')
  String? get authToken => token ?? accessToken;
}
