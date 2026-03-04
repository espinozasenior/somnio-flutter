import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:somnio/core/network/api_error_interceptor.dart';
import 'package:somnio/core/network/network_info.dart';
import 'package:somnio/core/routing/app_router.dart';
import 'package:somnio/features/posts/data/datasources/local/post_local_data_source.dart';
import 'package:somnio/features/posts/data/datasources/remote/post_remote_data_source.dart';
import 'package:somnio/features/posts/data/repositories/post_repository_impl.dart';
import 'package:somnio/features/posts/domain/repositories/post_repository.dart';
import 'package:somnio/features/posts/domain/usecases/get_post_by_id.dart';
import 'package:somnio/features/posts/domain/usecases/get_posts.dart';
import 'package:somnio/features/posts/presentation/cubit/post_detail_cubit.dart';
import 'package:somnio/features/posts/presentation/cubit/posts_cubit.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  final postsBox = await Hive.openBox<String>('posts_cache');

  getIt
    // Network
    ..registerLazySingleton<Connectivity>(Connectivity.new)
    ..registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(getIt<Connectivity>()),
    )
    // Dio
    ..registerLazySingleton<Dio>(() {
      return Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          sendTimeout: const Duration(seconds: 15),
          headers: <String, dynamic>{
            'Accept': 'application/json',
          },
        ),
      )..interceptors.add(ApiErrorInterceptor());
    })
    // Posts Feature - Data Sources
    ..registerLazySingleton<PostRemoteDataSource>(
      () => PostRemoteDataSource(getIt<Dio>()),
    )
    ..registerLazySingleton<PostLocalDataSource>(
      () => PostLocalDataSource(postsBox),
    )
    // Posts Feature - Repository
    ..registerLazySingleton<PostRepository>(
      () => PostRepositoryImpl(
        remoteDataSource: getIt<PostRemoteDataSource>(),
        localDataSource: getIt<PostLocalDataSource>(),
        networkInfo: getIt<NetworkInfo>(),
      ),
    )
    // Posts Feature - Use Cases
    ..registerLazySingleton<GetPosts>(
      () => GetPosts(getIt<PostRepository>()),
    )
    ..registerLazySingleton<GetPostById>(
      () => GetPostById(getIt<PostRepository>()),
    )
    // Posts Feature - Cubits
    ..registerFactory<PostsCubit>(
      () => PostsCubit(getIt<GetPosts>()),
    )
    ..registerFactory<PostDetailCubit>(
      () => PostDetailCubit(getIt<GetPostById>()),
    )
    // Router
    ..registerLazySingleton<AppRouter>(AppRouter.new);
}
