import 'package:somnio/core/error/failures.dart';
import 'package:somnio/features/posts/data/models/post_model.dart';
import 'package:somnio/features/posts/domain/entities/post_entity.dart';

abstract final class TestFixtures {
  static PostEntity postEntity({int id = 1}) => PostEntity(
        id: id,
        userId: 1,
        title: 'Test Post $id',
        body: 'Test body for post $id',
      );

  static PostModel postModel({int id = 1}) => PostModel(
        id: id,
        userId: 1,
        title: 'Test Post $id',
        body: 'Test body for post $id',
      );

  static List<PostEntity> postEntities(int count) =>
      List.generate(count, (i) => postEntity(id: i + 1));

  static List<PostModel> postModels(int count) =>
      List.generate(count, (i) => postModel(id: i + 1));

  static const serverFailure = ServerFailure(
    message: 'Server error',
    statusCode: 500,
  );

  static const networkFailure = NetworkFailure(
    message: 'No internet connection',
  );

  static const cacheFailure = CacheFailure(
    message: 'No cached data',
  );
}
