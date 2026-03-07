import 'package:auth_client/auth_client.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:somnio/core/error/exceptions.dart';
import 'package:somnio/core/error/failures.dart';
import 'package:somnio/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:somnio/features/auth/domain/entities/auth_tokens.dart';
import 'package:somnio/features/auth/domain/entities/user_entity.dart';

import '../../../../helpers/mock_factories.dart';

void main() {
  late MockAuthRemoteDataSource mockRemote;
  late MockAuthLocalDataSource mockLocal;
  late AuthRepositoryImpl repository;

  const tAuthResponse = AuthResponse(
    accessToken: 'access',
    refreshToken: 'refresh',
  );
  const tAuthTokens = AuthTokens(
    accessToken: 'access',
    refreshToken: 'refresh',
  );
  const tProfile = ProfileResponse(
    id: '1',
    email: 'test@example.com',
    name: 'Test',
  );

  setUp(() {
    mockRemote = MockAuthRemoteDataSource();
    mockLocal = MockAuthLocalDataSource();
    repository = AuthRepositoryImpl(
      remoteDataSource: mockRemote,
      localDataSource: mockLocal,
    );
  });

  group('login', () {
    test('returns $AuthTokens on success and saves tokens', () async {
      when(
        () => mockRemote.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => tAuthResponse);
      when(
        () => mockLocal.saveTokens(
          accessToken: any(named: 'accessToken'),
          refreshToken: any(named: 'refreshToken'),
        ),
      ).thenAnswer((_) async {});

      final result = await repository.login(
        email: 'test@example.com',
        password: 'pass',
      );

      expect(result, const Right<Failure, AuthTokens>(tAuthTokens));
      verify(
        () => mockLocal.saveTokens(
          accessToken: 'access',
          refreshToken: 'refresh',
        ),
      ).called(1);
    });

    test('returns $ServerFailure on $ServerException', () async {
      when(
        () => mockRemote.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(const ServerException(message: 'Bad', statusCode: 400));
      when(
        () => mockLocal.saveTokens(
          accessToken: any(named: 'accessToken'),
          refreshToken: any(named: 'refreshToken'),
        ),
      ).thenAnswer((_) async {});

      final result = await repository.login(
        email: 'test@example.com',
        password: 'pass',
      );

      expect(result.isLeft(), true);
      result.fold(
        (f) => expect(f, isA<ServerFailure>()),
        (_) => fail('should be left'),
      );
    });

    test('returns $AuthFailure on $AuthException', () async {
      when(
        () => mockRemote.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(
        const AuthException(message: 'Unauthorized', statusCode: 401),
      );

      final result = await repository.login(
        email: 'test@example.com',
        password: 'pass',
      );

      expect(result.isLeft(), true);
      result.fold(
        (f) => expect(f, isA<AuthFailure>()),
        (_) => fail('should be left'),
      );
    });
  });

  group('register', () {
    test('returns $AuthTokens on success and saves tokens', () async {
      when(
        () => mockRemote.register(
          email: any(named: 'email'),
          password: any(named: 'password'),
          name: any(named: 'name'),
        ),
      ).thenAnswer((_) async => tAuthResponse);
      when(
        () => mockLocal.saveTokens(
          accessToken: any(named: 'accessToken'),
          refreshToken: any(named: 'refreshToken'),
        ),
      ).thenAnswer((_) async {});

      final result = await repository.register(
        email: 'test@example.com',
        password: 'pass',
        name: 'Test',
      );

      expect(result, const Right<Failure, AuthTokens>(tAuthTokens));
      verify(
        () => mockLocal.saveTokens(
          accessToken: 'access',
          refreshToken: 'refresh',
        ),
      ).called(1);
    });
  });

  group('logout', () {
    test('returns unit on success and clears tokens', () async {
      when(() => mockRemote.logout()).thenAnswer((_) async {});
      when(() => mockLocal.clearTokens()).thenAnswer((_) async {});

      final result = await repository.logout();

      expect(result, const Right<Failure, Unit>(unit));
      verify(() => mockLocal.clearTokens()).called(1);
    });

    test('returns $ServerFailure on exception', () async {
      when(
        () => mockRemote.logout(),
      ).thenThrow(const ServerException(message: 'err', statusCode: 500));

      final result = await repository.logout();

      expect(result.isLeft(), true);
    });
  });

  group('googleSignIn', () {
    test('returns $AuthTokens on success', () async {
      when(
        () => mockRemote.googleSignIn(token: any(named: 'token')),
      ).thenAnswer((_) async => tAuthResponse);
      when(
        () => mockLocal.saveTokens(
          accessToken: any(named: 'accessToken'),
          refreshToken: any(named: 'refreshToken'),
        ),
      ).thenAnswer((_) async {});

      final result = await repository.googleSignIn(token: 'gtoken');

      expect(result, const Right<Failure, AuthTokens>(tAuthTokens));
    });
  });

  group('appleSignIn', () {
    test('returns $AuthTokens on success', () async {
      when(
        () => mockRemote.appleSignIn(token: any(named: 'token')),
      ).thenAnswer((_) async => tAuthResponse);
      when(
        () => mockLocal.saveTokens(
          accessToken: any(named: 'accessToken'),
          refreshToken: any(named: 'refreshToken'),
        ),
      ).thenAnswer((_) async {});

      final result = await repository.appleSignIn(token: 'atoken');

      expect(result, const Right<Failure, AuthTokens>(tAuthTokens));
    });
  });

  group('changePassword', () {
    test('returns unit on success', () async {
      when(
        () => mockRemote.changePassword(
          currentPassword: any(named: 'currentPassword'),
          newPassword: any(named: 'newPassword'),
        ),
      ).thenAnswer((_) async {});

      final result = await repository.changePassword(
        currentPassword: 'old',
        newPassword: 'new123',
      );

      expect(result, const Right<Failure, Unit>(unit));
    });
  });

  group('deleteAccount', () {
    test('returns unit on success and clears tokens', () async {
      when(() => mockRemote.getProfile()).thenAnswer((_) async => tProfile);
      when(() => mockRemote.deleteAccount(any())).thenAnswer((_) async {});
      when(() => mockLocal.clearTokens()).thenAnswer((_) async {});

      final result = await repository.deleteAccount();

      expect(result, const Right<Failure, Unit>(unit));
      verify(() => mockRemote.deleteAccount('1')).called(1);
      verify(() => mockLocal.clearTokens()).called(1);
    });
  });

  group('getProfile', () {
    test('returns $UserEntity on success', () async {
      when(() => mockRemote.getProfile()).thenAnswer((_) async => tProfile);

      final result = await repository.getProfile();

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('should be right'),
        (entity) {
          expect(entity.id, '1');
          expect(entity.email, 'test@example.com');
          expect(entity.name, 'Test');
        },
      );
    });

    test('returns $NetworkFailure on $NetworkException', () async {
      when(() => mockRemote.getProfile()).thenThrow(const NetworkException());

      final result = await repository.getProfile();

      expect(result.isLeft(), true);
      result.fold(
        (f) => expect(f, isA<NetworkFailure>()),
        (_) => fail('should be left'),
      );
    });
  });
}
