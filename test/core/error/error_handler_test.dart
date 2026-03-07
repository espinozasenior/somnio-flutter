import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:somnio/core/error/error_handler.dart';
import 'package:somnio/core/error/exceptions.dart';
import 'package:somnio/core/error/failures.dart';

void main() {
  group('safeApiCall', () {
    test('returns Right(data) on success', () async {
      final result = await safeApiCall(() async => 42);
      expect(result, const Right<Failure, int>(42));
    });

    test('returns Left($ServerFailure) on $ServerException', () async {
      final result = await safeApiCall<int>(
        () async => throw const ServerException(
          message: 'Not Found',
          statusCode: 404,
        ),
      );
      expect(
        result,
        const Left<Failure, int>(
          ServerFailure(message: 'Not Found', statusCode: 404),
        ),
      );
    });

    test('returns Left($NetworkFailure) on $NetworkException', () async {
      final result = await safeApiCall<int>(
        () async => throw const NetworkException(),
      );
      expect(
        result,
        isA<Left<Failure, int>>().having(
          (l) => l.value,
          'failure',
          isA<NetworkFailure>(),
        ),
      );
    });

    test('returns Left($CacheFailure) on $CacheException', () async {
      final result = await safeApiCall<int>(
        () async => throw const CacheException(message: 'No cached data'),
      );
      expect(
        result,
        isA<Left<Failure, int>>().having(
          (l) => l.value,
          'failure',
          isA<CacheFailure>(),
        ),
      );
    });

    test('returns Left($AuthFailure) on $AuthException', () async {
      final result = await safeApiCall<int>(
        () async => throw const AuthException(
          message: 'Unauthorized',
          statusCode: 401,
        ),
      );
      expect(
        result,
        const Left<Failure, int>(
          AuthFailure(message: 'Unauthorized', statusCode: 401),
        ),
      );
    });

    test('returns Left($ServerFailure) on generic Exception', () async {
      final result = await safeApiCall<int>(
        () async => throw Exception('something went wrong'),
      );
      expect(
        result,
        isA<Left<Failure, int>>().having(
          (l) => l.value,
          'failure',
          isA<ServerFailure>(),
        ),
      );
    });
  });

  group('safeCacheCall', () {
    test('returns Right(data) on success', () async {
      final result = await safeCacheCall(() async => 'cached');
      expect(result, const Right<Failure, String>('cached'));
    });

    test('returns Left($CacheFailure) on $CacheException', () async {
      final result = await safeCacheCall<String>(
        () async => throw const CacheException(message: 'empty'),
      );
      expect(
        result,
        isA<Left<Failure, String>>().having(
          (l) => l.value,
          'failure',
          isA<CacheFailure>(),
        ),
      );
    });

    test('returns Left($CacheFailure) on generic Exception', () async {
      final result = await safeCacheCall<String>(
        () async => throw Exception('unexpected'),
      );
      expect(
        result,
        isA<Left<Failure, String>>().having(
          (l) => l.value,
          'failure',
          isA<CacheFailure>(),
        ),
      );
    });
  });
}
