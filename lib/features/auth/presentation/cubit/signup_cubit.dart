import 'package:bloc/bloc.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:somnio/features/auth/domain/usecases/register_usecase.dart';
import 'package:somnio/features/auth/presentation/cubit/signup_state.dart';
import 'package:user_repository/user_repository.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit({
    required RegisterUseCase registerUseCase,
    required UserRepository userRepository,
  })  : _registerUseCase = registerUseCase,
        _userRepository = userRepository,
        super(const SignupState());

  final RegisterUseCase _registerUseCase;
  final UserRepository _userRepository;

  void nameChanged(String value) {
    final name = NameInput.dirty(value);
    emit(
      state.copyWith(
        name: name,
        isValid: Formz.validate([
          name,
          state.email,
          state.password,
          state.confirmedPassword,
        ]),
      ),
    );
  }

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate([
          state.name,
          email,
          state.password,
          state.confirmedPassword,
        ]),
      ),
    );
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    final confirmedPassword = ConfirmedPassword.dirty(
      password: value,
      value: state.confirmedPassword.value,
    );
    emit(
      state.copyWith(
        password: password,
        confirmedPassword: confirmedPassword,
        isValid: Formz.validate([
          state.name,
          state.email,
          password,
          confirmedPassword,
        ]),
      ),
    );
  }

  void confirmedPasswordChanged(String value) {
    final confirmedPassword = ConfirmedPassword.dirty(
      password: state.password.value,
      value: value,
    );
    emit(
      state.copyWith(
        confirmedPassword: confirmedPassword,
        isValid: Formz.validate([
          state.name,
          state.email,
          state.password,
          confirmedPassword,
        ]),
      ),
    );
  }

  Future<void> signupWithCredentials() async {
    if (!state.isValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    final result = await _registerUseCase(
      RegisterParams(
        email: state.email.value,
        password: state.password.value,
        name: state.name.value,
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
          await _userRepository.register(
            email: state.email.value,
            password: state.password.value,
            name: state.name.value,
          );
        } on Exception catch (_) {
          // Token already saved by register use case
        }
        emit(state.copyWith(status: FormzSubmissionStatus.success));
      },
    );
  }
}
