import 'package:form_inputs/form_inputs.dart';
import 'package:test/test.dart';

void main() {
  group('$NameInput', () {
    test('pure has empty value', () {
      const input = NameInput.pure();
      expect(input.value, '');
      expect(input.isPure, true);
    });

    test('valid name with 2+ chars returns no error', () {
      const input = NameInput.dirty('John');
      expect(input.isValid, true);
      expect(input.error, isNull);
    });

    test('empty value returns NameInputValidationError.empty', () {
      const input = NameInput.dirty();
      expect(input.error, NameInputValidationError.empty);
    });

    test('single char returns NameInputValidationError.tooShort', () {
      const input = NameInput.dirty('A');
      expect(input.error, NameInputValidationError.tooShort);
    });

    test('exactly 2 chars is valid', () {
      const input = NameInput.dirty('Jo');
      expect(input.isValid, true);
    });
  });
}
