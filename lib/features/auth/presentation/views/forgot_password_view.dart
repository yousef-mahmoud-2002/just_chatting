import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_chatting/features/auth/presentation/manager/auth/auth_cubit.dart';
import 'package:just_chatting/features/auth/presentation/views/widgets/custom_text_form_field.dart';
import 'package:just_chatting/features/auth/presentation/views/widgets/forgot_password_button.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const BackButton()),
      body: Form(
        autovalidateMode: AutovalidateMode.onUnfocus,
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Forgot Password",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Please enter your email and we will send \nyou a link to return to your account",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF757575)),
                ),
                const SizedBox(height: 64),
                CustomTextFormField(
                  label: 'Email',
                  icon: Icons.email_outlined,
                  focusNode: FocusNode(),
                  textInputType: TextInputType.emailAddress,
                  controller: emailController,
                ),
                const SizedBox(height: 24),
                ForgotPasswordButton(onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    context
                        .read<AuthCubit>()
                        .forgotPassword(context, emailController.text);
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
