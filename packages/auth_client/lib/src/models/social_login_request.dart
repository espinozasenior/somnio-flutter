import 'package:json_annotation/json_annotation.dart';

part 'social_login_request.g.dart';

@JsonSerializable()
class SocialLoginRequest {
  const SocialLoginRequest({
    required this.token,
    this.provider,
  });

  factory SocialLoginRequest.fromJson(Map<String, dynamic> json) =>
      _$SocialLoginRequestFromJson(json);

  final String token;
  final String? provider;

  Map<String, dynamic> toJson() => _$SocialLoginRequestToJson(this);
}
