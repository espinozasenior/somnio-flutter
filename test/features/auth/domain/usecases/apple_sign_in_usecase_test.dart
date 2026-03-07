import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:somnio/core/error/failures.dart';
import 'package:somnio/features/auth/domain/entities/auth_tokens.dart';
import 'package:somnio/features/auth/domain/usecases/apple_sign_in_usecase.dart';
import 'package:somnio/features/auth/domain/usecases/google_sign_in_usecase.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('$AppleSignInUseCase', () {
    late FakeAuthRepository fakeRepository;
    late AppleSignInUseCase useCase;

    setUp(() {
      fakeRepository = FakeAuthRepository();
      useCase = AppleSignInUseCase(fakeRepository);
    });

    const params = SocialSignInParams(token: 'apple_token');

    test('returns $AuthTokens from repository on success', () async {
      fakeRepository.appleSignInResult = const Right(TestFixtures.authTokens);

      final result = await useCase(params);

      expect(
        result,
        const Right<Failure, AuthTokens>(TestFixtures.authTokens),
      );
      expect(fakeRepository.appleSignInCallCount, 1);
    });

    test('returns $Failure when repository fails', () async {
      fakeRepository.appleSignInResult = const Left(TestFixtures.authFailure);

      final result = await useCase(params);

      expect(
        result,
        const Left<Failure, AuthTokens>(TestFixtures.authFailure),
      );
    });
  });
}
