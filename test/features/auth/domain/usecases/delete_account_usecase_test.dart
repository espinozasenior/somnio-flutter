import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:somnio/core/error/failures.dart';
import 'package:somnio/core/usecase/usecase.dart';
import 'package:somnio/features/auth/domain/usecases/delete_account_usecase.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('$DeleteAccountUseCase', () {
    late FakeAuthRepository fakeRepository;
    late DeleteAccountUseCase useCase;

    setUp(() {
      fakeRepository = FakeAuthRepository();
      useCase = DeleteAccountUseCase(fakeRepository);
    });

    test('returns unit from repository on success', () async {
      fakeRepository.deleteAccountResult = const Right(unit);

      final result = await useCase(const NoParams());

      expect(result, const Right<Failure, Unit>(unit));
      expect(fakeRepository.deleteAccountCallCount, 1);
    });

    test('returns $Failure when repository fails', () async {
      fakeRepository.deleteAccountResult =
          const Left(TestFixtures.serverFailure);

      final result = await useCase(const NoParams());

      expect(
        result,
        const Left<Failure, Unit>(TestFixtures.serverFailure),
      );
    });
  });
}
