import 'package:flutter/material.dart';
import 'package:just_chatting/constants.dart';
import 'package:just_chatting/core/utils/animate_navigation_route.dart';
import 'package:just_chatting/features/auth/presentation/views/register_view.dart';

class GoToRegisterButton extends StatelessWidget {
  const GoToRegisterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Don\'t have an account ?',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              animateRoute(const RegisterView(), startIndex: -2),
            );
          },
          child: const Text(
            'Create Account',
            style: TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
