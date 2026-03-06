import 'package:flutter_test/flutter_test.dart';
import 'package:somnio/features/auth/domain/entities/user_entity.dart';

void main() {
  group('$UserEntity', () {
    test('supports value equality', () {
      const user1 = UserEntity(id: '1', email: 'a@b.com');
      const user2 = UserEntity(id: '1', email: 'a@b.com');
      const user3 = UserEntity(id: '2', email: 'a@b.com');

      expect(user1, equals(user2));
      expect(user1, isNot(equals(user3)));
    });

    test('empty returns correct instance', () {
      expect(UserEntity.empty.id, '');
      expect(UserEntity.empty.email, '');
      expect(UserEntity.empty.name, isNull);
      expect(UserEntity.empty.avatar, isNull);
    });

    test('isEmpty returns true for empty user', () {
      expect(UserEntity.empty.isEmpty, true);
      expect(UserEntity.empty.isNotEmpty, false);
    });

    test('isNotEmpty returns true for non-empty user', () {
      const user = UserEntity(id: '1', email: 'a@b.com');
      expect(user.isNotEmpty, true);
      expect(user.isEmpty, false);
    });

    test('props includes all fields', () {
      const user = UserEntity(
        id: '1',
        email: 'a@b.com',
        name: 'Test',
        avatar: 'url',
      );
      expect(user.props, ['1', 'a@b.com', 'Test', 'url']);
    });
  });
}
