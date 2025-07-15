import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_chatting/features/auth/presentation/manager/auth/auth_cubit.dart';
import 'package:just_chatting/features/chat/data/models/chat_model.dart';
import 'package:just_chatting/features/chat/data/models/messages_model.dart';
import 'package:just_chatting/features/chat/presentation/manager/chat/chat_cubit.dart';
import 'package:just_chatting/features/chat/presentation/views/widgets/group_name.dart';
import 'package:just_chatting/features/chat/presentation/views/widgets/messages_field.dart';
import 'package:just_chatting/features/chat/presentation/views/widgets/messages_menu_button.dart';
import 'package:just_chatting/features/chat/presentation/views/widgets/messsage_bubble.dart';

class MessagesView extends StatelessWidget {
  const MessagesView({super.key, required this.chatModel});

  final ChatModel chatModel;

  @override
  Widget build(BuildContext context) {
    final String userId = context.read<AuthCubit>().userId;
    final messages = FirebaseFirestore.instance
        .collection('chats')
        .doc(chatModel.id)
        .collection('messages');

    return Scaffold(
      backgroundColor: context.watch<ChatCubit>().chatBackgroundColor,
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(chatModel.groupImage),
            ),
            const SizedBox(width: 8),
            Expanded(child: GroupName(chatModel: chatModel)),
          ],
        ),
        actions: [MessagesMenuButton(chatModel: chatModel)],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  messages.orderBy('sendTime', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.hasData) {
                  List<MessageModel> messageList = [];
                  for (int i = 0; i < snapshot.data!.docs.length; i++) {
                    messageList.add(
                      MessageModel.formJson(snapshot.data!.docs[i]),
                    );
                  }
                  if (messageList.isEmpty) {
                    return const Center(child: Text('No Messages yet'));
                  } else {
                    return ListView.builder(
                      reverse: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: messageList.length,
                      itemBuilder: (context, index) {
                        return MessageBubble(
                          messageModel: messageList[index],
                          isMe: messageList[index].senderId == userId,
                          id: chatModel.id,
                        );
                      },
                    );
                  }
                } else {
                  return const Center(child: Text('Loading Messages ...'));
                }
              },
            ),
          ),
          MessagesField(chatId: chatModel.id),
        ],
      ),
    );
  }
}
