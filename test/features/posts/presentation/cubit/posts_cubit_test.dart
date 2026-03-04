import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:somnio/core/error/failures.dart';
import 'package:somnio/core/usecase/usecase.dart';
import 'package:somnio/features/posts/domain/entities/post_entity.dart';
import 'package:somnio/features/posts/domain/usecases/get_posts.dart';
import 'package:somnio/features/posts/presentation/cubit/posts_cubit.dart';
import 'package:somnio/features/posts/presentation/cubit/posts_state.dart';

import '../../../../helpers/helpers.dart';

class _FakeGetPosts implements GetPosts {
  Either<Failure, List<PostEntity>>? result;

  @override
  Future<Either<Failure, List<PostEntity>>> call(NoParams params) async {
    return result!;
  }
}

void main() {
  group('$PostsCubit', () {
    late _FakeGetPosts fakeGetPosts;

    PostsCubit buildCubit() => PostsCubit(fakeGetPosts);

    setUp(() {
      fakeGetPosts = _FakeGetPosts();
    });

    test('constructor returns normally', () {
      expect(buildCubit, returnsNormally);
    });

    test('initial state is $PostsInitial', () {
      expect(buildCubit().state, const PostsState.initial());
    });

    blocTest<PostsCubit, PostsState>(
      'emits [loading, loaded] on successful loadPosts',
      setUp: () {
        fakeGetPosts.result = Right(TestFixtures.postEntities(3));
      },
      build: buildCubit,
      act: (cubit) => cubit.loadPosts(),
      expect: () => [
        const PostsState.loading(),
        PostsState.loaded(TestFixtures.postEntities(3)),
      ],
    );

    blocTest<PostsCubit, PostsState>(
      'emits [loading, error] on failure',
      setUp: () {
        fakeGetPosts.result = const Left(TestFixtures.serverFailure);
      },
      build: buildCubit,
      act: (cubit) => cubit.loadPosts(),
      expect: () => [
        const PostsState.loading(),
        const PostsState.error(TestFixtures.serverFailure),
      ],
    );
  });
}
