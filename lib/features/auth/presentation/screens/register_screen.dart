import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/features/auth/auth.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/auth/presentation/providers/register_form_provider.dart';
import 'package:teslo_shop/features/shared/shared.dart';


class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textStyles = Theme.of(context).textTheme;

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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: (){
                        context.go('/login');
                      }, 
                      icon: const Icon( Icons.navigate_before, size: 40, color: Colors.white )
                    ),
                    const Spacer(flex: 1),
                    Text('Sign Up', style: textStyles.titleLarge?.copyWith(color: Colors.white )),
                    const Spacer(flex: 2),
                  ],
                ),

                const SizedBox( height: 50 ),
    
                Container(
                  height: size.height - 260,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(100)),
                  ),
                  child: const _RegisterForm(),
                )
              ],
            ),
          )
        )
      ),
    );
  }
}

class _RegisterForm extends ConsumerWidget {
  const _RegisterForm();

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
    final registerForm = ref.watch(registerFormProvider);

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
            child: Text('New account', style: textStyles.titleMedium, textAlign: TextAlign.center),
          ),

          const SizedBox( height: 50 ),

          CustomTextFormField(
            label: 'Full name',
            icon: Icons.person_2_outlined,
            keyboardType: TextInputType.name,
            onChanged: ref.read(registerFormProvider.notifier).onFullnameChange,
          ),

          const SizedBox( height: 3 ),
          CustomErrorField(form: registerForm, errorMessage: registerForm.fullname.errorMessage),
          const SizedBox( height: 13 ),

          CustomTextFormField(
            label: 'Email',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            onChanged: ref.read(registerFormProvider.notifier).onEmailChange,
          ),

          const SizedBox( height: 3 ),
          CustomErrorField(form: registerForm, errorMessage: registerForm.email.errorMessage),
          const SizedBox( height: 13 ),

          CustomTextFormField(
            label: 'Password',
            icon: Icons.lock_outline,
            obscureText: true,
            onChanged: ref.read(registerFormProvider.notifier).onPasswordChange,
          ),
    
          const SizedBox( height: 3 ),
          CustomErrorField(form: registerForm, errorMessage: registerForm.password.errorMessage),
          const SizedBox( height: 13 ),

          CustomTextFormField(
            label: 'Confirm password',
            icon: Icons.lock_outline,
            obscureText: true,
            onChanged: ref.read(registerFormProvider.notifier).onRepeatPasswordChange,
            onFieldSubmitted: (_) => ref.read(registerFormProvider.notifier).onFormSubmit(),
          ),

          const SizedBox( height: 3 ),
          CustomErrorField(form: registerForm, errorMessage: registerForm.repeatPassword.errorMessage),
    
          const SizedBox( height: 30 ),

          SizedBox(
            width: double.infinity,
            height: 60,
            child: CustomFilledButton(
              text: !registerForm.isPosting 
                ? 'Sign Up'
                : 'Loading...',
              buttonColor: Colors.black,
              onPressed: () async {
                if(!registerForm.isPosting) {
                  CustomError? errorMessage = await ref.read(registerFormProvider.notifier).onFormSubmit();
                  
                  if(errorMessage != null && context.mounted) {
                    showSnackbar(context, errorMessage.message);
                  } 
                  
                  if(errorMessage == null && context.mounted) {
                    context.go('/login');
                  }
                }
              },
            )
          ),

          const Spacer( flex: 2 ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Already have an account?'),
              TextButton(
                onPressed: () => context.go('/login'), 
                child: const Text('Login')
              )
            ],
          ),

          const Spacer( flex: 1),
        ],
      ),
    );
  }
}