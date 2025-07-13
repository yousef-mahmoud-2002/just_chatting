import 'package:flutter/material.dart';
import 'package:just_chatting/constants.dart';

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({super.key, this.onPressed});

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          shadowColor: kPrimaryColor,
          elevation: 12,
        ),
        child: const Text(
          'Send Link',
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
