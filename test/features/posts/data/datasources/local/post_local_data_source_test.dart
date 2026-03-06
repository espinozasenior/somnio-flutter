import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:somnio/core/error/exceptions.dart';
import 'package:somnio/features/posts/data/datasources/local/post_local_data_source.dart';

import '../../../../../helpers/helpers.dart';

class _MockBox extends Mock implements Box<String> {}

void main() {
  late _MockBox mockBox;
  late PostLocalDataSource dataSource;

  setUp(() {
    mockBox = _MockBox();
    dataSource = PostLocalDataSource(mockBox);
  });

  group('$PostLocalDataSource', () {
    group('getCachedPosts', () {
      test('returns list of PostModel from cache', () async {
        const json = '[{"id":1,"userId":1,"title":"Test","body":"Body"}]';
        when(() => mockBox.get('cached_posts')).thenReturn(json);

        final result = await dataSource.getCachedPosts();

        expect(result.length, 1);
        expect(result.first.id, 1);
        expect(result.first.title, 'Test');
      });

      test('throws CacheException when no cached data', () {
        when(() => mockBox.get('cached_posts')).thenReturn(null);

        expect(
          () => dataSource.getCachedPosts(),
          throwsA(isA<CacheException>()),
        );
      });
    });

    group('cachePosts', () {
      test('puts JSON string into box', () async {
        when(() => mockBox.put(any(), any()))
            .thenAnswer((_) async {});

        final posts = TestFixtures.postModels(2);
        await dataSource.cachePosts(posts);

        verify(
          () => mockBox.put('cached_posts', any()),
        ).called(1);
      });
    });
  });
}
