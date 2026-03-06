import 'package:flutter_test/flutter_test.dart';
import 'package:somnio/features/auth/domain/entities/auth_tokens.dart';

void main() {
  group('$AuthTokens', () {
    test('supports value equality', () {
      const tokens1 = AuthTokens(
        accessToken: 'access',
        refreshToken: 'refresh',
      );
      const tokens2 = AuthTokens(
        accessToken: 'access',
        refreshToken: 'refresh',
      );
      const tokens3 = AuthTokens(
        accessToken: 'other',
        refreshToken: 'refresh',
      );

      expect(tokens1, equals(tokens2));
      expect(tokens1, isNot(equals(tokens3)));
    });

    test('props includes all fields', () {
      const tokens = AuthTokens(
        accessToken: 'access',
        refreshToken: 'refresh',
      );
      expect(tokens.props, ['access', 'refresh']);
    });
  });
}
