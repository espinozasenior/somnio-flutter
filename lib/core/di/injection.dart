import 'package:auth_client/auth_client.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:somnio/core/constants/app_constants.dart';
import 'package:somnio/core/network/api_error_interceptor.dart';
import 'package:somnio/core/network/network_info.dart';
import 'package:somnio/core/routing/app_router.dart';
import 'package:somnio/features/auth/data/datasources/local/auth_local_data_source.dart';
import 'package:somnio/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:somnio/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:somnio/features/auth/domain/repositories/auth_repository.dart';
import 'package:somnio/features/auth/domain/usecases/apple_sign_in_usecase.dart';
import 'package:somnio/features/auth/domain/usecases/change_password_usecase.dart';
import 'package:somnio/features/auth/domain/usecases/delete_account_usecase.dart';
import 'package:somnio/features/auth/domain/usecases/get_profile_usecase.dart';
import 'package:somnio/features/auth/domain/usecases/google_sign_in_usecase.dart';
import 'package:somnio/features/auth/domain/usecases/login_usecase.dart';
import 'package:somnio/features/auth/domain/usecases/logout_usecase.dart';
import 'package:somnio/features/auth/domain/usecases/register_usecase.dart';
import 'package:somnio/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:somnio/features/auth/presentation/cubit/login_cubit.dart';
import 'package:somnio/features/auth/presentation/cubit/signup_cubit.dart';
import 'package:somnio/features/posts/data/datasources/local/post_local_data_source.dart';
import 'package:somnio/features/posts/data/datasources/remote/post_remote_data_source.dart';
import 'package:somnio/features/posts/data/repositories/post_repository_impl.dart';
import 'package:somnio/features/posts/domain/repositories/post_repository.dart';
import 'package:somnio/features/posts/domain/usecases/get_post_by_id.dart';
import 'package:somnio/features/posts/domain/usecases/get_posts.dart';
import 'package:somnio/features/posts/presentation/cubit/post_detail_cubit.dart';
import 'package:somnio/features/posts/presentation/cubit/posts_cubit.dart';
import 'package:token_provider/token_provider.dart';
import 'package:user_repository/user_repository.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  final postsBox = await Hive.openBox<String>('posts_cache');

  getIt
    // Network
    ..registerLazySingleton<Connectivity>(Connectivity.new)
    ..registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(getIt<Connectivity>()),
    )
    // Token Provider
    ..registerLazySingleton<TokenProvider>(SecureTokenProvider.new)
    // Dio — public API (posts)
    ..registerLazySingleton<Dio>(
      () {
        return Dio(
          BaseOptions(
            baseUrl: AppConstants.apiBaseUrl,
            connectTimeout: AppConstants.connectionTimeout,
            receiveTimeout: AppConstants.receiveTimeout,
            sendTimeout: AppConstants.connectionTimeout,
            headers: <String, dynamic>{
              'Accept': 'application/json',
            },
          ),
        )..interceptors.add(ApiErrorInterceptor());
      },
      instanceName: 'publicDio',
    )
    // Dio — auth API (NestJS backend)
    ..registerLazySingleton<Dio>(
      () {
        final dio = Dio(
          BaseOptions(
            baseUrl: AppConstants.authApiBaseUrl,
            connectTimeout: AppConstants.connectionTimeout,
            receiveTimeout: AppConstants.receiveTimeout,
            sendTimeout: AppConstants.connectionTimeout,
            headers: <String, dynamic>{
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          ),
        );
        dio.interceptors.addAll([
          AuthTokenInterceptor(
            tokenProvider: getIt<TokenProvider>(),
            dio: dio,
          ),
          ApiErrorInterceptor(),
        ]);
        return dio;
      },
      instanceName: 'authDio',
    )
    // Auth Client
    ..registerLazySingleton<AuthApiClient>(
      () => AuthApiClient(getIt<Dio>(instanceName: 'authDio')),
    )
    // User Repository
    ..registerLazySingleton<UserRepository>(
      () => UserRepository(
        authApiClient: getIt<AuthApiClient>(),
        tokenProvider: getIt<TokenProvider>(),
      ),
    )
    // Auth Feature - Data Sources
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSource(
        authApiClient: getIt<AuthApiClient>(),
      ),
    )
    ..registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSource(
        tokenProvider: getIt<TokenProvider>(),
      ),
    )
    // Auth Feature - Repository
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: getIt<AuthRemoteDataSource>(),
        localDataSource: getIt<AuthLocalDataSource>(),
      ),
    )
    // Auth Feature - Use Cases
    ..registerLazySingleton<LoginUseCase>(
      () => LoginUseCase(getIt<AuthRepository>()),
    )
    ..registerLazySingleton<RegisterUseCase>(
      () => RegisterUseCase(getIt<AuthRepository>()),
    )
    ..registerLazySingleton<LogoutUseCase>(
      () => LogoutUseCase(getIt<AuthRepository>()),
    )
    ..registerLazySingleton<GoogleSignInUseCase>(
      () => GoogleSignInUseCase(getIt<AuthRepository>()),
    )
    ..registerLazySingleton<AppleSignInUseCase>(
      () => AppleSignInUseCase(getIt<AuthRepository>()),
    )
    ..registerLazySingleton<ChangePasswordUseCase>(
      () => ChangePasswordUseCase(getIt<AuthRepository>()),
    )
    ..registerLazySingleton<DeleteAccountUseCase>(
      () => DeleteAccountUseCase(getIt<AuthRepository>()),
    )
    ..registerLazySingleton<GetProfileUseCase>(
      () => GetProfileUseCase(getIt<AuthRepository>()),
    )
    // Auth Feature - Cubits
    ..registerLazySingleton<AuthCubit>(
      () => AuthCubit(
        userRepository: getIt<UserRepository>(),
        logoutUseCase: getIt<LogoutUseCase>(),
      ),
    )
    ..registerFactory<LoginCubit>(
      () => LoginCubit(
        loginUseCase: getIt<LoginUseCase>(),
        userRepository: getIt<UserRepository>(),
      ),
    )
    ..registerFactory<SignupCubit>(
      () => SignupCubit(
        registerUseCase: getIt<RegisterUseCase>(),
        userRepository: getIt<UserRepository>(),
      ),
    )
    // Posts Feature - Data Sources
    ..registerLazySingleton<PostRemoteDataSource>(
      () => PostRemoteDataSource(getIt<Dio>(instanceName: 'publicDio')),
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
    ..registerLazySingleton<AppRouter>(
      () => AppRouter(userRepository: getIt<UserRepository>()),
    );
}
