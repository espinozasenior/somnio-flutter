import 'package:flutter_test/flutter_test.dart';
import 'package:somnio/core/error/failures.dart';

void main() {
  group('$Failure', () {
    test('$ServerFailure stores message and statusCode', () {
      const failure = ServerFailure(message: 'Not Found', statusCode: 404);
      expect(failure.message, 'Not Found');
      expect(failure.statusCode, 404);
    });

    test('$CacheFailure stores message', () {
      const failure = CacheFailure(message: 'No data');
      expect(failure.message, 'No data');
      expect(failure.statusCode, isNull);
    });

    test('$NetworkFailure stores message', () {
      const failure = NetworkFailure(message: 'No internet');
      expect(failure.message, 'No internet');
    });

    test('$ValidationFailure stores message', () {
      const failure = ValidationFailure(message: 'Invalid input');
      expect(failure.message, 'Invalid input');
    });

    test('two identical ${ServerFailure}s are equal', () {
      const a = ServerFailure(message: 'err', statusCode: 500);
      const b = ServerFailure(message: 'err', statusCode: 500);
      expect(a, equals(b));
    });

    test('different ${Failure}s are not equal', () {
      const a = ServerFailure(message: 'err', statusCode: 500);
      const b = CacheFailure(message: 'err');
      expect(a, isNot(equals(b)));
    });
  });
}
