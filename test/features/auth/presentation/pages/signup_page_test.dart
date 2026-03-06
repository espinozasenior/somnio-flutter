import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:somnio/features/auth/presentation/cubit/signup_cubit.dart';
import 'package:somnio/features/auth/presentation/cubit/signup_state.dart';
import 'package:somnio/features/auth/presentation/pages/signup_page.dart';
import 'package:somnio/features/auth/presentation/widgets/auth_form_field.dart';
import 'package:somnio/l10n/l10n.dart';

import '../../../../helpers/helpers.dart';
import '../../../../helpers/mock_factories.dart';

void main() {
  final getIt = GetIt.instance;
  late MockSignupCubit mockSignupCubit;

  setUp(() async {
    await getIt.reset();
    mockSignupCubit = MockSignupCubit();
    getIt.registerFactory<SignupCubit>(() => mockSignupCubit);

    when(() => mockSignupCubit.state).thenReturn(const SignupState());
    when(() => mockSignupCubit.stream)
        .thenAnswer((_) => const Stream.empty());
    when(() => mockSignupCubit.close()).thenAnswer((_) async {});
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('SignupPage', () {
    testWidgets('renders signup page with create account title',
        (tester) async {
      await tester.pumpApp(const SignupPage());
      await tester.pump();

      expect(find.text('Create Account'), findsOneWidget);
      expect(find.text('Sign up to get started'), findsOneWidget);
    });

    testWidgets('renders all 4 form fields', (tester) async {
      await tester.pumpApp(const SignupPage());
      await tester.pump();

      expect(find.byType(AuthFormField), findsNWidgets(4));
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
    });

    testWidgets('renders sign up button', (tester) async {
      await tester.pumpApp(const SignupPage());
      await tester.pump();

      expect(
        find.widgetWithText(FilledButton, 'Sign Up'),
        findsOneWidget,
      );
    });

    testWidgets('renders sign in link', (tester) async {
      await tester.pumpApp(const SignupPage());
      await tester.pump();

      expect(
        find.widgetWithText(TextButton, 'Already have an account? Sign In'),
        findsOneWidget,
      );
    });

    testWidgets('shows snackbar on failure', (tester) async {
      whenListen(
        mockSignupCubit,
        Stream.fromIterable([
          const SignupState(
            status: FormzSubmissionStatus.failure,
            failure: TestFixtures.authFailure,
          ),
        ]),
        initialState: const SignupState(),
      );

      await tester.pumpApp(const SignupPage());
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Invalid credentials'), findsOneWidget);
    });

    testWidgets('shows default error when failure is null', (tester) async {
      whenListen(
        mockSignupCubit,
        Stream.fromIterable([
          const SignupState(status: FormzSubmissionStatus.failure),
        ]),
        initialState: const SignupState(),
      );

      await tester.pumpApp(const SignupPage());
      await tester.pump();

      expect(find.text('Registration failed'), findsOneWidget);
    });

    testWidgets('shows loading indicator when in progress', (tester) async {
      when(() => mockSignupCubit.state).thenReturn(
        const SignupState(status: FormzSubmissionStatus.inProgress),
      );

      await tester.pumpApp(const SignupPage());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows name error when name is invalid', (tester) async {
      when(() => mockSignupCubit.state).thenReturn(
        const SignupState(name: NameInput.dirty('a')),
      );

      await tester.pumpApp(const SignupPage());
      await tester.pump();

      expect(
        find.text('Name must be at least 2 characters'),
        findsOneWidget,
      );
    });

    testWidgets('shows email error when email is invalid', (tester) async {
      when(() => mockSignupCubit.state).thenReturn(
        const SignupState(email: Email.dirty('bad')),
      );

      await tester.pumpApp(const SignupPage());
      await tester.pump();

      expect(find.text('Invalid email'), findsOneWidget);
    });

    testWidgets('shows password error when password is invalid',
        (tester) async {
      when(() => mockSignupCubit.state).thenReturn(
        const SignupState(password: Password.dirty('sh')),
      );

      await tester.pumpApp(const SignupPage());
      await tester.pump();

      expect(
        find.text('Password must be at least 8 characters'),
        findsOneWidget,
      );
    });

    testWidgets('shows confirm password error when mismatch', (tester) async {
      when(() => mockSignupCubit.state).thenReturn(
        const SignupState(
          confirmedPassword: ConfirmedPassword.dirty(
            password: 'password123',
            value: 'different',
          ),
        ),
      );

      await tester.pumpApp(const SignupPage());
      await tester.pump();

      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('sign up button calls signupWithCredentials',
        (tester) async {
      when(() => mockSignupCubit.signupWithCredentials())
          .thenAnswer((_) async {});

      await tester.pumpApp(const SignupPage());
      await tester.pump();

      await tester.tap(find.widgetWithText(FilledButton, 'Sign Up'));
      await tester.pump();

      verify(() => mockSignupCubit.signupWithCredentials()).called(1);
    });

    testWidgets('sign in link navigates to login', (tester) async {
      final router = GoRouter(
        initialLocation: '/signup',
        routes: [
          GoRoute(
            path: '/signup',
            builder: (_, _) => const SignupPage(),
          ),
          GoRoute(
            path: '/login',
            builder: (_, _) => const Scaffold(
              body: Text('Login Route'),
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
          'Already have an account? Sign In',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Login Route'), findsOneWidget);
    });
  });
}
