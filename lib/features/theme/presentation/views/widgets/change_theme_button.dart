import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_chatting/features/theme/presentation/manager/theme/theme_cubit.dart';

class ChangeThemeButton extends StatelessWidget {
  const ChangeThemeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeCubit>().state;

    return IconButton(
      icon: Icon(
        themeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode,
        color: themeMode == ThemeMode.light ? Colors.black : Colors.amber,
      ),
      onPressed: () => context.read<ThemeCubit>().toggleTheme(),
    );
  }
}
