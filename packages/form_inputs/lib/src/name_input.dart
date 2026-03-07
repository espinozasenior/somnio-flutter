import 'package:formz/formz.dart';

enum NameInputValidationError { empty, tooShort }

class NameInput extends FormzInput<String, NameInputValidationError> {
  const NameInput.pure() : super.pure('');
  const NameInput.dirty([super.value = '']) : super.dirty();

  @override
  NameInputValidationError? validator(String value) {
    if (value.isEmpty) return NameInputValidationError.empty;
    if (value.length < 2) return NameInputValidationError.tooShort;
    return null;
  }
}
