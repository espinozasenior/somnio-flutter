import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:somnio/core/error/exceptions.dart';

class ApiErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    developer.log(
      'API Error: ${err.message}',
      name: 'somnio.network',
      error: err,
    );

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: const NetworkException(),
            type: err.type,
          ),
        );
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode ?? 500;
        final message = _extractMessage(err.response);
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: ServerException(
              message: message,
              statusCode: statusCode,
            ),
            type: err.type,
          ),
        );
      case DioExceptionType.cancel:
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        handler.next(err);
    }
  }

  String _extractMessage(Response<dynamic>? response) {
    if (response?.data case final Map<String, dynamic> data) {
      return data['message'] as String? ??
          data['error'] as String? ??
          'Server error';
    }
    return 'Server error';
  }
}
