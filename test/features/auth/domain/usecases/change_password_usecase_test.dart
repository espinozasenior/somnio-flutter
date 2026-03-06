import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:somnio/core/error/failures.dart';
import 'package:somnio/features/auth/domain/usecases/change_password_usecase.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('$ChangePasswordUseCase', () {
    late FakeAuthRepository fakeRepository;
    late ChangePasswordUseCase useCase;

    setUp(() {
      fakeRepository = FakeAuthRepository();
      useCase = ChangePasswordUseCase(fakeRepository);
    });

    const params = ChangePasswordParams(
      currentPassword: 'old_pass',
      newPassword: 'new_pass123',
    );

    test('returns unit from repository on success', () async {
      fakeRepository.changePasswordResult = const Right(unit);

      final result = await useCase(params);

      expect(result, const Right<Failure, Unit>(unit));
      expect(fakeRepository.changePasswordCallCount, 1);
    });

    test('returns $Failure when repository fails', () async {
      fakeRepository.changePasswordResult =
          const Left(TestFixtures.authFailure);

      final result = await useCase(params);

      expect(
        result,
        const Left<Failure, Unit>(TestFixtures.authFailure),
      );
    });

    test('$ChangePasswordParams supports value equality', () {
      const params1 = ChangePasswordParams(
        currentPassword: 'old',
        newPassword: 'new',
      );
      const params2 = ChangePasswordParams(
        currentPassword: 'old',
        newPassword: 'new',
      );
      const params3 = ChangePasswordParams(
        currentPassword: 'old',
        newPassword: 'different',
      );

      expect(params1, equals(params2));
      expect(params1, isNot(equals(params3)));
    });
  });
}
