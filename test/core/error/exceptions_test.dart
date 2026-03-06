import 'package:flutter_test/flutter_test.dart';
import 'package:somnio/core/error/exceptions.dart';

void main() {
  group('$ServerException', () {
    test('toString returns formatted string', () {
      const exception = ServerException(message: 'Bad', statusCode: 500);
      expect(exception.toString(), 'ServerException(500): Bad');
    });

    test('stores message and statusCode', () {
      const exception = ServerException(message: 'Error', statusCode: 404);
      expect(exception.message, 'Error');
      expect(exception.statusCode, 404);
    });
  });

  group('$CacheException', () {
    test('toString returns formatted string', () {
      const exception = CacheException(message: 'No cache');
      expect(exception.toString(), 'CacheException: No cache');
    });
  });

  group('$NetworkException', () {
    test('toString returns formatted string', () {
      const exception = NetworkException();
      expect(
        exception.toString(),
        'NetworkException: No internet connection',
      );
    });
  });

  group('$AuthException', () {
    test('toString returns formatted string', () {
      const exception = AuthException(
        message: 'Unauthorized',
        statusCode: 401,
      );
      expect(exception.toString(), 'AuthException(401): Unauthorized');
    });

    test('statusCode can be null', () {
      const exception = AuthException(message: 'Error');
      expect(exception.statusCode, isNull);
      expect(exception.toString(), 'AuthException(null): Error');
    });
  });
}
