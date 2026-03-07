import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:somnio/core/error/failures.dart';
import 'package:somnio/features/auth/domain/entities/auth_tokens.dart';
import 'package:somnio/features/auth/domain/usecases/google_sign_in_usecase.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('$GoogleSignInUseCase', () {
    late FakeAuthRepository fakeRepository;
    late GoogleSignInUseCase useCase;

    setUp(() {
      fakeRepository = FakeAuthRepository();
      useCase = GoogleSignInUseCase(fakeRepository);
    });

    const params = SocialSignInParams(token: 'google_token');

    test('returns $AuthTokens from repository on success', () async {
      fakeRepository.googleSignInResult = const Right(TestFixtures.authTokens);

      final result = await useCase(params);

      expect(
        result,
        const Right<Failure, AuthTokens>(TestFixtures.authTokens),
      );
      expect(fakeRepository.googleSignInCallCount, 1);
    });

    test('returns $Failure when repository fails', () async {
      fakeRepository.googleSignInResult = const Left(TestFixtures.authFailure);

      final result = await useCase(params);

      expect(
        result,
        const Left<Failure, AuthTokens>(TestFixtures.authFailure),
      );
    });

    test('$SocialSignInParams supports value equality', () {
      const params1 = SocialSignInParams(token: 'token_a');
      const params2 = SocialSignInParams(token: 'token_a');
      const params3 = SocialSignInParams(token: 'token_b');

      expect(params1, equals(params2));
      expect(params1, isNot(equals(params3)));
    });

    test('$SocialSignInParams props contains token', () {
      // Non-const to force runtime constructor execution.
      // ignore: prefer_const_constructors
      final params = SocialSignInParams(token: 'abc');
      expect(params.props, ['abc']);
    });
  });
}
