import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:somnio/core/error/failures.dart';
import 'package:somnio/features/auth/domain/entities/auth_tokens.dart';
import 'package:somnio/features/auth/domain/usecases/login_usecase.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('$LoginUseCase', () {
    late FakeAuthRepository fakeRepository;
    late LoginUseCase useCase;

    setUp(() {
      fakeRepository = FakeAuthRepository();
      useCase = LoginUseCase(fakeRepository);
    });

    const params = LoginParams(
      email: 'test@example.com',
      password: 'password123',
    );

    test('returns $AuthTokens from repository on success', () async {
      fakeRepository.loginResult = const Right(TestFixtures.authTokens);

      final result = await useCase(params);

      expect(
        result,
        const Right<Failure, AuthTokens>(TestFixtures.authTokens),
      );
      expect(fakeRepository.loginCallCount, 1);
      expect(fakeRepository.lastEmail, 'test@example.com');
      expect(fakeRepository.lastPassword, 'password123');
    });

    test('returns $Failure when repository fails', () async {
      fakeRepository.loginResult = const Left(TestFixtures.authFailure);

      final result = await useCase(params);

      expect(
        result,
        const Left<Failure, AuthTokens>(TestFixtures.authFailure),
      );
    });

    test('$LoginParams supports value equality', () {
      const params1 = LoginParams(
        email: 'test@example.com',
        password: 'password123',
      );
      const params2 = LoginParams(
        email: 'test@example.com',
        password: 'password123',
      );
      const params3 = LoginParams(
        email: 'other@example.com',
        password: 'password123',
      );

      expect(params1, equals(params2));
      expect(params1, isNot(equals(params3)));
    });
  });
}
