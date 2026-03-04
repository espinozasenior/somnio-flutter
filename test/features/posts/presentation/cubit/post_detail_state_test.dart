import 'package:flutter_test/flutter_test.dart';
import 'package:somnio/features/posts/presentation/cubit/post_detail_state.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('$PostDetailState', () {
    group('$PostDetailInitial', () {
      test('supports value equality', () {
        expect(
          const PostDetailState.initial(),
          equals(const PostDetailState.initial()),
        );
      });
    });

    group('$PostDetailLoading', () {
      test('supports value equality', () {
        expect(
          const PostDetailState.loading(),
          equals(const PostDetailState.loading()),
        );
      });
    });

    group('$PostDetailLoaded', () {
      test('supports value equality', () {
        final post = TestFixtures.postEntity();
        expect(
          PostDetailState.loaded(post),
          equals(PostDetailState.loaded(post)),
        );
      });
    });

    group('$PostDetailError', () {
      test('supports value equality', () {
        expect(
          const PostDetailState.error(TestFixtures.serverFailure),
          equals(const PostDetailState.error(TestFixtures.serverFailure)),
        );
      });
    });
  });
}
