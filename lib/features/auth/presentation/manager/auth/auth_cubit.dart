import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_chatting/constants.dart';
import 'package:just_chatting/core/utils/animate_navigation_route.dart';
import 'package:just_chatting/core/widgets/app_snack_bar.dart';
import 'package:just_chatting/features/auth/presentation/views/login_view.dart';
import 'package:just_chatting/features/chat/presentation/manager/chat/chat_cubit.dart';
import 'package:just_chatting/features/home/presentation/views/home_view.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(LoginInitial());

  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  String userId = '';

  void createAccount(
    BuildContext context, {
    required String email,
    required String password,
    required String name,
  }) async {
    emit(CreateLoading());

    try {
      final credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      userId = credential.user!.uid;
      if (context.mounted) {
        context.read<ChatCubit>().setSenderId(userId);
        context.read<ChatCubit>().senderName = name;
      }

      await firestore.collection('users').doc(userId).set({
        'uid': userId,
        'name': name,
        'email': email,
        'profileImage': kDefaultProfilePic,
      });

      emit(CreateSuccess());
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
            context, animateRoute(const HomeView()), (_) => false);
        appSnackBar(context, 'your account has been created successfully');
      }
    } on FirebaseAuthException catch (e) {
      emit(CreateFailure());
      if (context.mounted) {
        final message = switch (e.code) {
          'weak-password' => 'The password provided is too weak.',
          'email-already-in-use' =>
            'The account already exists for that email.',
          _ => e.code
        };

        appSnackBar(context, message);
      }
    } catch (e) {
      emit(CreateFailure());
      if (context.mounted) {
        appSnackBar(context, e.toString());
      }
    }
  }

  void login(
    BuildContext context, {
    required String password,
    required String email,
  }) async {
    emit(LoginLoading());
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);

      userId = auth.currentUser!.uid;

      if (context.mounted) {
        context.read<ChatCubit>().setSenderId(userId);
        context.read<ChatCubit>().senderName = auth.currentUser!.displayName!;
      }

      emit(LoginSuccess());
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
            context, animateRoute(const HomeView()), (_) => false);
        appSnackBar(context, 'logged in successfully');
      }
    } on FirebaseAuthException {
      emit(LoginFailure());

      if (context.mounted) {
        appSnackBar(context, 'Email or password is incorrect');
      }
    } catch (e) {
      emit(LoginFailure());
      if (context.mounted) {
        appSnackBar(context, e.toString());
      }
    }
  }

  Future<void> logout(context) async {
    try {
      await auth.signOut();

      Navigator.pushAndRemoveUntil(
        context,
        animateRoute(const LoginView(), startIndex: -2),
        (Route route) => true,
      );

      Future.delayed(const Duration(milliseconds: 300), () {
        appSnackBar(context, 'logged out successfully');
      });
    } catch (e) {
      appSnackBar(context, e.toString());
    }
  }

  void forgotPassword(context, String email) async {
    try {
      auth.setLanguageCode('ar');
      await auth.sendPasswordResetEmail(email: email);

      Navigator.pop(context);
      appSnackBar(context,
          'Your password reset link has been sent to your email address, please check your inbox');
    } on FirebaseAuthException catch (e) {
      final message = e.code == 'user-not-found'
          ? 'There is no user such that email'
          : 'Try to use valid email';
      appSnackBar(context, message);
    } catch (e) {
      appSnackBar(context, e.toString());
    }
  }

  Future<void> updateName(context, String newName) async {
    if (newName.isEmpty) {
      appSnackBar(context, 'Write a new name');
      return;
    }

    try {
      await auth.currentUser!.updateDisplayName(newName);

      await firestore.collection('users').doc(auth.currentUser!.uid).update({
        'name': newName,
      });
      appSnackBar(context, 'Name has been updated successfully');
    } catch (e) {
      appSnackBar(context, e.toString());
    }
  }

  Future<void> updatePassword(
    context,
    String currentPass,
    String newPass,
  ) async {
    if (currentPass.isEmpty || newPass.isEmpty) {
      appSnackBar(context, 'Write current and new password');
      return;
    }

    try {
      final cred = EmailAuthProvider.credential(
        email: auth.currentUser!.email!,
        password: currentPass,
      );
      await auth.currentUser!.reauthenticateWithCredential(cred);

      await auth.currentUser!.updatePassword(newPass);
      appSnackBar(context, 'Password has been updated successfully');
    } on FirebaseAuthException catch (e) {
      appSnackBar(context, e.message ?? e.code);
    } catch (e) {
      appSnackBar(context, e.toString());
    }
  }

  Future<void> deleteAccount(context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('Are you sure you want to delete your account?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('delete')),
        ],
      ),
    );
    if (confirm != true) return;

    final currentPass = await showDialog<String?>(
      context: context,
      builder: (_) {
        final ctrl = TextEditingController();
        return AlertDialog(
          title: const Text('Write your current password'),
          content: TextField(
            controller: ctrl,
            obscureText: true,
            decoration: const InputDecoration(hintText: 'Password'),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, null),
                child: const Text('cancel')),
            TextButton(
                onPressed: () => Navigator.pop(context, ctrl.text),
                child: const Text('delete')),
          ],
        );
      },
    );
    if (currentPass == null || currentPass.isEmpty) return;

    try {
      final credential = EmailAuthProvider.credential(
        email: auth.currentUser!.email!,
        password: currentPass,
      );
      await auth.currentUser!.reauthenticateWithCredential(credential);

      await firestore.collection('users').doc(auth.currentUser!.uid).delete();

      await auth.currentUser!.delete();

      Navigator.pushAndRemoveUntil(
        context,
        animateRoute(const LoginView(), startIndex: -2),
        (Route route) => true,
      );

      Future.delayed(const Duration(milliseconds: 300), () {
        appSnackBar(context, 'Account has been deleted successfully');
      });
    } on FirebaseAuthException catch (e) {
      appSnackBar(context, e.message ?? e.code);
    } catch (e) {
      appSnackBar(context, e.toString());
    }
  }
}
