import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_chatting/constants.dart';
import '../manager/auth/auth_cubit.dart';
import 'widgets/back_to_login_button.dart';
import 'widgets/custom_text_form_field.dart';
import 'widgets/register_button.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUnfocus,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 30,
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: Image.asset(
                      'assets/register_illustration.png',
                    ),
                  ),
                  const SizedBox(height: 24),
                  CustomTextFormField(
                    icon: Icons.person_outline,
                    controller: nameController,
                    label: 'Name',
                    textInputType: TextInputType.text,
                  ),
                  const SizedBox(height: 24),
                  CustomTextFormField(
                    icon: Icons.email_outlined,
                    controller: emailController,
                    label: 'Email',
                    textInputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 24),
                  CustomSecureTextFormField(
                    icon: Icons.lock_outline,
                    controller: passwordController,
                    label: 'Password',
                  ),
                  const SizedBox(height: 24),
                  RegisterButton(
                    onPressed: () {
                      if (formKey.currentState?.validate() ?? false) {
                        BlocProvider.of<AuthCubit>(context).createAccount(
                          context,
                          email: emailController.text.trim(),
                          name: nameController.text.trim(),
                          password: passwordController.text.trim(),
                        );
                      }
                    },
                  ),
                  const BackToLoginButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
