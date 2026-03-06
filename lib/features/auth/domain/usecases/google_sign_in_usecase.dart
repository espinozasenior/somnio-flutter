import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:somnio/core/error/failures.dart';
import 'package:somnio/core/usecase/usecase.dart';
import 'package:somnio/features/auth/domain/entities/auth_tokens.dart';
import 'package:somnio/features/auth/domain/repositories/auth_repository.dart';

class GoogleSignInUseCase extends UseCase<AuthTokens, SocialSignInParams> {
  GoogleSignInUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, AuthTokens>> call(SocialSignInParams params) {
    return _repository.googleSignIn(token: params.token);
  }
}

class SocialSignInParams extends Equatable {
  const SocialSignInParams({required this.token});

  final String token;

  @override
  List<Object?> get props => [token];
}
