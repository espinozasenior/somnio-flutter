import 'package:dartz/dartz.dart';
import 'package:somnio/core/error/exceptions.dart';
import 'package:somnio/core/error/failures.dart';

Future<Either<Failure, T>> safeApiCall<T>(
  Future<T> Function() call,
) async {
  try {
    final result = await call();
    return Right(result);
  } on ServerException catch (e) {
    return Left(
      ServerFailure(message: e.message, statusCode: e.statusCode),
    );
  } on CacheException catch (e) {
    return Left(CacheFailure(message: e.message));
  } on NetworkException catch (_) {
    return const Left(
      NetworkFailure(message: 'No internet connection'),
    );
  } on Exception catch (e) {
    return Left(ServerFailure(message: e.toString()));
  }
}

Future<Either<Failure, T>> safeCacheCall<T>(
  Future<T> Function() call,
) async {
  try {
    final result = await call();
    return Right(result);
  } on CacheException catch (e) {
    return Left(CacheFailure(message: e.message));
  } on Exception catch (e) {
    return Left(CacheFailure(message: e.toString()));
  }
}
