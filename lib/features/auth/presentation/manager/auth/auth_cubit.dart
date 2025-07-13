import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_chatting/core/utils/animate_navigation_route.dart';
import 'package:just_chatting/core/widgets/login_dialog.dart';
import 'package:just_chatting/features/auth/data/models/user_model.dart';
import 'package:just_chatting/features/auth/presentation/views/login_view.dart';
import 'package:just_chatting/features/home/presentation/views/home_view.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(LoginInitial());

  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  void createAccount(context, UserModel user, String password) async {
    emit(CreateLoading());

    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      );

      await firestore.collection('users').doc(credential.user!.uid).set({
        'uid': credential.user!.uid,
        'name': user.name,
        'email': user.email,
        'profileImage': user.profileImage,
      });

      // Caching.keepLoggedIn();
      emit(CreateSuccess());
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
            context, animateRoute(const HomeView()), (_) => false);
        loginDialog(context, 'your account has been created successfully');
      }
    } on FirebaseAuthException catch (e) {
      emit(CreateFailure());
      if (e.code == 'weak-password') {
        loginDialog(context, 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        loginDialog(context, 'The account already exists for that email.');
      } else {
        loginDialog(context, e.code);
      }
    } catch (e) {
      emit(CreateFailure());
      loginDialog(context, e.toString());
    }
  }

  void login(context, String password, String email) async {
    emit(LoginLoading());
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Caching.keepLoggedIn();
      emit(LoginSuccess());
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
            context, animateRoute(const HomeView()), (_) => false);
        loginDialog(context, 'logged in successfully');
      }
    } on FirebaseAuthException {
      emit(LoginFailure());

      if (context.mounted) {
        loginDialog(context, 'Email or password is incorrect');
      }
    } catch (e) {
      emit(LoginFailure());
      loginDialog(context, e.toString());
    }
  }

  void logout(context) async {
    try {
      await auth.signOut();
      // await Caching.clear();

      // BlocProvider.of<ProfileCubit>(context).user =
      //     UserModel(email: '', image: kProfilePicture, spins: 0, money: 0);
      Navigator.pushAndRemoveUntil(
        context,
        animateRoute(const LoginView(), startIndex: -2),
        (Route route) => false,
      );

      Future.delayed(const Duration(milliseconds: 300), () {
        loginDialog(context, 'logged out successfully');
      });
    } catch (e) {
      loginDialog(context, e.toString());
    }
  }

  void forgotPassword(context, String email) async {
    try {
      auth.setLanguageCode('ar');
      await auth.sendPasswordResetEmail(email: email);

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Your password reset link has been sent to your email address, please check your inbox',
            textAlign: TextAlign.center,
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Try to use valid email';
      if (e.code == 'user-not-found') {
        message = 'There is no user such that email';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message, textAlign: TextAlign.center)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString(), textAlign: TextAlign.center)),
      );
    }
  }
}
