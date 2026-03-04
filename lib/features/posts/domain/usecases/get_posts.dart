import 'package:dartz/dartz.dart';
import 'package:somnio/core/error/failures.dart';
import 'package:somnio/core/usecase/usecase.dart';
import 'package:somnio/features/posts/domain/entities/post_entity.dart';
import 'package:somnio/features/posts/domain/repositories/post_repository.dart';

class GetPosts extends UseCase<List<PostEntity>, NoParams> {
  GetPosts(this._repository);

  final PostRepository _repository;

  @override
  Future<Either<Failure, List<PostEntity>>> call(NoParams params) {
    return _repository.getPosts();
  }
}
