import 'package:dartz/dartz.dart';
import 'package:somnio/core/error/failures.dart';
import 'package:somnio/features/posts/domain/entities/post_entity.dart';
import 'package:somnio/features/posts/domain/repositories/post_repository.dart';

/// Fake [PostRepository] for testing without mocking frameworks.
///
/// Set [getPostsResult] / [getPostByIdResult] before exercising the SUT.
class FakePostRepository implements PostRepository {
  Either<Failure, List<PostEntity>>? getPostsResult;
  Either<Failure, PostEntity>? getPostByIdResult;
  int getPostsCallCount = 0;
  int getPostByIdCallCount = 0;
  int? lastGetPostByIdArg;

  @override
  Future<Either<Failure, List<PostEntity>>> getPosts() async {
    getPostsCallCount++;
    return getPostsResult!;
  }

  @override
  Future<Either<Failure, PostEntity>> getPostById(int id) async {
    getPostByIdCallCount++;
    lastGetPostByIdArg = id;
    return getPostByIdResult!;
  }
}
