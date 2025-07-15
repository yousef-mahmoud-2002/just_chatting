import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_chatting/core/utils/firebase_options.dart';
import 'package:just_chatting/features/auth/presentation/manager/auth/auth_cubit.dart';
import 'package:just_chatting/features/auth/presentation/views/login_view.dart';
import 'package:just_chatting/features/chat/presentation/manager/chat/chat_cubit.dart';
import 'package:just_chatting/features/check_internet/presentation/manager/internet_cubit/internet_cubit.dart';
import 'package:just_chatting/features/check_internet/presentation/views/no_internet_view.dart';
import 'package:just_chatting/features/theme/presentation/manager/theme/theme_cubit.dart';
import 'package:just_chatting/features/theme/presentation/views/widgets/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => InternetCubit()..checkInternet()),
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => ChatCubit()),
      ],
      child: const JustChatting(),
    ),
  );
}

class JustChatting extends StatelessWidget {
  const JustChatting({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Just Chatting',
          themeMode: themeMode,
          theme: lightTheme,
          darkTheme: darkTheme,
          home: const LoginView(),
          builder: (context, child) {
            return Stack(
              children: [
                child!,
                BlocBuilder<InternetCubit, InternetState>(
                  builder: (context, state) {
                    if (state is InternetNotConnected) {
                      return const NoInternetView();
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
