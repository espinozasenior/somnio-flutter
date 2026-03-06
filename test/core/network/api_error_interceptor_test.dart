import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:somnio/core/error/exceptions.dart';
import 'package:somnio/core/network/api_error_interceptor.dart';

void main() {
  late ApiErrorInterceptor interceptor;

  setUp(() {
    interceptor = ApiErrorInterceptor();
  });

  RequestOptions makeOptions() => RequestOptions(path: '/test');

  group('$ApiErrorInterceptor', () {
    test('rejects with NetworkException on connection timeout', () {
      DioException? rejected;
      interceptor.onError(
        DioException(
          requestOptions: makeOptions(),
          type: DioExceptionType.connectionTimeout,
        ),
        _CapturingHandler(onReject: (e) => rejected = e),
      );
      expect(rejected?.error, isA<NetworkException>());
    });

    test('rejects with NetworkException on send timeout', () {
      DioException? rejected;
      interceptor.onError(
        DioException(
          requestOptions: makeOptions(),
          type: DioExceptionType.sendTimeout,
        ),
        _CapturingHandler(onReject: (e) => rejected = e),
      );
      expect(rejected?.error, isA<NetworkException>());
    });

    test('rejects with NetworkException on receive timeout', () {
      DioException? rejected;
      interceptor.onError(
        DioException(
          requestOptions: makeOptions(),
          type: DioExceptionType.receiveTimeout,
        ),
        _CapturingHandler(onReject: (e) => rejected = e),
      );
      expect(rejected?.error, isA<NetworkException>());
    });

    test('rejects with NetworkException on connection error', () {
      DioException? rejected;
      interceptor.onError(
        DioException(
          requestOptions: makeOptions(),
          type: DioExceptionType.connectionError,
        ),
        _CapturingHandler(onReject: (e) => rejected = e),
      );
      expect(rejected?.error, isA<NetworkException>());
    });

    test('rejects with ServerException on bad response', () {
      DioException? rejected;
      final opts = makeOptions();
      interceptor.onError(
        DioException(
          requestOptions: opts,
          type: DioExceptionType.badResponse,
          response: Response<dynamic>(
            requestOptions: opts,
            statusCode: 404,
            data: <String, dynamic>{'message': 'Not found'},
          ),
        ),
        _CapturingHandler(onReject: (e) => rejected = e),
      );
      final error = rejected!.error! as ServerException;
      expect(error.statusCode, 404);
      expect(error.message, 'Not found');
    });

    test('uses error field from response data as fallback', () {
      DioException? rejected;
      final opts = makeOptions();
      interceptor.onError(
        DioException(
          requestOptions: opts,
          type: DioExceptionType.badResponse,
          response: Response<dynamic>(
            requestOptions: opts,
            statusCode: 500,
            data: <String, dynamic>{'error': 'Internal'},
          ),
        ),
        _CapturingHandler(onReject: (e) => rejected = e),
      );
      final error = rejected!.error! as ServerException;
      expect(error.message, 'Internal');
    });

    test('defaults to Server error when no message in response', () {
      DioException? rejected;
      final opts = makeOptions();
      interceptor.onError(
        DioException(
          requestOptions: opts,
          type: DioExceptionType.badResponse,
          response: Response<dynamic>(
            requestOptions: opts,
            statusCode: 500,
          ),
        ),
        _CapturingHandler(onReject: (e) => rejected = e),
      );
      final error = rejected!.error! as ServerException;
      expect(error.message, 'Server error');
      expect(error.statusCode, 500);
    });

    test('passes through cancel errors', () {
      DioException? passed;
      interceptor.onError(
        DioException(
          requestOptions: makeOptions(),
          type: DioExceptionType.cancel,
        ),
        _CapturingHandler(onNext: (e) => passed = e),
      );
      expect(passed, isNotNull);
    });

    test('passes through unknown errors', () {
      DioException? passed;
      interceptor.onError(
        DioException(
          requestOptions: makeOptions(),
          type: DioExceptionType.unknown,
        ),
        _CapturingHandler(onNext: (e) => passed = e),
      );
      expect(passed, isNotNull);
    });

    test('passes through bad certificate errors', () {
      DioException? passed;
      interceptor.onError(
        DioException(
          requestOptions: makeOptions(),
          type: DioExceptionType.badCertificate,
        ),
        _CapturingHandler(onNext: (e) => passed = e),
      );
      expect(passed, isNotNull);
    });
  });
}

class _CapturingHandler extends ErrorInterceptorHandler {
  _CapturingHandler({this.onReject, this.onNext});

  final void Function(DioException)? onReject;
  final void Function(DioException)? onNext;

  @override
  void next(DioException err) => onNext?.call(err);

  @override
  void reject(DioException err) => onReject?.call(err);

  @override
  void resolve(Response<dynamic> response) {}
}
