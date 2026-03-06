abstract class TokenProvider {
  Future<String?> get accessToken;

  Future<String?> get refreshToken;

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  });

  Future<void> clearTokens();

  Future<bool> get hasTokens;
}
