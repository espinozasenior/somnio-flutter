import 'package:dartz/dartz.dart';
import 'package:somnio/core/error/error_handler.dart';
import 'package:somnio/core/error/failures.dart';
import 'package:somnio/features/auth/data/datasources/local/auth_local_data_source.dart';
import 'package:somnio/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:somnio/features/auth/data/models/user_model.dart';
import 'package:somnio/features/auth/domain/entities/auth_tokens.dart';
import 'package:somnio/features/auth/domain/entities/user_entity.dart';
import 'package:somnio/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, AuthTokens>> login({
    required String email,
    required String password,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.login(
        email: email,
        password: password,
      );
      await _localDataSource.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      return AuthTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
    });
  }

  @override
  Future<Either<Failure, AuthTokens>> register({
    required String email,
    required String password,
    required String name,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.register(
        email: email,
        password: password,
        name: name,
      );
      await _localDataSource.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      return AuthTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
    });
  }

  @override
  Future<Either<Failure, Unit>> logout() {
    return safeApiCall(() async {
      await _remoteDataSource.logout();
      await _localDataSource.clearTokens();
      return unit;
    });
  }

  @override
  Future<Either<Failure, AuthTokens>> googleSignIn({required String token}) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.googleSignIn(token: token);
      await _localDataSource.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      return AuthTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
    });
  }

  @override
  Future<Either<Failure, AuthTokens>> appleSignIn({required String token}) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.appleSignIn(token: token);
      await _localDataSource.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      return AuthTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
    });
  }

  @override
  Future<Either<Failure, Unit>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) {
    return safeApiCall(() async {
      await _remoteDataSource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return unit;
    });
  }

  @override
  Future<Either<Failure, Unit>> deleteAccount() {
    return safeApiCall(() async {
      final profile = await _remoteDataSource.getProfile();
      await _remoteDataSource.deleteAccount(profile.id);
      await _localDataSource.clearTokens();
      return unit;
    });
  }

  @override
  Future<Either<Failure, UserEntity>> getProfile() {
    return safeApiCall(() async {
      final profile = await _remoteDataSource.getProfile();
      return profile.toEntity();
    });
  }
}
