import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/auth/presentation/providers/login_form_provider.dart';
import 'package:teslo_shop/features/shared/shared.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: GeometricalBackground( 
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox( height: 80 ),
                // Icon Banner
                const Icon( 
                  Icons.production_quantity_limits_rounded, 
                  color: Colors.white,
                  size: 100,
                ),
                const SizedBox( height: 80 ),
    
                Container(
                  height: size.height - 260,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(100)),
                  ),
                  child: const _LoginForm(),
                )
              ],
            ),
          )
        )
      ),
    );
  }
}

class _LoginForm extends ConsumerWidget {
  const _LoginForm();
  
  void showSnackbar(BuildContext context, String errorMessage) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage)
      )
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginForm = ref.watch(loginFormProvider);

    ref.listen(authProvider, (previous, next) {
      if(next.errorMessage.isEmpty) return;

      showSnackbar(context, next.errorMessage);
    });

    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox( height: 50 ),
          Container(
            width: double.infinity,
            alignment: AlignmentDirectional.center,
            child: Text('Login', style: textStyles.titleLarge, textAlign: TextAlign.center),
          ),

          const SizedBox( height: 90 ),

          CustomTextFormField(
            label: 'Email',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            onChanged: ref.read(loginFormProvider.notifier).onEmailChange,
          ),

          const SizedBox( height: 3 ),
          CustomErrorField(form: loginForm, errorMessage: loginForm.email.errorMessage),
          const SizedBox( height: 13 ),


          CustomTextFormField(
            label: 'Password',
            icon: Icons.lock_outline,
            obscureText: true,
            onChanged: ref.read(loginFormProvider.notifier).onPasswordChange,
            onFieldSubmitted: (_) => ref.read(loginFormProvider.notifier).onFormSubmit(),
          ),
    
          const SizedBox( height: 3 ),
          CustomErrorField(form: loginForm, errorMessage: loginForm.password.errorMessage),
          const SizedBox( height: 30 ),

          SizedBox(
            width: double.infinity,
            height: 60,
            child: CustomFilledButton(
              text: !loginForm.isPosting 
                ? 'Login'
                : 'Loading...',
              buttonColor: Colors.black,
              onPressed: loginForm.isPosting 
                ? null
                : ref.read(loginFormProvider.notifier).onFormSubmit
            )
          ),

          const Spacer( flex: 2 ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have an account?"),
              TextButton(
                onPressed: () => context.go('/register'), 
                child: const Text('Sign Up')
              )
            ],
          ),

          const Spacer( flex: 1),
        ],
      ),
    );
  }
}