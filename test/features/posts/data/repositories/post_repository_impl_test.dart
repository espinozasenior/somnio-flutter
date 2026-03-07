import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:somnio/core/error/exceptions.dart';
import 'package:somnio/core/error/failures.dart';
import 'package:somnio/core/network/network_info.dart';
import 'package:somnio/features/posts/data/datasources/local/post_local_data_source.dart';
import 'package:somnio/features/posts/data/datasources/remote/post_remote_data_source.dart';
import 'package:somnio/features/posts/data/repositories/post_repository_impl.dart';

import '../../../../helpers/helpers.dart';

class _MockPostRemoteDataSource extends Mock implements PostRemoteDataSource {}

class _MockPostLocalDataSource extends Mock implements PostLocalDataSource {}

class _MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  group('$PostRepositoryImpl', () {
    late _MockPostRemoteDataSource mockRemote;
    late _MockPostLocalDataSource mockLocal;
    late _MockNetworkInfo mockNetworkInfo;
    late PostRepositoryImpl repository;

    setUp(() {
      mockRemote = _MockPostRemoteDataSource();
      mockLocal = _MockPostLocalDataSource();
      mockNetworkInfo = _MockNetworkInfo();
      repository = PostRepositoryImpl(
        remoteDataSource: mockRemote,
        localDataSource: mockLocal,
        networkInfo: mockNetworkInfo,
      );
    });

    group('getPosts', () {
      test('returns remote data when online', () async {
        final models = TestFixtures.postModels(2);
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemote.getPosts()).thenAnswer((_) async => models);
        when(() => mockLocal.cachePosts(models)).thenAnswer((_) async {});

        final result = await repository.getPosts();

        expect(result.isRight(), isTrue);
        verify(() => mockRemote.getPosts()).called(1);
        verify(() => mockLocal.cachePosts(models)).called(1);
      });

      test('caches data after remote fetch', () async {
        final models = TestFixtures.postModels(2);
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemote.getPosts()).thenAnswer((_) async => models);
        when(() => mockLocal.cachePosts(models)).thenAnswer((_) async {});

        await repository.getPosts();

        verify(() => mockLocal.cachePosts(models)).called(1);
      });

      test('returns cached data when offline', () async {
        final models = TestFixtures.postModels(2);
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(() => mockLocal.getCachedPosts()).thenAnswer((_) async => models);

        final result = await repository.getPosts();

        expect(result.isRight(), isTrue);
        verifyNever(() => mockRemote.getPosts());
        verify(() => mockLocal.getCachedPosts()).called(1);
      });

      test('returns $CacheFailure when offline and no cache', () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(
          () => mockLocal.getCachedPosts(),
        ).thenThrow(const CacheException(message: 'No cached posts'));

        final result = await repository.getPosts();

        expect(
          result,
          isA<Left<Failure, dynamic>>().having(
            (l) => l.value,
            'failure',
            isA<CacheFailure>(),
          ),
        );
      });
    });

    group('getPostById', () {
      test('returns entity on success', () async {
        final model = TestFixtures.postModel();
        when(() => mockRemote.getPostById(1)).thenAnswer((_) async => model);

        final result = await repository.getPostById(1);

        expect(result.isRight(), isTrue);
      });
    });
  });
}
