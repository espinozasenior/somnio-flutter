import 'package:dartz/dartz.dart';
import 'package:somnio/core/error/failures.dart';
import 'package:somnio/core/usecase/usecase.dart';
import 'package:somnio/features/auth/domain/entities/auth_tokens.dart';
import 'package:somnio/features/auth/domain/repositories/auth_repository.dart';
import 'package:somnio/features/auth/domain/usecases/google_sign_in_usecase.dart';

class AppleSignInUseCase extends UseCase<AuthTokens, SocialSignInParams> {
  AppleSignInUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, AuthTokens>> call(SocialSignInParams params) {
    return _repository.appleSignIn(token: params.token);
  }
}
