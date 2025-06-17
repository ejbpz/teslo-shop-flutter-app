import 'package:formz/formz.dart';

enum FullnameError {empty, format}

class Fullname extends FormzInput<String, FullnameError> {
  static final RegExp fullNameRegExp = RegExp(
    r'([a-zA-Z]+) ([a-zA-Z]+)',
  );

  const Fullname.pure() : super.pure('');

  const Fullname.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if ( isValid || isPure ) return null;
    if ( displayError == FullnameError.empty ) return 'This field is required.';
    if ( displayError == FullnameError.format ) return 'Doesn\'t match a name.';

    return null;
  }

  @override
  FullnameError? validator(String value) {
    if(value.isEmpty || value.trim().isEmpty) return FullnameError.empty;
    if(!fullNameRegExp.hasMatch(value)) return FullnameError.format;

    return null;
  }
}