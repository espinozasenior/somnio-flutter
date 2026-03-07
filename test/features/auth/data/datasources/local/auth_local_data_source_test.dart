import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:somnio/features/auth/data/datasources/local/auth_local_data_source.dart';
import 'package:token_provider/token_provider.dart';

class _MockTokenProvider extends Mock implements TokenProvider {}

void main() {
  late _MockTokenProvider mockTokenProvider;
  late AuthLocalDataSource dataSource;

  setUp(() {
    mockTokenProvider = _MockTokenProvider();
    dataSource = AuthLocalDataSource(tokenProvider: mockTokenProvider);
  });

  group('$AuthLocalDataSource', () {
    test('saveTokens delegates to token provider', () async {
      when(
        () => mockTokenProvider.saveTokens(
          accessToken: any(named: 'accessToken'),
          refreshToken: any(named: 'refreshToken'),
        ),
      ).thenAnswer((_) async {});

      await dataSource.saveTokens(
        accessToken: 'access',
        refreshToken: 'refresh',
      );

      verify(
        () => mockTokenProvider.saveTokens(
          accessToken: 'access',
          refreshToken: 'refresh',
        ),
      ).called(1);
    });

    test('clearTokens delegates to token provider', () async {
      when(() => mockTokenProvider.clearTokens()).thenAnswer((_) async {});

      await dataSource.clearTokens();

      verify(() => mockTokenProvider.clearTokens()).called(1);
    });

    test('hasTokens delegates to token provider', () async {
      when(() => mockTokenProvider.hasTokens).thenAnswer((_) async => true);

      final result = await dataSource.hasTokens;

      expect(result, true);
    });

    test('hasTokens returns false when no tokens', () async {
      when(() => mockTokenProvider.hasTokens).thenAnswer((_) async => false);

      final result = await dataSource.hasTokens;

      expect(result, false);
    });
  });
}
