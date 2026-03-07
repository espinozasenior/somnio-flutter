import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:somnio/core/error/failures.dart';
import 'package:somnio/features/posts/domain/entities/post_entity.dart';
import 'package:somnio/features/posts/domain/usecases/get_post_by_id.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('$GetPostById', () {
    late FakePostRepository fakeRepository;
    late GetPostById useCase;

    setUp(() {
      fakeRepository = FakePostRepository();
      useCase = GetPostById(fakeRepository);
    });

    test('returns entity from repository with correct id', () async {
      final expected = TestFixtures.postEntity();
      fakeRepository.getPostByIdResult = Right(expected);

      final result = await useCase(1);

      expect(result, Right<Failure, PostEntity>(expected));
      expect(fakeRepository.getPostByIdCallCount, 1);
      expect(fakeRepository.lastGetPostByIdArg, 1);
    });

    test('returns $Failure when repository fails', () async {
      fakeRepository.getPostByIdResult = const Left(TestFixtures.serverFailure);

      final result = await useCase(99);

      expect(
        result,
        const Left<Failure, PostEntity>(TestFixtures.serverFailure),
      );
    });
  });
}
