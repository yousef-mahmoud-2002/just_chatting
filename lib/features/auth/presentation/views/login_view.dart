import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:just_chatting/constants.dart';
import '../manager/auth/auth_cubit.dart';
import 'widgets/go_to_register_button.dart';
import 'widgets/custom_text_form_field.dart';
import 'widgets/go_to_forgot_password_view.dart';
import 'widgets/login_button.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final formKey = GlobalKey<FormState>();

  FocusNode emailFocusNode = FocusNode();
  TextEditingController emailController = TextEditingController();

  FocusNode passwordFocusNode = FocusNode();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    emailController.dispose();
    passwordController.dispose();
    formKey.currentState?.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    'Login',
                    style: TextStyle(
                      fontSize: 30,
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 300,
                    child: Image.asset(
                      'assets/login_illustration.png',
                    ),
                  ),
                  Column(
                    children: [
                      CustomTextFormField(
                        focusNode: emailFocusNode,
                        controller: emailController,
                        icon: Icons.email_outlined,
                        label: 'Email',
                        textInputType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 24),
                      CustomSecureTextFormField(
                        focusNode: passwordFocusNode,
                        controller: passwordController,
                        icon: Icons.lock_outline,
                        label: 'Password',
                      ),
                      const GoToForgotPasswordView(),
                      const SizedBox(height: 16),
                      LoginButton(
                        onPressed: () async {
                          emailFocusNode.unfocus();
                          passwordFocusNode.unfocus();

                          if (formKey.currentState?.validate() ?? false) {
                            BlocProvider.of<AuthCubit>(context).login(
                              context,
                              password: passwordController.text.trim(),
                              email: emailController.text.trim(),
                            );
                          }
                        },
                      ),
                      const GoToRegisterButton(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
