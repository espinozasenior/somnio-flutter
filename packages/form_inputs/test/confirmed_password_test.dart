import 'package:form_inputs/form_inputs.dart';
import 'package:test/test.dart';

void main() {
  group('$ConfirmedPassword', () {
    test('pure has empty value', () {
      const input = ConfirmedPassword.pure();
      expect(input.value, '');
      expect(input.password, '');
      expect(input.isPure, true);
    });

    test('matching passwords return no error', () {
      const input = ConfirmedPassword.dirty(
        password: 'password123',
        value: 'password123',
      );
      expect(input.isValid, true);
      expect(input.error, isNull);
    });

    test('empty value returns error', () {
      const input = ConfirmedPassword.dirty(
        password: 'password123',
      );
      expect(
        input.error,
        ConfirmedPasswordValidationError.empty,
      );
    });

    test('mismatched passwords return mismatch error', () {
      const input = ConfirmedPassword.dirty(
        password: 'password123',
        value: 'different',
      );
      expect(
        input.error,
        ConfirmedPasswordValidationError.mismatch,
      );
    });
  });
}
