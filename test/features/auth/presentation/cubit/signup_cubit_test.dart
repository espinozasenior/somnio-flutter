import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:somnio/core/error/failures.dart';
import 'package:somnio/features/auth/domain/usecases/register_usecase.dart';
import 'package:somnio/features/auth/presentation/cubit/signup_cubit.dart';
import 'package:somnio/features/auth/presentation/cubit/signup_state.dart';

import '../../../../helpers/helpers.dart';
import '../../../../helpers/mock_factories.dart';

void main() {
  late MockRegisterUseCase mockRegisterUseCase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockRegisterUseCase = MockRegisterUseCase();
    mockUserRepository = MockUserRepository();
  });

  setUpAll(() {
    registerFallbackValue(
      const RegisterParams(email: '', password: '', name: ''),
    );
  });

  SignupCubit buildCubit() => SignupCubit(
        registerUseCase: mockRegisterUseCase,
        userRepository: mockUserRepository,
      );

  group('$SignupCubit', () {
    test('initial state is $SignupState', () async {
      final cubit = buildCubit();
      expect(cubit.state, const SignupState());
      await cubit.close();
    });

    group('nameChanged', () {
      blocTest<SignupCubit, SignupState>(
        'emits updated name',
        build: buildCubit,
        act: (cubit) => cubit.nameChanged('John'),
        expect: () => [
          isA<SignupState>().having(
            (s) => s.name,
            'name',
            const NameInput.dirty('John'),
          ),
        ],
      );
    });

    group('emailChanged', () {
      blocTest<SignupCubit, SignupState>(
        'emits updated email',
        build: buildCubit,
        act: (cubit) => cubit.emailChanged('test@example.com'),
        expect: () => [
          isA<SignupState>().having(
            (s) => s.email,
            'email',
            const Email.dirty('test@example.com'),
          ),
        ],
      );
    });

    group('passwordChanged', () {
      blocTest<SignupCubit, SignupState>(
        'emits updated password and confirmedPassword',
        build: buildCubit,
        act: (cubit) => cubit.passwordChanged('password123'),
        expect: () => [
          isA<SignupState>().having(
            (s) => s.password,
            'password',
            const Password.dirty('password123'),
          ),
        ],
      );
    });

    group('confirmedPasswordChanged', () {
      blocTest<SignupCubit, SignupState>(
        'emits updated confirmedPassword',
        build: buildCubit,
        seed: () => const SignupState(
          password: Password.dirty('password123'),
        ),
        act: (cubit) => cubit.confirmedPasswordChanged('password123'),
        expect: () => [
          isA<SignupState>().having(
            (s) => s.confirmedPassword,
            'confirmedPassword',
            const ConfirmedPassword.dirty(
              password: 'password123',
              value: 'password123',
            ),
          ),
        ],
      );
    });

    group('signupWithCredentials', () {
      blocTest<SignupCubit, SignupState>(
        'does nothing when form is invalid',
        build: buildCubit,
        seed: () => const SignupState(isValid: false),
        act: (cubit) => cubit.signupWithCredentials(),
        expect: () => <SignupState>[],
      );

      blocTest<SignupCubit, SignupState>(
        'emits inProgress then success on success',
        build: buildCubit,
        setUp: () {
          when(() => mockRegisterUseCase(any()))
              .thenAnswer((_) async => const Right(TestFixtures.authTokens));
          when(
            () => mockUserRepository.register(
              email: any(named: 'email'),
              password: any(named: 'password'),
              name: any(named: 'name'),
            ),
          ).thenAnswer((_) async {});
        },
        seed: () => const SignupState(
          name: NameInput.dirty('Test'),
          email: Email.dirty('test@example.com'),
          password: Password.dirty('password123'),
          confirmedPassword: ConfirmedPassword.dirty(
            password: 'password123',
            value: 'password123',
          ),
        ),
        act: (cubit) => cubit.signupWithCredentials(),
        expect: () => [
          isA<SignupState>().having(
            (s) => s.status,
            'status',
            FormzSubmissionStatus.inProgress,
          ),
          isA<SignupState>().having(
            (s) => s.status,
            'status',
            FormzSubmissionStatus.success,
          ),
        ],
      );

      blocTest<SignupCubit, SignupState>(
        'emits inProgress then failure on failure',
        build: buildCubit,
        setUp: () {
          when(() => mockRegisterUseCase(any())).thenAnswer(
            (_) async => const Left(TestFixtures.authFailure),
          );
        },
        seed: () => const SignupState(
          name: NameInput.dirty('Test'),
          email: Email.dirty('test@example.com'),
          password: Password.dirty('password123'),
          confirmedPassword: ConfirmedPassword.dirty(
            password: 'password123',
            value: 'password123',
          ),
        ),
        act: (cubit) => cubit.signupWithCredentials(),
        expect: () => [
          isA<SignupState>().having(
            (s) => s.status,
            'status',
            FormzSubmissionStatus.inProgress,
          ),
          isA<SignupState>()
              .having(
                (s) => s.status,
                'status',
                FormzSubmissionStatus.failure,
              )
              .having(
                (s) => s.failure,
                'failure',
                isA<AuthFailure>(),
              ),
        ],
      );

      blocTest<SignupCubit, SignupState>(
        'emits success even when userRepository.register throws',
        build: buildCubit,
        setUp: () {
          when(() => mockRegisterUseCase(any())).thenAnswer(
            (_) async => const Right(TestFixtures.authTokens),
          );
          when(
            () => mockUserRepository.register(
              email: any(named: 'email'),
              password: any(named: 'password'),
              name: any(named: 'name'),
            ),
          ).thenThrow(Exception('repo error'));
        },
        seed: () => const SignupState(
          name: NameInput.dirty('Test'),
          email: Email.dirty('test@example.com'),
          password: Password.dirty('password123'),
          confirmedPassword: ConfirmedPassword.dirty(
            password: 'password123',
            value: 'password123',
          ),
        ),
        act: (cubit) => cubit.signupWithCredentials(),
        expect: () => [
          isA<SignupState>().having(
            (s) => s.status,
            'status',
            FormzSubmissionStatus.inProgress,
          ),
          isA<SignupState>().having(
            (s) => s.status,
            'status',
            FormzSubmissionStatus.success,
          ),
        ],
      );
    });
  });
}
