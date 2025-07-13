import 'package:flutter/material.dart';
import 'package:just_chatting/constants.dart';
import 'package:just_chatting/core/utils/animate_navigation_route.dart';
import 'package:just_chatting/features/auth/presentation/views/forgot_password_view.dart';

class GoToForgotPasswordView extends StatelessWidget {
  const GoToForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: TextButton(
        style: TextButton.styleFrom(
          minimumSize: Size.zero,
          padding: const EdgeInsets.all(8),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: () {
          Navigator.push(
            context,
            animateRoute(const ForgotPasswordView(), startIndex: -2),
          );
        },
        child: const Text(
          'Forgot Password ?',
          style: TextStyle(
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
