import 'dart:async';
import 'dart:developer' as developer;

import 'package:auth_client/auth_client.dart';
import 'package:dio/dio.dart';
import 'package:token_provider/token_provider.dart';
import 'package:user_repository/src/models/models.dart';

class UserRepository {
  UserRepository({
    required AuthApiClient authApiClient,
    required TokenProvider tokenProvider,
  })  : _authApiClient = authApiClient,
        _tokenProvider = tokenProvider;

  final AuthApiClient _authApiClient;
  final TokenProvider _tokenProvider;

  final _statusController = StreamController<AuthStatus>.broadcast();
  final _userController = StreamController<User>.broadcast();

  User _currentUser = User.empty;

  Stream<AuthStatus> get status => _statusController.stream;

  Stream<User> get user => _userController.stream;

  User get currentUser => _currentUser;

  Future<void> checkAuthStatus() async {
    final hasTokens = await _tokenProvider.hasTokens;
    if (hasTokens) {
      try {
        await fetchProfile();
        _statusController.add(AuthStatus.authenticated);
      } on Exception catch (_) {
        await _tokenProvider.clearTokens();
        _currentUser = User.empty;
        _userController.add(User.empty);
        _statusController.add(AuthStatus.unauthenticated);
      }
    } else {
      _statusController.add(AuthStatus.unauthenticated);
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    final response = await _authApiClient.login(
      LoginRequest(email: email, password: password),
    );
    await _saveAuthResponse(response);
  }

  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    final response = await _authApiClient.register(
      RegisterRequest(email: email, password: password, name: name),
    );
    await _saveAuthResponse(response);
  }

  Future<void> googleSignIn({required String token}) async {
    final response = await _authApiClient.googleSignIn(
      SocialLoginRequest(token: token, provider: 'google'),
    );
    await _saveAuthResponse(response);
  }

  Future<void> appleSignIn({required String token}) async {
    final response = await _authApiClient.appleSignIn(
      SocialLoginRequest(token: token, provider: 'apple'),
    );
    await _saveAuthResponse(response);
  }

  Future<void> logout() async {
    try {
      await _authApiClient.logout();
    } on DioException catch (e) {
      developer.log('Logout API call failed: $e', name: 'user_repository');
    } finally {
      await _tokenProvider.clearTokens();
      _currentUser = User.empty;
      _userController.add(User.empty);
      _statusController.add(AuthStatus.unauthenticated);
    }
  }

  Future<User> fetchProfile() async {
    final profile = await _authApiClient.getProfile();
    _currentUser = User(
      id: profile.id,
      email: profile.email,
      name: profile.name,
      avatar: profile.avatar,
    );
    _userController.add(_currentUser);
    return _currentUser;
  }

  Future<void> deleteAccount() async {
    await _authApiClient.deleteAccount(_currentUser.id);
    await _tokenProvider.clearTokens();
    _currentUser = User.empty;
    _userController.add(User.empty);
    _statusController.add(AuthStatus.unauthenticated);
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _authApiClient.changePassword(
      ChangePasswordRequest(
        currentPassword: currentPassword,
        newPassword: newPassword,
      ),
    );
  }

  Future<void> _saveAuthResponse(AuthResponse response) async {
    await _tokenProvider.saveTokens(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
    );
    await fetchProfile();
    _statusController.add(AuthStatus.authenticated);
  }

  void dispose() {
    unawaited(_statusController.close());
    unawaited(_userController.close());
  }
}
