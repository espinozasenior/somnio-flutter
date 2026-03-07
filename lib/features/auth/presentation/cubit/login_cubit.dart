import 'package:bloc/bloc.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:somnio/features/auth/domain/usecases/login_usecase.dart';
import 'package:somnio/features/auth/presentation/cubit/login_state.dart';
import 'package:user_repository/user_repository.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required LoginUseCase loginUseCase,
    required UserRepository userRepository,
  }) : _loginUseCase = loginUseCase,
       _userRepository = userRepository,
       super(const LoginState());

  final LoginUseCase _loginUseCase;
  final UserRepository _userRepository;

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate([email, state.password]),
      ),
    );
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate([state.email, password]),
      ),
    );
  }

  Future<void> loginWithCredentials() async {
    if (!state.isValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    final result = await _loginUseCase(
      LoginParams(
        email: state.email.value,
        password: state.password.value,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          failure: failure,
        ),
      ),
      (_) async {
        try {
          await _userRepository.login(
            email: state.email.value,
            password: state.password.value,
          );
        } on Exception catch (_) {
          // Token already saved by login use case
        }
        emit(state.copyWith(status: FormzSubmissionStatus.success));
      },
    );
  }
}
