import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_chatting/core/widgets/app_snack_bar.dart';
import 'package:just_chatting/features/auth/data/models/user_model.dart';
import 'package:just_chatting/features/auth/presentation/manager/auth/auth_cubit.dart';
import 'package:just_chatting/features/chat/presentation/manager/chat/chat_cubit.dart';
import 'package:just_chatting/features/chat/presentation/views/widgets/user_card.dart';

class NewChatView extends StatelessWidget {
  const NewChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        title: const Text(
          'New Chat',
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('users').get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var users = snapshot.data!.docs
                .where((element) =>
                    element.id != context.watch<AuthCubit>().userId)
                .toList();
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return UserCard(
                    userModel: UserModel.fromFirestore(users[index]));
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var membersIds = context.read<ChatCubit>().membersIds;

          if (membersIds.length == 1) {
            appSnackBar(
                context, 'Select at least one person to start new chat');
          } else if (membersIds.length == 2) {
            await context.read<ChatCubit>().newGroup(context);
          } else {
            TextEditingController controller = TextEditingController();
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                actions: [
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(hintText: 'Group Name'),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (context.mounted) {
                        context.read<ChatCubit>().groupName =
                            controller.text.trim();
                        Navigator.of(context).pop();
                        await context.read<ChatCubit>().newGroup(context);
                      }
                    },
                    child: const Text('Create'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (context.mounted) {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        context.read<ChatCubit>().membersIds.clear();
                        membersIds.add(context.read<AuthCubit>().userId);
                      }
                    },
                    child: const Text('Cancel'),
                  )
                ],
              ),
            );
          }
        },
        child: const Icon(
          CupertinoIcons.paperplane_fill,
        ),
      ),
    );
  }
}
