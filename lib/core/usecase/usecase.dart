import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:somnio/core/error/failures.dart';

/// Single-method interface for use cases.
// ignore: one_member_abstracts
abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
