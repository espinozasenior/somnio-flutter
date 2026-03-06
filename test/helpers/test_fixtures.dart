import 'package:somnio/core/error/failures.dart';
import 'package:somnio/features/auth/domain/entities/auth_tokens.dart';
import 'package:somnio/features/auth/domain/entities/user_entity.dart';
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

  static const authFailure = AuthFailure(
    message: 'Invalid credentials',
    statusCode: 401,
  );

  static const authTokens = AuthTokens(
    accessToken: 'test_access_token',
    refreshToken: 'test_refresh_token',
  );

  static UserEntity userEntity({String id = '1'}) => UserEntity(
        id: id,
        email: 'test@example.com',
        name: 'Test User',
      );
}
