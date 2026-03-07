import 'dart:io';

import 'package:auth_client/auth_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:somnio/core/di/injection.dart';
import 'package:somnio/core/network/api_error_interceptor.dart';
import 'package:somnio/core/network/network_info.dart';
import 'package:somnio/core/routing/app_router.dart';
import 'package:somnio/features/auth/data/datasources/local/auth_local_data_source.dart';
import 'package:somnio/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:somnio/features/auth/domain/repositories/auth_repository.dart';
import 'package:somnio/features/posts/data/datasources/local/post_local_data_source.dart';
import 'package:somnio/features/posts/data/datasources/remote/post_remote_data_source.dart';
import 'package:somnio/features/posts/domain/repositories/post_repository.dart';
import 'package:somnio/features/posts/presentation/cubit/post_detail_cubit.dart';
import 'package:somnio/features/posts/presentation/cubit/posts_cubit.dart';
import 'package:token_provider/token_provider.dart';
import 'package:user_repository/user_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('configureDependencies', () {
    setUp(() async {
      final tempDir = await Directory.systemTemp.createTemp('somnio_test_hive');
      Hive.init(tempDir.path);
      await getIt.reset();
      await configureDependencies();
    });

    tearDown(() async {
      await getIt.reset();
      if (Hive.isBoxOpen('posts_cache')) {
        await Hive.box<String>('posts_cache').deleteFromDisk();
      }
    });

    test('registers core, auth, and posts dependencies', () {
      expect(getIt.isRegistered<NetworkInfo>(), isTrue);
      expect(getIt.isRegistered<TokenProvider>(), isTrue);
      expect(getIt.isRegistered<AuthApiClient>(), isTrue);
      expect(getIt.isRegistered<UserRepository>(), isTrue);
      expect(getIt.isRegistered<AuthRemoteDataSource>(), isTrue);
      expect(getIt.isRegistered<AuthLocalDataSource>(), isTrue);
      expect(getIt.isRegistered<AuthRepository>(), isTrue);
      expect(getIt.isRegistered<PostRemoteDataSource>(), isTrue);
      expect(getIt.isRegistered<PostLocalDataSource>(), isTrue);
      expect(getIt.isRegistered<PostRepository>(), isTrue);
      expect(getIt.isRegistered<AppRouter>(), isTrue);
    });

    test('builds expected dio clients and interceptors', () {
      final publicDio = getIt<Dio>(instanceName: 'publicDio');
      final authDio = getIt<Dio>(instanceName: 'authDio');

      expect(publicDio.options.baseUrl, isNotEmpty);
      expect(
        publicDio.interceptors.whereType<ApiErrorInterceptor>().length,
        1,
      );

      expect(authDio.options.baseUrl, isNotEmpty);
      expect(authDio.options.headers['Content-Type'], 'application/json');
      expect(authDio.interceptors.length, greaterThanOrEqualTo(2));
      expect(
        authDio.interceptors.whereType<ApiErrorInterceptor>().length,
        1,
      );
    });

    test('resolves factory cubits as new instances', () {
      final postsCubitA = getIt<PostsCubit>();
      final postsCubitB = getIt<PostsCubit>();
      final detailCubitA = getIt<PostDetailCubit>();
      final detailCubitB = getIt<PostDetailCubit>();

      expect(postsCubitA, isNot(same(postsCubitB)));
      expect(detailCubitA, isNot(same(detailCubitB)));
    });
  });
}
