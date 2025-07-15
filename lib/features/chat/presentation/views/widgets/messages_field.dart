import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_chatting/constants.dart';
import 'package:just_chatting/features/chat/presentation/manager/chat/chat_cubit.dart';

class MessagesField extends StatelessWidget {
  const MessagesField({super.key, required this.chatId});

  final String chatId;

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: TextField(
        controller: controller,
        onSubmitted: (value) {
          context.read<ChatCubit>().sendMessage(
                message: value.trim(),
                chatId: chatId,
              );
          controller.clear();
        },
        decoration: InputDecoration(
          hintText: 'Send Message',
          hintStyle: const TextStyle(color: kPrimaryColor),
          contentPadding: const EdgeInsets.all(16),
          suffixIcon: IconButton(
            onPressed: () {
              context.read<ChatCubit>().sendMessage(
                    message: controller.text.trim(),
                    chatId: chatId,
                  );
              controller.clear();
            },
            icon: const Icon(
              Icons.send,
              color: kPrimaryColor,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
      ),
    );
  }
}
