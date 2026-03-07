import 'package:auth_client/auth_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:somnio/features/auth/data/models/user_model.dart';
import 'package:somnio/features/auth/domain/entities/user_entity.dart';

void main() {
  group('ProfileResponseToEntity', () {
    test('converts ProfileResponse to UserEntity', () {
      const profile = ProfileResponse(
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
        avatar: 'https://example.com/avatar.png',
      );

      final entity = profile.toEntity();

      expect(entity, isA<UserEntity>());
      expect(entity.id, '1');
      expect(entity.email, 'test@example.com');
      expect(entity.name, 'Test User');
      expect(entity.avatar, 'https://example.com/avatar.png');
    });

    test('handles null optional fields', () {
      const profile = ProfileResponse(
        id: '1',
        email: 'test@example.com',
      );

      final entity = profile.toEntity();

      expect(entity.name, isNull);
      expect(entity.avatar, isNull);
    });
  });
}
