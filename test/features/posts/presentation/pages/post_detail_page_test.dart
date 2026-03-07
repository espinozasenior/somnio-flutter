import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:somnio/core/widgets/error_view.dart';
import 'package:somnio/core/widgets/loading_view.dart';
import 'package:somnio/features/posts/presentation/cubit/post_detail_cubit.dart';
import 'package:somnio/features/posts/presentation/cubit/post_detail_state.dart';
import 'package:somnio/features/posts/presentation/pages/post_detail_page.dart';

import '../../../../helpers/helpers.dart';

class MockPostDetailCubit extends MockCubit<PostDetailState>
    implements PostDetailCubit {}

void main() {
  final getIt = GetIt.instance;
  late MockPostDetailCubit mockPostDetailCubit;

  setUp(() async {
    await getIt.reset();
    mockPostDetailCubit = MockPostDetailCubit();
    getIt.registerFactory<PostDetailCubit>(() => mockPostDetailCubit);

    when(
      () => mockPostDetailCubit.state,
    ).thenReturn(const PostDetailState.initial());
    when(
      () => mockPostDetailCubit.stream,
    ).thenAnswer((_) => const Stream.empty());
    when(() => mockPostDetailCubit.close()).thenAnswer((_) async {});
    when(() => mockPostDetailCubit.loadPost(any())).thenAnswer((_) async {});
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('PostDetailPage', () {
    testWidgets('shows LoadingView when state is loading', (tester) async {
      when(
        () => mockPostDetailCubit.state,
      ).thenReturn(const PostDetailState.loading());

      await tester.pumpApp(const PostDetailPage(id: '1'));
      await tester.pump();

      expect(find.byType(LoadingView), findsOneWidget);
    });

    testWidgets('shows post title and body when loaded', (tester) async {
      final post = TestFixtures.postEntity();
      when(
        () => mockPostDetailCubit.state,
      ).thenReturn(PostDetailState.loaded(post));

      await tester.pumpApp(const PostDetailPage(id: '1'));
      await tester.pump();

      expect(find.text('Test Post 1'), findsOneWidget);
      expect(find.text('Test body for post 1'), findsOneWidget);
    });

    testWidgets('shows ErrorView when state is error', (tester) async {
      when(
        () => mockPostDetailCubit.state,
      ).thenReturn(const PostDetailState.error(TestFixtures.serverFailure));

      await tester.pumpApp(const PostDetailPage(id: '1'));
      await tester.pump();

      expect(find.byType(ErrorView), findsOneWidget);
      expect(find.text('Server error'), findsOneWidget);
    });

    testWidgets('retry button calls loadPost', (tester) async {
      when(
        () => mockPostDetailCubit.state,
      ).thenReturn(const PostDetailState.error(TestFixtures.serverFailure));

      await tester.pumpApp(const PostDetailPage(id: '1'));
      await tester.pump();

      clearInteractions(mockPostDetailCubit);

      await tester.tap(find.widgetWithText(FilledButton, 'Retry'));
      await tester.pump();

      verify(() => mockPostDetailCubit.loadPost(1)).called(1);
    });

    testWidgets('shows SizedBox.shrink when state is initial', (tester) async {
      when(
        () => mockPostDetailCubit.state,
      ).thenReturn(const PostDetailState.initial());

      await tester.pumpApp(const PostDetailPage(id: '1'));
      await tester.pump();

      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.byType(LoadingView), findsNothing);
      expect(find.byType(ErrorView), findsNothing);
    });

    testWidgets('shows app bar with Post Detail title', (tester) async {
      await tester.pumpApp(const PostDetailPage(id: '1'));
      await tester.pump();

      expect(find.text('Post Detail'), findsOneWidget);
    });
  });
}
