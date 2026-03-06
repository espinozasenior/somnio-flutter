import 'package:auth_client/auth_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:somnio/core/error/exceptions.dart';
import 'package:somnio/features/auth/data/datasources/remote/auth_remote_data_source.dart';

class _MockAuthApiClient extends Mock implements AuthApiClient {}

void main() {
  late _MockAuthApiClient mockClient;
  late AuthRemoteDataSource dataSource;

  const tAuthResponse = AuthResponse(
    accessToken: 'access',
    refreshToken: 'refresh',
  );
  const tProfile = ProfileResponse(
    id: '1',
    email: 'test@example.com',
    name: 'Test',
  );

  setUp(() {
    mockClient = _MockAuthApiClient();
    dataSource = AuthRemoteDataSource(authApiClient: mockClient);
  });

  setUpAll(() {
    registerFallbackValue(
      const LoginRequest(email: '', password: ''),
    );
    registerFallbackValue(
      const RegisterRequest(email: '', password: '', name: ''),
    );
    registerFallbackValue(
      const SocialLoginRequest(token: '', provider: ''),
    );
    registerFallbackValue(
      const ChangePasswordRequest(
        currentPassword: '',
        newPassword: '',
      ),
    );
  });

  DioException makeDioException({
    DioExceptionType type = DioExceptionType.badResponse,
    int? statusCode,
    Map<String, dynamic>? data,
    Object? error,
  }) {
    return DioException(
      requestOptions: RequestOptions(path: '/test'),
      type: type,
      error: error,
      response: statusCode != null
          ? Response(
              requestOptions: RequestOptions(path: '/test'),
              statusCode: statusCode,
              data: data,
            )
          : null,
    );
  }

  group('login', () {
    test('returns AuthResponse on success', () async {
      when(() => mockClient.login(any()))
          .thenAnswer((_) async => tAuthResponse);

      final result = await dataSource.login(
        email: 'test@example.com',
        password: 'pass',
      );

      expect(result, tAuthResponse);
    });

    test('throws AuthException on 401', () async {
      when(() => mockClient.login(any()))
          .thenThrow(makeDioException(statusCode: 401));

      expect(
        () => dataSource.login(email: 'e', password: 'p'),
        throwsA(isA<AuthException>()),
      );
    });

    test('throws ServerException on 500', () async {
      when(() => mockClient.login(any()))
          .thenThrow(makeDioException(statusCode: 500));

      expect(
        () => dataSource.login(email: 'e', password: 'p'),
        throwsA(isA<ServerException>()),
      );
    });

    test('re-throws NetworkException from DioException.error', () async {
      when(() => mockClient.login(any())).thenThrow(
        makeDioException(error: const NetworkException()),
      );

      expect(
        () => dataSource.login(email: 'e', password: 'p'),
        throwsA(isA<NetworkException>()),
      );
    });
  });

  group('register', () {
    test('returns AuthResponse on success', () async {
      when(() => mockClient.register(any()))
          .thenAnswer((_) async => tAuthResponse);

      final result = await dataSource.register(
        email: 'e',
        password: 'p',
        name: 'n',
      );

      expect(result, tAuthResponse);
    });

    test('throws on DioException', () async {
      when(() => mockClient.register(any()))
          .thenThrow(makeDioException(statusCode: 400));

      expect(
        () => dataSource.register(email: 'e', password: 'p', name: 'n'),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('logout', () {
    test('completes on success', () async {
      when(() => mockClient.logout()).thenAnswer((_) async {});

      await expectLater(dataSource.logout(), completes);
    });

    test('throws on DioException', () async {
      when(() => mockClient.logout())
          .thenThrow(makeDioException(statusCode: 500));

      expect(
        () => dataSource.logout(),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('googleSignIn', () {
    test('returns AuthResponse on success', () async {
      when(() => mockClient.googleSignIn(any()))
          .thenAnswer((_) async => tAuthResponse);

      final result = await dataSource.googleSignIn(token: 'token');

      expect(result, tAuthResponse);
    });
  });

  group('appleSignIn', () {
    test('returns AuthResponse on success', () async {
      when(() => mockClient.appleSignIn(any()))
          .thenAnswer((_) async => tAuthResponse);

      final result = await dataSource.appleSignIn(token: 'token');

      expect(result, tAuthResponse);
    });
  });

  group('changePassword', () {
    test('completes on success', () async {
      when(() => mockClient.changePassword(any()))
          .thenAnswer((_) async {});

      await expectLater(
        dataSource.changePassword(
          currentPassword: 'old',
          newPassword: 'new',
        ),
        completes,
      );
    });
  });

  group('deleteAccount', () {
    test('completes on success', () async {
      when(() => mockClient.deleteAccount(any()))
          .thenAnswer((_) async {});

      await expectLater(
        dataSource.deleteAccount('1'),
        completes,
      );
    });
  });

  group('getProfile', () {
    test('returns ProfileResponse on success', () async {
      when(() => mockClient.getProfile())
          .thenAnswer((_) async => tProfile);

      final result = await dataSource.getProfile();

      expect(result, tProfile);
    });

    test('throws AuthException on 403', () async {
      when(() => mockClient.getProfile())
          .thenThrow(makeDioException(statusCode: 403));

      expect(
        () => dataSource.getProfile(),
        throwsA(isA<AuthException>()),
      );
    });
  });

  group('_mapDioException', () {
    test('re-throws ServerException from DioException.error', () async {
      when(() => mockClient.login(any())).thenThrow(
        makeDioException(
          error: const ServerException(
            message: 'intercepted',
            statusCode: 502,
          ),
        ),
      );

      expect(
        () => dataSource.login(email: 'e', password: 'p'),
        throwsA(
          isA<ServerException>().having((e) => e.message, 'msg', 'intercepted'),
        ),
      );
    });

    test('throws AuthException on 403 with message', () async {
      when(() => mockClient.login(any())).thenThrow(
        makeDioException(
          statusCode: 403,
          data: <String, dynamic>{'message': 'Forbidden'},
        ),
      );

      try {
        await dataSource.login(email: 'e', password: 'p');
        fail('should throw');
      } on AuthException catch (e) {
        expect(e.message, 'Forbidden');
        expect(e.statusCode, 403);
      }
    });

    test('throws AuthException with default message on 401 no data',
        () async {
      when(() => mockClient.login(any())).thenThrow(
        makeDioException(statusCode: 401),
      );

      try {
        await dataSource.login(email: 'e', password: 'p');
        fail('should throw');
      } on AuthException catch (e) {
        expect(e.message, 'Unauthorized');
      }
    });

    test('throws ServerException with default message on no data', () async {
      when(() => mockClient.login(any())).thenThrow(
        makeDioException(statusCode: 500),
      );

      try {
        await dataSource.login(email: 'e', password: 'p');
        fail('should throw');
      } on ServerException catch (e) {
        expect(e.message, 'Server error');
        expect(e.statusCode, 500);
      }
    });

    test('throws ServerException with statusCode 500 on no response',
        () async {
      when(() => mockClient.login(any())).thenThrow(
        makeDioException(),
      );

      expect(
        () => dataSource.login(email: 'e', password: 'p'),
        throwsA(
          isA<ServerException>()
              .having((e) => e.statusCode, 'statusCode', 500),
        ),
      );
    });
  });

  group('_extractMessage', () {
    test('extracts message from response data', () async {
      when(() => mockClient.login(any())).thenThrow(
        makeDioException(
          statusCode: 500,
          data: <String, dynamic>{'message': 'Custom error'},
        ),
      );

      try {
        await dataSource.login(email: 'e', password: 'p');
        fail('should throw');
      } on ServerException catch (e) {
        expect(e.message, 'Custom error');
      }
    });

    test('extracts error field as fallback', () async {
      when(() => mockClient.login(any())).thenThrow(
        makeDioException(
          statusCode: 500,
          data: <String, dynamic>{'error': 'Error fallback'},
        ),
      );

      try {
        await dataSource.login(email: 'e', password: 'p');
        fail('should throw');
      } on ServerException catch (e) {
        expect(e.message, 'Error fallback');
      }
    });

    test('returns null when response data is not a map', () async {
      when(() => mockClient.login(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response<dynamic>(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 500,
            data: 'not a map',
          ),
        ),
      );

      try {
        await dataSource.login(email: 'e', password: 'p');
        fail('should throw');
      } on ServerException catch (e) {
        expect(e.message, 'Server error');
      }
    });
  });

  group('error paths for other methods', () {
    test('googleSignIn throws on DioException', () async {
      when(() => mockClient.googleSignIn(any()))
          .thenThrow(makeDioException(statusCode: 500));

      expect(
        () => dataSource.googleSignIn(token: 'token'),
        throwsA(isA<ServerException>()),
      );
    });

    test('appleSignIn throws on DioException', () async {
      when(() => mockClient.appleSignIn(any()))
          .thenThrow(makeDioException(statusCode: 500));

      expect(
        () => dataSource.appleSignIn(token: 'token'),
        throwsA(isA<ServerException>()),
      );
    });

    test('changePassword throws on DioException', () async {
      when(() => mockClient.changePassword(any()))
          .thenThrow(makeDioException(statusCode: 500));

      expect(
        () => dataSource.changePassword(
          currentPassword: 'old',
          newPassword: 'new',
        ),
        throwsA(isA<ServerException>()),
      );
    });

    test('deleteAccount throws on DioException', () async {
      when(() => mockClient.deleteAccount(any()))
          .thenThrow(makeDioException(statusCode: 500));

      expect(
        () => dataSource.deleteAccount('1'),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
