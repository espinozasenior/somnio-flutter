import 'package:dartz/dartz.dart';
import 'package:somnio/core/error/failures.dart';
import 'package:somnio/core/usecase/usecase.dart';
import 'package:somnio/features/auth/domain/entities/user_entity.dart';
import 'package:somnio/features/auth/domain/repositories/auth_repository.dart';

class GetProfileUseCase extends UseCase<UserEntity, NoParams> {
  GetProfileUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) {
    return _repository.getProfile();
  }
}
