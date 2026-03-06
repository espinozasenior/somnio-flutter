import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:somnio/core/error/failures.dart';
import 'package:somnio/core/usecase/usecase.dart';
import 'package:somnio/features/auth/domain/usecases/logout_usecase.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('$LogoutUseCase', () {
    late FakeAuthRepository fakeRepository;
    late LogoutUseCase useCase;

    setUp(() {
      fakeRepository = FakeAuthRepository();
      useCase = LogoutUseCase(fakeRepository);
    });

    test('returns unit from repository on success', () async {
      fakeRepository.logoutResult = const Right(unit);

      final result = await useCase(const NoParams());

      expect(result, const Right<Failure, Unit>(unit));
      expect(fakeRepository.logoutCallCount, 1);
    });

    test('returns $Failure when repository fails', () async {
      fakeRepository.logoutResult = const Left(TestFixtures.serverFailure);

      final result = await useCase(const NoParams());

      expect(
        result,
        const Left<Failure, Unit>(TestFixtures.serverFailure),
      );
    });
  });
}
