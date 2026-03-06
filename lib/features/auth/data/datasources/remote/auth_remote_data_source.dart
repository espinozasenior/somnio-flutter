import 'package:auth_client/auth_client.dart';
import 'package:dio/dio.dart';
import 'package:somnio/core/error/exceptions.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource({required AuthApiClient authApiClient})
      : _client = authApiClient;

  final AuthApiClient _client;

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      return await _client.login(
        LoginRequest(email: email, password: password),
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<AuthResponse> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      return await _client.register(
        RegisterRequest(email: email, password: password, name: name),
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<void> logout() async {
    try {
      await _client.logout();
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<AuthResponse> googleSignIn({required String token}) async {
    try {
      return await _client.googleSignIn(
        SocialLoginRequest(token: token, provider: 'google'),
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<AuthResponse> appleSignIn({required String token}) async {
    try {
      return await _client.appleSignIn(
        SocialLoginRequest(token: token, provider: 'apple'),
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _client.changePassword(
        ChangePasswordRequest(
          currentPassword: currentPassword,
          newPassword: newPassword,
        ),
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<void> deleteAccount(String userId) async {
    try {
      await _client.deleteAccount(userId);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<ProfileResponse> getProfile() async {
    try {
      return await _client.getProfile();
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Exception _mapDioException(DioException e) {
    if (e.error is ServerException) return e.error! as ServerException;
    if (e.error is NetworkException) return e.error! as NetworkException;

    final statusCode = e.response?.statusCode;
    if (statusCode == 401 || statusCode == 403) {
      return AuthException(
        message: _extractMessage(e.response) ?? 'Unauthorized',
        statusCode: statusCode,
      );
    }

    return ServerException(
      message: _extractMessage(e.response) ?? 'Server error',
      statusCode: statusCode ?? 500,
    );
  }

  String? _extractMessage(Response<dynamic>? response) {
    if (response?.data case final Map<String, dynamic> data) {
      return data['message'] as String? ?? data['error'] as String?;
    }
    return null;
  }
}
