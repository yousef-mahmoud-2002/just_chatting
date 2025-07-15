import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:just_chatting/constants.dart';
import 'package:just_chatting/core/utils/animate_navigation_route.dart';
import 'package:just_chatting/core/widgets/app_snack_bar.dart';
import 'package:just_chatting/features/chat/data/models/chat_model.dart';
import 'package:just_chatting/features/chat/presentation/manager/chat/chat_cubit.dart';
import 'package:just_chatting/features/chat/presentation/views/messages_view.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({super.key, required this.chatModel});

  final ChatModel chatModel;

  @override
  Widget build(BuildContext context) {
    String defineLastMessageDate(DateTime sendTime) {
      final timeFormatter = DateFormat('h:mm a');
      final dayFormatter = DateFormat('d/M/y');

      String time = timeFormatter.format(sendTime);
      String day = dayFormatter.format(sendTime);

      if (day == dayFormatter.format(DateTime.now())) {
        return time;
      } else {
        return day;
      }
    }

    return InkWell(
      splashColor: kPrimaryColor.shade100,
      splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory,
      onLongPress: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Delete Chat'),
            content: const Text('Do you want to delete the whole chat?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  context.read<ChatCubit>().deleteChat(chatModel.id);
                  Navigator.pop(context);
                  appSnackBar(context, 'Chat deleted successfully!');
                },
                child:
                    const Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
      onTap: () {
        Navigator.push(
          context,
          animateRoute(MessagesView(chatModel: chatModel)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey.shade300,
              backgroundImage: NetworkImage(chatModel.groupImage),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          chatModel.groupName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Text(
                        defineLastMessageDate(chatModel.lastMessageTime),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    chatModel.lastMessage,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
