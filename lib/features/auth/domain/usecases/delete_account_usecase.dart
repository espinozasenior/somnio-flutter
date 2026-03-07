import 'package:dartz/dartz.dart';
import 'package:somnio/core/error/failures.dart';
import 'package:somnio/core/usecase/usecase.dart';
import 'package:somnio/features/auth/domain/repositories/auth_repository.dart';

class DeleteAccountUseCase extends UseCase<Unit, NoParams> {
  DeleteAccountUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(NoParams params) {
    return _repository.deleteAccount();
  }
}
