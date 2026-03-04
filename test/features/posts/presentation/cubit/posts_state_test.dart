import 'package:flutter_test/flutter_test.dart';
import 'package:somnio/features/posts/presentation/cubit/posts_state.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('$PostsState', () {
    group('$PostsInitial', () {
      test('supports value equality', () {
        expect(
          const PostsState.initial(),
          equals(const PostsState.initial()),
        );
      });
    });

    group('$PostsLoading', () {
      test('supports value equality', () {
        expect(
          const PostsState.loading(),
          equals(const PostsState.loading()),
        );
      });
    });

    group('$PostsLoaded', () {
      test('supports value equality', () {
        final posts = TestFixtures.postEntities(2);
        expect(
          PostsState.loaded(posts),
          equals(PostsState.loaded(posts)),
        );
      });

      test('props contain posts list', () {
        final posts = TestFixtures.postEntities(2);
        final state = PostsState.loaded(posts) as PostsLoaded;
        expect(state.posts, posts);
      });
    });

    group('$PostsError', () {
      test('supports value equality', () {
        expect(
          const PostsState.error(TestFixtures.serverFailure),
          equals(const PostsState.error(TestFixtures.serverFailure)),
        );
      });

      test('props contain failure', () {
        const state = PostsState.error(TestFixtures.serverFailure);
        expect((state as PostsError).failure, TestFixtures.serverFailure);
      });
    });
  });
}
