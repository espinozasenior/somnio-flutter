import 'package:dartz/dartz.dart';
import 'package:somnio/core/error/failures.dart';
import 'package:somnio/core/usecase/usecase.dart';
import 'package:somnio/features/posts/domain/entities/post_entity.dart';
import 'package:somnio/features/posts/domain/repositories/post_repository.dart';

class GetPostById extends UseCase<PostEntity, int> {
  GetPostById(this._repository);

  final PostRepository _repository;

  @override
  Future<Either<Failure, PostEntity>> call(int params) {
    return _repository.getPostById(params);
  }
}
