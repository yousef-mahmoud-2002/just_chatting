import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_chatting/core/utils/animate_navigation_route.dart';
import 'package:just_chatting/features/auth/presentation/manager/auth/auth_cubit.dart';
import 'package:just_chatting/features/chat/data/models/chat_model.dart';
import 'package:just_chatting/features/chat/presentation/views/widgets/chat_card.dart';
import 'package:just_chatting/features/home/presentation/views/new_chat_view.dart';
import 'package:just_chatting/features/home/presentation/views/widgets/settings_button.dart';
import 'package:just_chatting/features/theme/presentation/views/widgets/change_theme_button.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final chatsCollection = FirebaseFirestore.instance.collection('chats');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Just Chatting'),
        actions: const [ChangeThemeButton(), SettingsButton()],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: chatsCollection
            .where('members', arrayContains: context.watch<AuthCubit>().userId)
            .orderBy('lastMessageTime', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData) {
            var chatsList = snapshot.data!.docs;
            if (chatsList.isEmpty) {
              return const Center(child: Text('No Messages yet'));
            } else {
              return ListView.builder(
                itemCount: chatsList.length,
                itemBuilder: (context, index) => ChatCard(
                  chatModel: ChatModel.fromFirestore(chatsList[index]),
                ),
              );
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, animateRoute(const NewChatView()));
        },
        child: const Icon(Icons.chat),
      ),
    );
  }
}
