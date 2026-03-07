import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:somnio/core/network/network_info.dart';

import '../../helpers/mock_factories.dart';

void main() {
  late MockConnectivity mockConnectivity;
  late NetworkInfoImpl networkInfo;

  setUp(() {
    mockConnectivity = MockConnectivity();
    networkInfo = NetworkInfoImpl(mockConnectivity);
  });

  group('$NetworkInfoImpl', () {
    test('returns true when connected via wifi', () async {
      when(
        () => mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);

      final result = await networkInfo.isConnected;

      expect(result, true);
    });

    test('returns true when connected via mobile', () async {
      when(
        () => mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.mobile]);

      final result = await networkInfo.isConnected;

      expect(result, true);
    });

    test('returns false when no connectivity', () async {
      when(
        () => mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.none]);

      final result = await networkInfo.isConnected;

      expect(result, false);
    });

    test('returns false when results are empty', () async {
      when(
        () => mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => []);

      final result = await networkInfo.isConnected;

      expect(result, false);
    });

    test('returns true with multiple results not containing none', () async {
      when(() => mockConnectivity.checkConnectivity()).thenAnswer(
        (_) async => [ConnectivityResult.wifi, ConnectivityResult.mobile],
      );

      final result = await networkInfo.isConnected;

      expect(result, true);
    });
  });
}
