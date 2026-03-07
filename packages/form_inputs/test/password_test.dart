import 'package:form_inputs/form_inputs.dart';
import 'package:test/test.dart';

void main() {
  group('$Password', () {
    test('pure has empty value', () {
      const password = Password.pure();
      expect(password.value, '');
      expect(password.isPure, true);
    });

    test('valid password with 8+ chars returns no error', () {
      const password = Password.dirty('password123');
      expect(password.isValid, true);
      expect(password.error, isNull);
    });

    test('empty value returns PasswordValidationError.empty', () {
      const password = Password.dirty();
      expect(password.error, PasswordValidationError.empty);
    });

    test('short password returns PasswordValidationError.tooShort', () {
      const password = Password.dirty('1234567');
      expect(password.error, PasswordValidationError.tooShort);
    });

    test('exactly 8 chars is valid', () {
      const password = Password.dirty('12345678');
      expect(password.isValid, true);
    });
  });
}
