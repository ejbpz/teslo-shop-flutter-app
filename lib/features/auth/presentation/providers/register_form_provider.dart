import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/auth/infrastructure/errors/auth_errors.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/shared/infrastructure/inputs/inputs.dart';

final registerFormProvider = StateNotifierProvider<RegisterFormNotifier, RegisterFormState>((ref) {
  final registerUserCallback = ref.watch(authProvider.notifier).registerUser;
  return RegisterFormNotifier(registerUserCallback: registerUserCallback);
});

class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  Function(String, String, String) registerUserCallback;

  RegisterFormNotifier({required this.registerUserCallback}): super(RegisterFormState());
  
  onEmailChange(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([newEmail, state.password, state.fullname, state.repeatPassword])
    );
  } 

  onRepeatPasswordChange(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      repeatPassword: newPassword,
      isValid: Formz.validate([newPassword, state.email, state.fullname, state.password])
    );
  }

  onPasswordChange(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([newPassword, state.email, state.fullname, state.repeatPassword])
    );
  }

  onFullnameChange(String value) {
    final newFullname = Fullname.dirty(value);
    state = state.copyWith(
      fullname: newFullname,
      isValid: Formz.validate([newFullname, state.email, state.password, state.repeatPassword])
    );
  }

  onFormSubmit() async {
    _touchEveryField();
    if(!state.isValid) return;
    if(state.password.value != state.repeatPassword.value) return CustomError('Password doesn\'t match.');
    await registerUserCallback(state.email.value, state.password.value, state.fullname.value);
  }

  _touchEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final repeatPassword = Password.dirty(state.repeatPassword.value);
    final fullname = Fullname.dirty(state.fullname.value);

    state = state.copyWith(
      isFormPosted: true,
      email: email,
      password: password,
      repeatPassword: repeatPassword,
      fullname: fullname,
      isValid: Formz.validate([email, password, fullname, repeatPassword])
    );
  }
}

class RegisterFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Fullname fullname;
  final Email email;
  final Password password;
  final Password repeatPassword;

  RegisterFormState({
    this.isPosting = false, 
    this.isFormPosted = false, 
    this.isValid = false, 
    this.fullname = const Fullname.pure(), 
    this.email = const Email.pure(), 
    this.password = const Password.pure(),
    this.repeatPassword = const Password.pure()
  });

  RegisterFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Fullname? fullname,
    Email? email,
    Password? password,
    Password? repeatPassword,
  }) => RegisterFormState(
    isPosting: isPosting ?? this.isPosting,
    isFormPosted: isFormPosted ?? this.isFormPosted,
    isValid: isValid ?? this.isValid,
    fullname: fullname ?? this.fullname,
    email: email ?? this.email,
    password: password ?? this.password,
    repeatPassword: repeatPassword ?? this.repeatPassword,
  );
}