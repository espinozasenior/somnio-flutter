import 'package:bloc/bloc.dart';
import 'package:somnio/features/posts/domain/usecases/get_post_by_id.dart';
import 'package:somnio/features/posts/presentation/cubit/post_detail_state.dart';

class PostDetailCubit extends Cubit<PostDetailState> {
  PostDetailCubit(this._getPostById) : super(const PostDetailState.initial());

  final GetPostById _getPostById;

  Future<void> loadPost(int id) async {
    emit(const PostDetailState.loading());
    final result = await _getPostById(id);
    result.fold(
      (failure) => emit(PostDetailState.error(failure)),
      (post) => emit(PostDetailState.loaded(post)),
    );
  }
}
