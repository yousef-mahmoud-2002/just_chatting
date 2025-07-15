import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:just_chatting/features/chat/data/models/chat_model.dart';
import 'package:just_chatting/features/chat/presentation/manager/chat/chat_cubit.dart';

class MessagesMenuButton extends StatelessWidget {
  const MessagesMenuButton({super.key, required this.chatModel});
  final ChatModel chatModel;
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      offset: const Offset(0, 56),
      icon: const Icon(Icons.more_vert),
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        PopupMenuItem(
          child: const Text('Change Background Color'),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Change Background Color',
                      textAlign: TextAlign.center),
                  content: MaterialColorPicker(
                    onColorChange: (color) {
                      context
                          .read<ChatCubit>()
                          .changeChatBackgroundColor(color);
                    },
                  ),
                  actions: [
                    TextButton(
                      child: const Text('Submit'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          child: const Text('Change Bubble Color'),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Change Bubble Color',
                      textAlign: TextAlign.center),
                  content: MaterialColorPicker(
                    allowShades: false,
                    onMainColorChange: (color) {
                      context.read<ChatCubit>().changeChatBubbleColor(color);
                    },
                  ),
                  actions: [
                    TextButton(
                      child: const Text('Submit'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}
