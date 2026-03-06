import 'package:token_provider/token_provider.dart';

class AuthLocalDataSource {
  AuthLocalDataSource({required TokenProvider tokenProvider})
      : _tokenProvider = tokenProvider;

  final TokenProvider _tokenProvider;

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) =>
      _tokenProvider.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

  Future<void> clearTokens() => _tokenProvider.clearTokens();

  Future<bool> get hasTokens => _tokenProvider.hasTokens;
}
