import 'package:json_annotation/json_annotation.dart';

part 'auth_response.g.dart';

@JsonSerializable()
class AuthResponse {
  const AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    this.userId,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  final String accessToken;
  final String refreshToken;
  final String? userId;

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}
