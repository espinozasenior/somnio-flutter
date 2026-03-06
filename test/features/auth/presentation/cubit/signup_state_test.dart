import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:somnio/features/auth/presentation/cubit/signup_state.dart';

void main() {
  group('$SignupState', () {
    test('has correct initial values', () {
      const state = SignupState();

      expect(state.name, const NameInput.pure());
      expect(state.email, const Email.pure());
      expect(state.password, const Password.pure());
      expect(state.confirmedPassword, const ConfirmedPassword.pure());
      expect(state.status, FormzSubmissionStatus.initial);
      expect(state.isValid, true);
      expect(state.failure, isNull);
    });

    test('supports value equality', () {
      const state1 = SignupState();
      const state2 = SignupState();

      expect(state1, equals(state2));
    });

    test('copyWith returns updated state', () {
      const state = SignupState();
      final updated = state.copyWith(
        name: const NameInput.dirty('John'),
        email: const Email.dirty('john@example.com'),
      );

      expect(updated.name, const NameInput.dirty('John'));
      expect(updated.email, const Email.dirty('john@example.com'));
      expect(updated.password, const Password.pure());
    });
  });
}
