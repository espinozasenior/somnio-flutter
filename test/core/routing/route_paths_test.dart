import 'package:flutter_test/flutter_test.dart';
import 'package:somnio/core/routing/route_paths.dart';

void main() {
  group('RoutePaths', () {
    test('has correct path values', () {
      expect(RoutePaths.splash, '/');
      expect(RoutePaths.login, '/login');
      expect(RoutePaths.signup, '/signup');
      expect(RoutePaths.forgotPassword, '/forgot-password');
      expect(RoutePaths.home, '/home');
      expect(RoutePaths.feed, '/home/feed');
      expect(RoutePaths.feedDetail, '/home/feed/:id');
      expect(RoutePaths.search, '/home/search');
      expect(RoutePaths.profile, '/home/profile');
      expect(RoutePaths.settings, '/settings');
      expect(RoutePaths.themeSettings, '/settings/theme');
    });
  });
}
