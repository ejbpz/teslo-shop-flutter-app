import 'package:flutter/material.dart';
import 'package:teslo_shop/features/auth/presentation/providers/login_form_provider.dart';

class CustomErrorField extends StatelessWidget {
  final LoginFormState loginForm;
  final String type;

  const CustomErrorField({
    super.key, 
    required this.loginForm,
    required this.type
  });

  @override
  Widget build(BuildContext context) {
    final String errorMessage;

    if(type == 'Email') {
      errorMessage = loginForm.email.errorMessage ?? '';
    }
    else if(type == 'Password') {
      errorMessage = loginForm.password.errorMessage ?? '';
    } 
    else {
      errorMessage = '';
    }

    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        loginForm.isFormPosted && !loginForm.isValid
        ? errorMessage
        : '',
        
        style: TextStyle(color: Colors.red.shade800),
        textAlign: TextAlign.start,
      ),
    );
  }
}