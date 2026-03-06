import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:somnio/core/error/failures.dart';
import 'package:somnio/features/auth/domain/usecases/login_usecase.dart';
import 'package:somnio/features/auth/presentation/cubit/login_cubit.dart';
import 'package:somnio/features/auth/presentation/cubit/login_state.dart';

import '../../../../helpers/helpers.dart';
import '../../../../helpers/mock_factories.dart';

void main() {
  late MockLoginUseCase mockLoginUseCase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockUserRepository = MockUserRepository();
  });

  setUpAll(() {
    registerFallbackValue(
      const LoginParams(email: '', password: ''),
    );
  });

  LoginCubit buildCubit() => LoginCubit(
        loginUseCase: mockLoginUseCase,
        userRepository: mockUserRepository,
      );

  group('$LoginCubit', () {
    test('initial state is $LoginState', () async {
      final cubit = buildCubit();
      expect(cubit.state, const LoginState());
      await cubit.close();
    });

    group('emailChanged', () {
      blocTest<LoginCubit, LoginState>(
        'emits updated email',
        build: buildCubit,
        act: (cubit) => cubit.emailChanged('test@example.com'),
        expect: () => [
          isA<LoginState>()
              .having(
                (s) => s.email,
                'email',
                const Email.dirty('test@example.com'),
              )
              .having((s) => s.isValid, 'isValid', isA<bool>()),
        ],
      );
    });

    group('passwordChanged', () {
      blocTest<LoginCubit, LoginState>(
        'emits updated password',
        build: buildCubit,
        act: (cubit) => cubit.passwordChanged('password123'),
        expect: () => [
          isA<LoginState>()
              .having(
                (s) => s.password,
                'password',
                const Password.dirty('password123'),
              )
              .having((s) => s.isValid, 'isValid', isA<bool>()),
        ],
      );
    });

    group('loginWithCredentials', () {
      blocTest<LoginCubit, LoginState>(
        'does nothing when form is invalid',
        build: buildCubit,
        seed: () => const LoginState(isValid: false),
        act: (cubit) => cubit.loginWithCredentials(),
        expect: () => <LoginState>[],
      );

      blocTest<LoginCubit, LoginState>(
        'emits inProgress then success on success',
        build: buildCubit,
        setUp: () {
          when(() => mockLoginUseCase(any()))
              .thenAnswer((_) async => const Right(TestFixtures.authTokens));
          when(
            () => mockUserRepository.login(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async {});
        },
        seed: () => const LoginState(
          email: Email.dirty('test@example.com'),
          password: Password.dirty('password123'),
        ),
        act: (cubit) => cubit.loginWithCredentials(),
        expect: () => [
          isA<LoginState>()
              .having((s) => s.status, 'status',
                  FormzSubmissionStatus.inProgress),
          isA<LoginState>()
              .having((s) => s.status, 'status',
                  FormzSubmissionStatus.success),
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'emits inProgress then failure on failure',
        build: buildCubit,
        setUp: () {
          when(() => mockLoginUseCase(any())).thenAnswer(
            (_) async => const Left(TestFixtures.authFailure),
          );
        },
        seed: () => const LoginState(
          email: Email.dirty('test@example.com'),
          password: Password.dirty('password123'),
        ),
        act: (cubit) => cubit.loginWithCredentials(),
        expect: () => [
          isA<LoginState>()
              .having((s) => s.status, 'status',
                  FormzSubmissionStatus.inProgress),
          isA<LoginState>()
              .having((s) => s.status, 'status',
                  FormzSubmissionStatus.failure)
              .having(
                (s) => s.failure,
                'failure',
                isA<AuthFailure>(),
              ),
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'emits success even when userRepository.login throws',
        build: buildCubit,
        setUp: () {
          when(() => mockLoginUseCase(any()))
              .thenAnswer((_) async => const Right(TestFixtures.authTokens));
          when(
            () => mockUserRepository.login(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenThrow(Exception('repo error'));
        },
        seed: () => const LoginState(
          email: Email.dirty('test@example.com'),
          password: Password.dirty('password123'),
        ),
        act: (cubit) => cubit.loginWithCredentials(),
        expect: () => [
          isA<LoginState>()
              .having((s) => s.status, 'status',
                  FormzSubmissionStatus.inProgress),
          isA<LoginState>()
              .having((s) => s.status, 'status',
                  FormzSubmissionStatus.success),
        ],
      );
    });
  });
}
