import 'package:formz/formz.dart';

enum SlugError { empty, format }
class Slug extends FormzInput<String, SlugError> {
  const Slug.pure() : super.pure('');

  const Slug.dirty( String value ) : super.dirty(value);

  String? get errorMessage {
    if(isValid || isPure) return null;
    if(displayError == SlugError.empty) return 'This field is required.';
    if(displayError == SlugError.format) return 'This field doesn\'t have the required format.';

    return null;
  }

  @override
  SlugError? validator(String value) {
    if(value.isEmpty || value.trim().isEmpty) return SlugError.empty;
    if(value.contains("'") || value.contains(' ')) return SlugError.format;

    return null;
  }
}