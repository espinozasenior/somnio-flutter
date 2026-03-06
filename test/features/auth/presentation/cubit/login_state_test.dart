import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:somnio/core/error/failures.dart';
import 'package:somnio/features/auth/presentation/cubit/login_state.dart';

void main() {
  group('$LoginState', () {
    test('has correct initial values', () {
      const state = LoginState();

      expect(state.email, const Email.pure());
      expect(state.password, const Password.pure());
      expect(state.status, FormzSubmissionStatus.initial);
      expect(state.isValid, true);
      expect(state.failure, isNull);
    });

    test('supports value equality', () {
      const state1 = LoginState();
      const state2 = LoginState();

      expect(state1, equals(state2));
    });

    test('copyWith returns updated state', () {
      const state = LoginState();
      final updated = state.copyWith(
        email: const Email.dirty('test@example.com'),
        status: FormzSubmissionStatus.inProgress,
      );

      expect(updated.email, const Email.dirty('test@example.com'));
      expect(updated.status, FormzSubmissionStatus.inProgress);
      expect(updated.password, const Password.pure());
    });

    test('copyWith with failure', () {
      const state = LoginState();
      const failure = AuthFailure(message: 'Bad', statusCode: 401);
      final updated = state.copyWith(failure: failure);

      expect(updated.failure, failure);
    });
  });
}
