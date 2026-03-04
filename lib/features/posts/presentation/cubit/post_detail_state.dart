import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:somnio/core/error/failures.dart';
import 'package:somnio/features/posts/domain/entities/post_entity.dart';

part 'post_detail_state.freezed.dart';

@freezed
sealed class PostDetailState with _$PostDetailState {
  const factory PostDetailState.initial() = PostDetailInitial;
  const factory PostDetailState.loading() = PostDetailLoading;
  const factory PostDetailState.loaded(PostEntity post) = PostDetailLoaded;
  const factory PostDetailState.error(Failure failure) = PostDetailError;
}
