import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:somnio/features/posts/presentation/cubit/post_detail_cubit.dart';
import 'package:somnio/features/posts/presentation/cubit/post_detail_state.dart';

import '../../../../helpers/helpers.dart';
import '../../../../helpers/mock_factories.dart';

void main() {
  late MockGetPostById mockGetPostById;

  setUp(() {
    mockGetPostById = MockGetPostById();
  });

  setUpAll(() {
    registerFallbackValue(1);
  });

  PostDetailCubit buildCubit() => PostDetailCubit(mockGetPostById);

  group('$PostDetailCubit', () {
    test('initial state is PostDetailInitial', () async {
      final cubit = buildCubit();
      expect(cubit.state, const PostDetailState.initial());
      await cubit.close();
    });

    blocTest<PostDetailCubit, PostDetailState>(
      'emits loading then loaded on success',
      build: buildCubit,
      setUp: () {
        when(() => mockGetPostById(any())).thenAnswer(
          (_) async => Right(TestFixtures.postEntity()),
        );
      },
      act: (cubit) => cubit.loadPost(1),
      expect: () => [
        const PostDetailState.loading(),
        PostDetailState.loaded(TestFixtures.postEntity()),
      ],
    );

    blocTest<PostDetailCubit, PostDetailState>(
      'emits loading then error on failure',
      build: buildCubit,
      setUp: () {
        when(() => mockGetPostById(any())).thenAnswer(
          (_) async => const Left(TestFixtures.serverFailure),
        );
      },
      act: (cubit) => cubit.loadPost(1),
      expect: () => [
        const PostDetailState.loading(),
        const PostDetailState.error(TestFixtures.serverFailure),
      ],
    );
  });
}
