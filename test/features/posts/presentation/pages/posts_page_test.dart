import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:somnio/core/widgets/error_view.dart';
import 'package:somnio/core/widgets/loading_view.dart';
import 'package:somnio/features/posts/presentation/cubit/posts_cubit.dart';
import 'package:somnio/features/posts/presentation/cubit/posts_state.dart';
import 'package:somnio/features/posts/presentation/pages/posts_page.dart';
import 'package:somnio/features/posts/presentation/widgets/post_list_tile.dart';

import '../../../../helpers/helpers.dart';
import '../../../../helpers/mock_factories.dart';

void main() {
  final getIt = GetIt.instance;
  late MockPostsCubit mockPostsCubit;

  setUp(() async {
    await getIt.reset();
    mockPostsCubit = MockPostsCubit();
    getIt.registerFactory<PostsCubit>(() => mockPostsCubit);

    when(() => mockPostsCubit.state)
        .thenReturn(const PostsState.initial());
    when(() => mockPostsCubit.stream)
        .thenAnswer((_) => const Stream.empty());
    when(() => mockPostsCubit.close()).thenAnswer((_) async {});
    when(() => mockPostsCubit.loadPosts()).thenAnswer((_) async {});
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('PostsPage', () {
    testWidgets('renders PostsPage', (tester) async {
      await tester.pumpApp(const PostsPage());
      await tester.pumpAndSettle();

      expect(find.byType(PostsPage), findsOneWidget);
      expect(find.text('Posts'), findsOneWidget);
    });

    testWidgets('shows LoadingView when state is loading', (tester) async {
      when(() => mockPostsCubit.state)
          .thenReturn(const PostsState.loading());

      await tester.pumpApp(const PostsPage());
      await tester.pump();

      expect(find.byType(LoadingView), findsOneWidget);
    });

    testWidgets('shows ListView when state is loaded', (tester) async {
      final posts = TestFixtures.postEntities(3);
      when(() => mockPostsCubit.state)
          .thenReturn(PostsState.loaded(posts));

      await tester.pumpApp(const PostsPage());
      await tester.pump();

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(PostListTile), findsNWidgets(3));
    });

    testWidgets('shows ErrorView when state is error', (tester) async {
      when(() => mockPostsCubit.state)
          .thenReturn(const PostsState.error(TestFixtures.serverFailure));

      await tester.pumpApp(const PostsPage());
      await tester.pump();

      expect(find.byType(ErrorView), findsOneWidget);
      expect(find.text('Server error'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Retry'), findsOneWidget);
    });

    testWidgets('retry button calls loadPosts', (tester) async {
      when(() => mockPostsCubit.state)
          .thenReturn(const PostsState.error(TestFixtures.serverFailure));

      await tester.pumpApp(const PostsPage());
      await tester.pump();

      // Reset interactions since loadPosts is called in constructor
      clearInteractions(mockPostsCubit);

      await tester.tap(find.widgetWithText(FilledButton, 'Retry'));

      verify(() => mockPostsCubit.loadPosts()).called(1);
    });

    testWidgets('shows SizedBox.shrink when state is initial',
        (tester) async {
      when(() => mockPostsCubit.state)
          .thenReturn(const PostsState.initial());

      await tester.pumpApp(const PostsPage());
      await tester.pump();

      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.byType(LoadingView), findsNothing);
      expect(find.byType(ErrorView), findsNothing);
    });

    // PostListTile.onTap navigation is integration-level:
    // it requires GoRouter context and PostsCubit BlocProvider
    // to coexist, which is covered by the AppRouter redirect tests.
  });
}
