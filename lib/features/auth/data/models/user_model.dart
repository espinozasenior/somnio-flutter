import 'package:auth_client/auth_client.dart';
import 'package:somnio/features/auth/domain/entities/user_entity.dart';

extension ProfileResponseToEntity on ProfileResponse {
  UserEntity toEntity() => UserEntity(
        id: id,
        email: email,
        name: name,
        avatar: avatar,
      );
}
