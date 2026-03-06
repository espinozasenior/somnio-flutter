import 'package:flutter_test/flutter_test.dart';
import 'package:somnio/features/auth/presentation/cubit/auth_state.dart';
import 'package:user_repository/user_repository.dart';

void main() {
  group('$AuthState', () {
    test('has correct initial values', () {
      const state = AuthState();

      expect(state.status, AuthStatus.unknown);
      expect(state.user, User.empty);
    });

    test('supports value equality', () {
      const state1 = AuthState();
      const state2 = AuthState();

      expect(state1, equals(state2));
    });

    test('copyWith returns updated state', () {
      const state = AuthState();
      final updated = state.copyWith(status: AuthStatus.authenticated);

      expect(updated.status, AuthStatus.authenticated);
      expect(updated.user, User.empty);
    });

    test('copyWith with user returns updated state', () {
      const state = AuthState();
      const user = User(id: '1', email: 'a@b.com', name: 'Test');
      final updated = state.copyWith(user: user);

      expect(updated.user, user);
      expect(updated.status, AuthStatus.unknown);
    });
  });
}
