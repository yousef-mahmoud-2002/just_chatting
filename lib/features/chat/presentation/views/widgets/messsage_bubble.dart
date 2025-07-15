import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:just_chatting/constants.dart';
import 'package:just_chatting/features/chat/presentation/manager/chat/chat_cubit.dart';
import '../../../data/models/messages_model.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.messageModel,
    required this.isMe,
    required this.id,
  });

  final MessageModel messageModel;
  final bool isMe;
  final String id;

  @override
  Widget build(BuildContext context) {
    String defineMessageDate(DateTime sendTime) {
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

    Color setColor(BuildContext context) {
      Color bubbleColor = context.watch<ChatCubit>().chatBubbleColor;
      if (isMe) {
        return bubbleColor;
      } else {
        return bubbleColor.withValues(alpha: 0.4);
      }
    }

    return Align(
      alignment: isMe ? Alignment.topRight : Alignment.topLeft,
      child: InkWell(
        borderRadius: BorderRadius.circular(25),
        splashColor: kPrimaryColor.shade100,
        splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory,
        onLongPress: () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Delete Message'),
              content:
                  const Text('Are you sure you want to delete this message?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    context
                        .read<ChatCubit>()
                        .deleteMessage(id, messageModel.id);
                    Navigator.pop(context);
                  },
                  child:
                      const Text('Delete', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
              color: setColor(context),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(25),
                topRight: const Radius.circular(25),
                bottomRight: Radius.circular(isMe ? 0 : 25),
                bottomLeft: Radius.circular(isMe ? 25 : 0),
              )),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                messageModel.senderName,
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                messageModel.message,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                defineMessageDate(messageModel.sendTime),
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
