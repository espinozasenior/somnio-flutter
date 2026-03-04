import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:somnio/core/error/failures.dart';
import 'package:somnio/core/usecase/usecase.dart';
import 'package:somnio/features/posts/domain/entities/post_entity.dart';
import 'package:somnio/features/posts/domain/usecases/get_posts.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('$GetPosts', () {
    late FakePostRepository fakeRepository;
    late GetPosts useCase;

    setUp(() {
      fakeRepository = FakePostRepository();
      useCase = GetPosts(fakeRepository);
    });

    test('returns list of entities from repository', () async {
      final expected = TestFixtures.postEntities(3);
      fakeRepository.getPostsResult = Right(expected);

      final result = await useCase(const NoParams());

      expect(
        result,
        Right<Failure, List<PostEntity>>(expected),
      );
      expect(fakeRepository.getPostsCallCount, 1);
    });

    test('returns $Failure when repository fails', () async {
      fakeRepository.getPostsResult = const Left(TestFixtures.serverFailure);

      final result = await useCase(const NoParams());

      expect(
        result,
        const Left<Failure, List<PostEntity>>(TestFixtures.serverFailure),
      );
    });
  });
}
