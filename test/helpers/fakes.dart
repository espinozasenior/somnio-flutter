import 'package:dartz/dartz.dart';
import 'package:somnio/core/error/failures.dart';
import 'package:somnio/features/auth/domain/entities/auth_tokens.dart';
import 'package:somnio/features/auth/domain/entities/user_entity.dart';
import 'package:somnio/features/auth/domain/repositories/auth_repository.dart';
import 'package:somnio/features/posts/domain/entities/post_entity.dart';
import 'package:somnio/features/posts/domain/repositories/post_repository.dart';

/// Fake [PostRepository] for testing without mocking frameworks.
///
/// Set [getPostsResult] / [getPostByIdResult] before exercising the SUT.
class FakePostRepository implements PostRepository {
  Either<Failure, List<PostEntity>>? getPostsResult;
  Either<Failure, PostEntity>? getPostByIdResult;
  int getPostsCallCount = 0;
  int getPostByIdCallCount = 0;
  int? lastGetPostByIdArg;

  @override
  Future<Either<Failure, List<PostEntity>>> getPosts() async {
    getPostsCallCount++;
    return getPostsResult!;
  }

  @override
  Future<Either<Failure, PostEntity>> getPostById(int id) async {
    getPostByIdCallCount++;
    lastGetPostByIdArg = id;
    return getPostByIdResult!;
  }
}

/// Fake [AuthRepository] for testing without mocking frameworks.
class FakeAuthRepository implements AuthRepository {
  Either<Failure, AuthTokens>? loginResult;
  Either<Failure, AuthTokens>? registerResult;
  Either<Failure, Unit>? logoutResult;
  Either<Failure, AuthTokens>? googleSignInResult;
  Either<Failure, AuthTokens>? appleSignInResult;
  Either<Failure, Unit>? changePasswordResult;
  Either<Failure, Unit>? deleteAccountResult;
  Either<Failure, UserEntity>? getProfileResult;

  int loginCallCount = 0;
  int registerCallCount = 0;
  int logoutCallCount = 0;
  int googleSignInCallCount = 0;
  int appleSignInCallCount = 0;
  int changePasswordCallCount = 0;
  int deleteAccountCallCount = 0;
  int getProfileCallCount = 0;

  String? lastEmail;
  String? lastPassword;

  @override
  Future<Either<Failure, AuthTokens>> login({
    required String email,
    required String password,
  }) async {
    loginCallCount++;
    lastEmail = email;
    lastPassword = password;
    return loginResult!;
  }

  @override
  Future<Either<Failure, AuthTokens>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    registerCallCount++;
    return registerResult!;
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    logoutCallCount++;
    return logoutResult!;
  }

  @override
  Future<Either<Failure, AuthTokens>> googleSignIn({
    required String token,
  }) async {
    googleSignInCallCount++;
    return googleSignInResult!;
  }

  @override
  Future<Either<Failure, AuthTokens>> appleSignIn({
    required String token,
  }) async {
    appleSignInCallCount++;
    return appleSignInResult!;
  }

  @override
  Future<Either<Failure, Unit>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    changePasswordCallCount++;
    return changePasswordResult!;
  }

  @override
  Future<Either<Failure, Unit>> deleteAccount() async {
    deleteAccountCallCount++;
    return deleteAccountResult!;
  }

  @override
  Future<Either<Failure, UserEntity>> getProfile() async {
    getProfileCallCount++;
    return getProfileResult!;
  }
}
