import 'package:form_inputs/form_inputs.dart';
import 'package:test/test.dart';

void main() {
  group('$Email', () {
    test('pure has empty value', () {
      const email = Email.pure();
      expect(email.value, '');
      expect(email.isPure, true);
    });

    test('dirty with valid email returns no error', () {
      const email = Email.dirty('test@example.com');
      expect(email.isValid, true);
      expect(email.error, isNull);
    });

    test('empty value returns EmailValidationError.empty', () {
      const email = Email.dirty();
      expect(email.error, EmailValidationError.empty);
      expect(email.isNotValid, true);
    });

    test('invalid format returns EmailValidationError.invalid', () {
      const email = Email.dirty('not-an-email');
      expect(email.error, EmailValidationError.invalid);
    });

    test('missing @ returns EmailValidationError.invalid', () {
      const email = Email.dirty('testexample.com');
      expect(email.error, EmailValidationError.invalid);
    });

    test('valid emails are accepted', () {
      const validEmails = [
        'user@example.com',
        'user.name@domain.co',
        'user+tag@sub.domain.com',
      ];
      for (final value in validEmails) {
        final email = Email.dirty(value);
        expect(email.isValid, true, reason: '$value should be valid');
      }
    });
  });
}
