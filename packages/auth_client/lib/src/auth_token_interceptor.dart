import 'dart:developer' as developer;

import 'package:auth_client/src/auth_api_client.dart';
import 'package:auth_client/src/models/models.dart';
import 'package:dio/dio.dart';
import 'package:token_provider/token_provider.dart';

class AuthTokenInterceptor extends QueuedInterceptor {
  AuthTokenInterceptor({
    required TokenProvider tokenProvider,
    required Dio dio,
  })  : _tokenProvider = tokenProvider,
        _dio = dio;

  final TokenProvider _tokenProvider;
  final Dio _dio;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenProvider.accessToken;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      handler.next(err);
      return;
    }

    try {
      final storedRefreshToken = await _tokenProvider.refreshToken;
      if (storedRefreshToken == null || storedRefreshToken.isEmpty) {
        handler.next(err);
        return;
      }

      final refreshClient = AuthApiClient(_dio);
      final response = await refreshClient.refreshToken(
        RefreshTokenRequest(refreshToken: storedRefreshToken),
      );

      await _tokenProvider.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );

      final retryOptions = err.requestOptions
        ..headers['Authorization'] = 'Bearer ${response.accessToken}';

      final retryResponse = await _dio.fetch<dynamic>(retryOptions);
      handler.resolve(retryResponse);
    } on DioException catch (e) {
      developer.log(
        'Token refresh failed: ${e.message}',
        name: 'auth.interceptor',
      );
      await _tokenProvider.clearTokens();
      handler.next(err);
    }
  }
}
