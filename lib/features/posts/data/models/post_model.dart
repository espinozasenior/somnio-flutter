import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:somnio/features/posts/domain/entities/post_entity.dart';

part 'post_model.g.dart';

@JsonSerializable()
class PostModel extends Equatable {
  const PostModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  final int id;
  final int userId;
  final String title;
  final String body;

  PostModel copyWith({
    int? id,
    int? userId,
    String? title,
    String? body,
  }) {
    return PostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }

  static PostModel fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostModelToJson(this);

  @override
  List<Object?> get props => [id, userId, title, body];
}

extension PostModelX on PostModel {
  PostEntity toEntity() => PostEntity(
    id: id,
    userId: userId,
    title: title,
    body: body,
  );
}

extension PostEntityX on PostEntity {
  PostModel toModel() => PostModel(
    id: id,
    userId: userId,
    title: title,
    body: body,
  );
}
