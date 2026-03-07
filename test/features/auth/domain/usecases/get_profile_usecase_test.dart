import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:somnio/core/error/failures.dart';
import 'package:somnio/core/usecase/usecase.dart';
import 'package:somnio/features/auth/domain/entities/user_entity.dart';
import 'package:somnio/features/auth/domain/usecases/get_profile_usecase.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('$GetProfileUseCase', () {
    late FakeAuthRepository fakeRepository;
    late GetProfileUseCase useCase;

    setUp(() {
      fakeRepository = FakeAuthRepository();
      useCase = GetProfileUseCase(fakeRepository);
    });

    test('returns $UserEntity from repository on success', () async {
      final expected = TestFixtures.userEntity();
      fakeRepository.getProfileResult = Right(expected);

      final result = await useCase(const NoParams());

      expect(result, Right<Failure, UserEntity>(expected));
      expect(fakeRepository.getProfileCallCount, 1);
    });

    test('returns $Failure when repository fails', () async {
      fakeRepository.getProfileResult = const Left(TestFixtures.serverFailure);

      final result = await useCase(const NoParams());

      expect(
        result,
        const Left<Failure, UserEntity>(TestFixtures.serverFailure),
      );
    });
  });
}
