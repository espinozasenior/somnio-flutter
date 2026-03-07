import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:somnio/core/usecase/usecase.dart';
import 'package:somnio/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:somnio/features/auth/presentation/cubit/auth_state.dart';
import 'package:user_repository/user_repository.dart';

import '../../../../helpers/mock_factories.dart';

void main() {
  late MockUserRepository mockUserRepository;
  late MockLogoutUseCase mockLogoutUseCase;
  late StreamController<AuthStatus> statusController;
  late StreamController<User> userController;

  setUp(() {
    mockUserRepository = MockUserRepository();
    mockLogoutUseCase = MockLogoutUseCase();
    statusController = StreamController<AuthStatus>.broadcast();
    userController = StreamController<User>.broadcast();

    when(
      () => mockUserRepository.status,
    ).thenAnswer((_) => statusController.stream);
    when(
      () => mockUserRepository.user,
    ).thenAnswer((_) => userController.stream);
  });

  tearDown(() async {
    await statusController.close();
    await userController.close();
  });

  setUpAll(() {
    registerFallbackValue(const NoParams());
  });

  AuthCubit buildCubit() => AuthCubit(
    userRepository: mockUserRepository,
    logoutUseCase: mockLogoutUseCase,
  );

  group('$AuthCubit', () {
    test('initial state is $AuthState with unknown status', () async {
      final cubit = buildCubit();
      expect(cubit.state, const AuthState());
      await cubit.close();
    });

    blocTest<AuthCubit, AuthState>(
      'emits updated status when status stream emits',
      build: buildCubit,
      act: (_) {
        statusController.add(AuthStatus.authenticated);
      },
      wait: const Duration(milliseconds: 10),
      expect: () => [
        const AuthState(status: AuthStatus.authenticated),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits updated user when user stream emits',
      build: buildCubit,
      act: (_) {
        userController.add(
          const User(id: '1', email: 'a@b.com', name: 'Test'),
        );
      },
      wait: const Duration(milliseconds: 10),
      expect: () => [
        const AuthState(
          user: User(id: '1', email: 'a@b.com', name: 'Test'),
        ),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'calls logout use case when logout is called',
      build: buildCubit,
      setUp: () {
        when(
          () => mockLogoutUseCase(any()),
        ).thenAnswer((_) async => const Right(unit));
      },
      act: (cubit) => cubit.logout(),
      verify: (_) {
        verify(() => mockLogoutUseCase(const NoParams())).called(1);
      },
    );
  });
}
