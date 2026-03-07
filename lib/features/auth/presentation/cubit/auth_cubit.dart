import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:somnio/core/usecase/usecase.dart';
import 'package:somnio/features/auth/domain/usecases/logout_usecase.dart';
import 'package:somnio/features/auth/presentation/cubit/auth_state.dart';
import 'package:user_repository/user_repository.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required UserRepository userRepository,
    required LogoutUseCase logoutUseCase,
  }) : _userRepository = userRepository,
       _logoutUseCase = logoutUseCase,
       super(const AuthState()) {
    _statusSubscription = _userRepository.status.listen(_onStatusChanged);
    _userSubscription = _userRepository.user.listen(_onUserChanged);
  }

  final UserRepository _userRepository;
  final LogoutUseCase _logoutUseCase;
  late final StreamSubscription<AuthStatus> _statusSubscription;
  late final StreamSubscription<User> _userSubscription;

  void _onStatusChanged(AuthStatus status) {
    emit(state.copyWith(status: status));
  }

  void _onUserChanged(User user) {
    emit(state.copyWith(user: user));
  }

  Future<void> logout() async {
    await _logoutUseCase(const NoParams());
  }

  @override
  Future<void> close() async {
    unawaited(_statusSubscription.cancel());
    unawaited(_userSubscription.cancel());
    return super.close();
  }
}
