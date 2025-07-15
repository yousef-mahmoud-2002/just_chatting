import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_chatting/features/chat/data/models/chat_model.dart';
import 'package:just_chatting/features/chat/presentation/manager/chat/chat_cubit.dart';

class GroupName extends StatefulWidget {
  const GroupName({super.key, required this.chatModel});

  final ChatModel chatModel;

  @override
  State<GroupName> createState() => _GroupNameState();
}

class _GroupNameState extends State<GroupName> {
  List<String> membersNames = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchGroupMembersNames();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchGroupMembersNames() async {
    List<String> names = [];

    for (var memberId in widget.chatModel.members) {
      final user =
          await context.read<ChatCubit>().fetchSingleUserData(memberId);
      names.add(user.name);
    }

    setState(() {
      membersNames = names;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.chatModel.isGroup) {
      return Text(widget.chatModel.groupName);
    }

    if (loading) {
      return const CircularProgressIndicator(color: Colors.amber);
    }

    return Text(
      membersNames.join(', '),
      maxLines: 2,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    );
  }
}
