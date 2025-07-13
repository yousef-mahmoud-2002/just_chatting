import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_chatting/constants.dart';
import 'package:just_chatting/features/auth/presentation/manager/auth/auth_cubit.dart';

class RegisterButton extends StatelessWidget {
  const RegisterButton({super.key, required this.onPressed});

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is CreateLoading) {
          return const CircularProgressIndicator(color: kPrimaryColor);
        } else {
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
                'Create Account',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
