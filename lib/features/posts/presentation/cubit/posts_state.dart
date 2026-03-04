import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:somnio/core/error/failures.dart';
import 'package:somnio/features/posts/domain/entities/post_entity.dart';

part 'posts_state.freezed.dart';

@freezed
sealed class PostsState with _$PostsState {
  const factory PostsState.initial() = PostsInitial;
  const factory PostsState.loading() = PostsLoading;
  const factory PostsState.loaded(List<PostEntity> posts) = PostsLoaded;
  const factory PostsState.error(Failure failure) = PostsError;
}
