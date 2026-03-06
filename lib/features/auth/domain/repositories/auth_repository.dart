import 'package:dartz/dartz.dart';
import 'package:somnio/core/error/failures.dart';
import 'package:somnio/features/auth/domain/entities/auth_tokens.dart';
import 'package:somnio/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthTokens>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, AuthTokens>> register({
    required String email,
    required String password,
    required String name,
  });

  Future<Either<Failure, Unit>> logout();

  Future<Either<Failure, AuthTokens>> googleSignIn({required String token});

  Future<Either<Failure, AuthTokens>> appleSignIn({required String token});

  Future<Either<Failure, Unit>> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<Either<Failure, Unit>> deleteAccount();

  Future<Either<Failure, UserEntity>> getProfile();
}
