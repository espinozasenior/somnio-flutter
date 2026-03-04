import 'package:bloc/bloc.dart';
import 'package:somnio/core/usecase/usecase.dart';
import 'package:somnio/features/posts/domain/usecases/get_posts.dart';
import 'package:somnio/features/posts/presentation/cubit/posts_state.dart';

class PostsCubit extends Cubit<PostsState> {
  PostsCubit(this._getPosts) : super(const PostsState.initial());

  final GetPosts _getPosts;

  Future<void> loadPosts() async {
    emit(const PostsState.loading());
    final result = await _getPosts(const NoParams());
    result.fold(
      (failure) => emit(PostsState.error(failure)),
      (posts) => emit(PostsState.loaded(posts)),
    );
  }
}
