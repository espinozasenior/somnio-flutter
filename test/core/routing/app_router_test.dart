import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:somnio/core/routing/app_router.dart';
import 'package:somnio/features/auth/presentation/cubit/login_cubit.dart';
import 'package:somnio/features/auth/presentation/cubit/login_state.dart';
import 'package:somnio/features/auth/presentation/cubit/signup_cubit.dart';
import 'package:somnio/features/auth/presentation/cubit/signup_state.dart';
import 'package:somnio/features/posts/presentation/cubit/posts_cubit.dart';
import 'package:somnio/features/posts/presentation/cubit/posts_state.dart';
import 'package:somnio/l10n/l10n.dart';
import 'package:user_repository/user_repository.dart';

import '../../helpers/mock_factories.dart';

void main() {
  final getIt = GetIt.instance;

  group('$AppRouter', () {
    late MockUserRepository mockUserRepository;
    late MockLoginCubit mockLoginCubit;
    late MockSignupCubit mockSignupCubit;
    late MockPostsCubit mockPostsCubit;

    setUp(() async {
      await getIt.reset();
      mockUserRepository = MockUserRepository();
      mockLoginCubit = MockLoginCubit();
      mockSignupCubit = MockSignupCubit();
      mockPostsCubit = MockPostsCubit();

      when(
        () => mockUserRepository.status,
      ).thenAnswer((_) => const Stream<AuthStatus>.empty());
      when(() => mockUserRepository.currentUser).thenReturn(User.empty);

      when(() => mockLoginCubit.state).thenReturn(const LoginState());
      when(() => mockLoginCubit.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockLoginCubit.close()).thenAnswer((_) async {});

      when(() => mockSignupCubit.state).thenReturn(const SignupState());
      when(
        () => mockSignupCubit.stream,
      ).thenAnswer((_) => const Stream.empty());
      when(() => mockSignupCubit.close()).thenAnswer((_) async {});

      when(() => mockPostsCubit.state).thenReturn(const PostsState.initial());
      when(() => mockPostsCubit.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockPostsCubit.close()).thenAnswer((_) async {});
      when(() => mockPostsCubit.loadPosts()).thenAnswer((_) async {});

      getIt
        ..registerFactory<LoginCubit>(() => mockLoginCubit)
        ..registerFactory<SignupCubit>(() => mockSignupCubit)
        ..registerFactory<PostsCubit>(() => mockPostsCubit);
    });

    tearDown(() async {
      await getIt.reset();
    });

    Widget buildApp(AppRouter appRouter) {
      return MaterialApp.router(
        routerConfig: appRouter.router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      );
    }

    test('creates AppRouter with UserRepository', () {
      final appRouter = AppRouter(userRepository: mockUserRepository);
      expect(appRouter.router, isNotNull);
    });

    testWidgets(
      'redirects unauthenticated user from feed to login',
      (tester) async {
        final appRouter = AppRouter(
          userRepository: mockUserRepository,
        );

        await tester.pumpWidget(buildApp(appRouter));
        await tester.pumpAndSettle();

        expect(find.text('Welcome back'), findsOneWidget);
      },
    );

    testWidgets(
      'authenticated user stays on feed',
      (tester) async {
        when(() => mockUserRepository.currentUser).thenReturn(
          const User(id: '1', email: 'test@example.com'),
        );

        final appRouter = AppRouter(
          userRepository: mockUserRepository,
        );

        await tester.pumpWidget(buildApp(appRouter));
        await tester.pumpAndSettle();

        expect(find.text('Posts'), findsOneWidget);
      },
    );

    testWidgets(
      'authenticated user navigating to login redirects to feed',
      (tester) async {
        when(() => mockUserRepository.currentUser).thenReturn(
          const User(id: '1', email: 'test@example.com'),
        );

        final appRouter = AppRouter(
          userRepository: mockUserRepository,
        );

        await tester.pumpWidget(buildApp(appRouter));
        await tester.pumpAndSettle();

        appRouter.router.go('/login');
        await tester.pumpAndSettle();

        // Should redirect from /login back to /feed
        expect(find.text('Posts'), findsOneWidget);
      },
    );

    testWidgets(
      'unauthenticated user stays on signup page',
      (tester) async {
        final appRouter = AppRouter(
          userRepository: mockUserRepository,
        );

        await tester.pumpWidget(buildApp(appRouter));
        await tester.pumpAndSettle();

        appRouter.router.go('/signup');
        await tester.pumpAndSettle();

        expect(find.text('Create Account'), findsOneWidget);
      },
    );
  });
}
