import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:somnio/features/auth/presentation/cubit/login_cubit.dart';
import 'package:somnio/features/auth/presentation/cubit/login_state.dart';
import 'package:somnio/features/auth/presentation/pages/login_page.dart';
import 'package:somnio/features/auth/presentation/widgets/auth_form_field.dart';
import 'package:somnio/features/auth/presentation/widgets/social_login_buttons.dart';
import 'package:somnio/l10n/l10n.dart';

import '../../../../helpers/helpers.dart';
import '../../../../helpers/mock_factories.dart';

void main() {
  final getIt = GetIt.instance;
  late MockLoginCubit mockLoginCubit;

  setUp(() async {
    await getIt.reset();
    mockLoginCubit = MockLoginCubit();
    getIt.registerFactory<LoginCubit>(() => mockLoginCubit);

    when(() => mockLoginCubit.state).thenReturn(const LoginState());
    when(() => mockLoginCubit.stream)
        .thenAnswer((_) => const Stream.empty());
    when(() => mockLoginCubit.close()).thenAnswer((_) async {});
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('LoginPage', () {
    testWidgets('renders login page with sign in title', (tester) async {
      await tester.pumpApp(const LoginPage());
      await tester.pump();

      expect(find.text('Welcome back'), findsOneWidget);
      expect(find.text('Sign in to your account'), findsOneWidget);
    });

    testWidgets('renders email and password fields', (tester) async {
      await tester.pumpApp(const LoginPage());
      await tester.pump();

      expect(find.byType(AuthFormField), findsNWidgets(2));
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('renders sign in button', (tester) async {
      await tester.pumpApp(const LoginPage());
      await tester.pump();

      expect(
        find.widgetWithText(FilledButton, 'Sign In'),
        findsOneWidget,
      );
    });

    testWidgets('renders social login buttons', (tester) async {
      await tester.pumpApp(const LoginPage());
      await tester.pump();

      expect(find.byType(SocialLoginButtons), findsOneWidget);
      expect(find.text('or'), findsOneWidget);
    });

    testWidgets('renders sign up link', (tester) async {
      await tester.pumpApp(const LoginPage());
      await tester.pump();

      expect(
        find.widgetWithText(TextButton, "Don't have an account? Sign Up"),
        findsOneWidget,
      );
    });

    testWidgets('shows snackbar on failure', (tester) async {
      whenListen(
        mockLoginCubit,
        Stream.fromIterable([
          const LoginState(
            status: FormzSubmissionStatus.failure,
            failure: TestFixtures.authFailure,
          ),
        ]),
        initialState: const LoginState(),
      );

      await tester.pumpApp(const LoginPage());
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Invalid credentials'), findsOneWidget);
    });

    testWidgets('shows default error when failure is null', (tester) async {
      whenListen(
        mockLoginCubit,
        Stream.fromIterable([
          const LoginState(status: FormzSubmissionStatus.failure),
        ]),
        initialState: const LoginState(),
      );

      await tester.pumpApp(const LoginPage());
      await tester.pump();

      expect(find.text('Authentication failed'), findsOneWidget);
    });

    testWidgets('shows loading indicator when in progress', (tester) async {
      when(() => mockLoginCubit.state).thenReturn(
        const LoginState(status: FormzSubmissionStatus.inProgress),
      );

      await tester.pumpApp(const LoginPage());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows email error when email is invalid', (tester) async {
      when(() => mockLoginCubit.state).thenReturn(
        const LoginState(email: Email.dirty('bad')),
      );

      await tester.pumpApp(const LoginPage());
      await tester.pump();

      expect(find.text('Invalid email'), findsOneWidget);
    });

    testWidgets('shows password error when password is invalid',
        (tester) async {
      when(() => mockLoginCubit.state).thenReturn(
        const LoginState(password: Password.dirty('sh')),
      );

      await tester.pumpApp(const LoginPage());
      await tester.pump();

      expect(
        find.text('Password must be at least 8 characters'),
        findsOneWidget,
      );
    });

    testWidgets('sign in button calls loginWithCredentials',
        (tester) async {
      when(() => mockLoginCubit.loginWithCredentials())
          .thenAnswer((_) async {});

      await tester.pumpApp(const LoginPage());
      await tester.pump();

      await tester.tap(find.widgetWithText(FilledButton, 'Sign In'));
      await tester.pump();

      verify(() => mockLoginCubit.loginWithCredentials()).called(1);
    });

    testWidgets('sign up link navigates to signup', (tester) async {
      final router = GoRouter(
        initialLocation: '/login',
        routes: [
          GoRoute(
            path: '/login',
            builder: (_, _) => const LoginPage(),
          ),
          GoRoute(
            path: '/signup',
            builder: (_, _) => const Scaffold(
              body: Text('Signup Route'),
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
          localizationsDelegates:
              AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.widgetWithText(
          TextButton,
          "Don't have an account? Sign Up",
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Signup Route'), findsOneWidget);
    });
  });
}
