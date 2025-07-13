import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_chatting/constants.dart';
import 'package:just_chatting/core/utils/firebase_options.dart';
import 'package:just_chatting/features/auth/presentation/manager/auth/auth_cubit.dart';
import 'package:just_chatting/features/auth/presentation/views/login_view.dart';
import 'package:just_chatting/features/check_internet/presentation/manager/internet_cubit/internet_cubit.dart';
import 'package:just_chatting/features/check_internet/presentation/views/no_internet_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const JustChatting());
}

class JustChatting extends StatelessWidget {
  const JustChatting({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => InternetCubit()..checkInternet(),
        ),
        BlocProvider(
          create: (context) => AuthCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Just Chatting',
        theme: ThemeData(
          useMaterial3: false,
          primarySwatch: kPrimaryColor,
          // scaffoldBackgroundColor: Colors.white,
          // brightness: Brightness.dark,
        ),
        home: BlocBuilder<InternetCubit, InternetState>(
          builder: (context, state) {
            if (state is InternetNotConnected) {
              return const NoInternetView();
            } else {
              return const LoginView();
            }
          },
        ),
      ),
    );
  }
}
