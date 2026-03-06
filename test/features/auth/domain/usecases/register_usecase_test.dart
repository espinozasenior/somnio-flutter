import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:somnio/core/error/failures.dart';
import 'package:somnio/features/auth/domain/entities/auth_tokens.dart';
import 'package:somnio/features/auth/domain/usecases/register_usecase.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('$RegisterUseCase', () {
    late FakeAuthRepository fakeRepository;
    late RegisterUseCase useCase;

    setUp(() {
      fakeRepository = FakeAuthRepository();
      useCase = RegisterUseCase(fakeRepository);
    });

    const params = RegisterParams(
      email: 'test@example.com',
      password: 'password123',
      name: 'Test User',
    );

    test('returns $AuthTokens from repository on success', () async {
      fakeRepository.registerResult = const Right(TestFixtures.authTokens);

      final result = await useCase(params);

      expect(
        result,
        const Right<Failure, AuthTokens>(TestFixtures.authTokens),
      );
      expect(fakeRepository.registerCallCount, 1);
    });

    test('returns $Failure when repository fails', () async {
      fakeRepository.registerResult = const Left(TestFixtures.authFailure);

      final result = await useCase(params);

      expect(
        result,
        const Left<Failure, AuthTokens>(TestFixtures.authFailure),
      );
    });

    test('$RegisterParams supports value equality', () {
      const params1 = RegisterParams(
        email: 'test@example.com',
        password: 'password123',
        name: 'Test User',
      );
      const params2 = RegisterParams(
        email: 'test@example.com',
        password: 'password123',
        name: 'Test User',
      );
      const params3 = RegisterParams(
        email: 'other@example.com',
        password: 'password123',
        name: 'Test User',
      );

      expect(params1, equals(params2));
      expect(params1, isNot(equals(params3)));
    });
  });
}
