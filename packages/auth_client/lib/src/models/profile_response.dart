import 'package:json_annotation/json_annotation.dart';

part 'profile_response.g.dart';

@JsonSerializable()
class ProfileResponse {
  const ProfileResponse({
    required this.id,
    required this.email,
    this.name,
    this.avatar,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseFromJson(json);

  final String id;
  final String email;
  final String? name;
  final String? avatar;

  Map<String, dynamic> toJson() => _$ProfileResponseToJson(this);
}
