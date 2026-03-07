import 'package:dartz/dartz.dart';
import 'package:somnio/core/error/error_handler.dart';
import 'package:somnio/core/error/failures.dart';
import 'package:somnio/core/network/network_info.dart';
import 'package:somnio/features/posts/data/datasources/local/post_local_data_source.dart';
import 'package:somnio/features/posts/data/datasources/remote/post_remote_data_source.dart';
import 'package:somnio/features/posts/data/models/post_model.dart';
import 'package:somnio/features/posts/domain/entities/post_entity.dart';
import 'package:somnio/features/posts/domain/repositories/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  PostRepositoryImpl({
    required PostRemoteDataSource remoteDataSource,
    required PostLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _networkInfo = networkInfo;

  final PostRemoteDataSource _remoteDataSource;
  final PostLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, List<PostEntity>>> getPosts() async {
    if (await _networkInfo.isConnected) {
      return safeApiCall(() async {
        final models = await _remoteDataSource.getPosts();
        await _localDataSource.cachePosts(models);
        return models.map((m) => m.toEntity()).toList();
      });
    } else {
      return safeCacheCall(() async {
        final models = await _localDataSource.getCachedPosts();
        return models.map((m) => m.toEntity()).toList();
      });
    }
  }

  @override
  Future<Either<Failure, PostEntity>> getPostById(int id) {
    return safeApiCall(() async {
      final model = await _remoteDataSource.getPostById(id);
      return model.toEntity();
    });
  }
}
