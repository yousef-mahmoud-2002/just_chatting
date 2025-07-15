import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_chatting/core/utils/animate_navigation_route.dart';
import 'package:just_chatting/features/auth/data/models/user_model.dart';
import 'package:just_chatting/features/chat/data/models/chat_model.dart';
import 'package:just_chatting/features/chat/presentation/views/messages_view.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  final firestore = FirebaseFirestore.instance;

  Color chatBackgroundColor = Colors.white;
  Color chatBubbleColor = Colors.teal[400]!;

  String senderName = '';
  List<String> membersIds = [];
  String groupName = '';

  void setSenderId(String id) {
    membersIds.add(id);
  }

  void changeChatBackgroundColor(color) {
    chatBackgroundColor = color;
    emit(ChangeChatBackgroundColorState(chatBackgroundColor: color));
  }

  void changeChatBubbleColor(color) {
    chatBubbleColor = color;
    emit(ChangeChatBubbleColorState(chatBubbleColor: color));
  }

  Future<void> newGroup(BuildContext context) async {
    final isGroup = membersIds.length > 2;

    final user = await fetchSingleUserData(membersIds.last);
    final String finalGroupName = isGroup ? groupName : user.name;

    String setGroupImage() {
      if (!isGroup) {
        return user.profileImage;
      } else {
        final random = Random();
        int randomNumber = random.nextInt(69) + 1;

        return 'https://i.pravatar.cc/150?img=$randomNumber';
      }
    }

    final chatDocRef = firestore.collection('chats').doc();

    final chatData = {
      'id': chatDocRef.id,
      'isGroup': isGroup,
      'groupName': finalGroupName,
      'groupImage': setGroupImage(),
      'members': membersIds,
      'lastMessage': '',
      'lastMessageTime': DateTime.now(),
    };

    final querySnap = await firestore
        .collection('chats')
        .where('members', arrayContains: membersIds.first)
        .get();

    DocumentReference? chatRef;

    for (var doc in querySnap.docs) {
      final data = doc.data();
      final existingMembers = List<String>.from(data['members']);
      final existingIsGroup = data['isGroup'] as bool;

      if (existingIsGroup == isGroup &&
          existingMembers.toSet().containsAll(membersIds) &&
          membersIds.toSet().containsAll(existingMembers)) {
        chatRef = doc.reference;
        break;
      }
    }
    chatRef ??= await firestore.collection('chats').add(chatData);

    final chatDoc = await chatRef.get();
    final chatModel = ChatModel.fromFirestore(chatDoc);

    membersIds.clear();
    setSenderId(FirebaseAuth.instance.currentUser!.uid);

    if (context.mounted) {
      Navigator.pop(context);
      Future.delayed(const Duration(milliseconds: 300), () {
        if (context.mounted) {
          Navigator.push(
            context,
            animateRoute(MessagesView(chatModel: chatModel)),
          );
        }
      });
    }
  }

  Future<UserModel> fetchSingleUserData(String uid) async {
    final doc = await firestore.collection('users').doc(uid).get();
    return UserModel.fromFirestore(doc);
  }

  Future<void> sendMessage({
    required String chatId,
    required String message,
  }) async {
    final docRef =
        firestore.collection('chats').doc(chatId).collection('messages').doc();

    final messageId = docRef.id;

    await docRef.set({
      'id': messageId,
      'senderName': senderName,
      'senderId': membersIds.first,
      'message': message,
      'sendTime': DateTime.now(),
    });

    await firestore.collection('chats').doc(chatId).update({
      'lastMessage': message,
      'lastMessageTime': DateTime.now(),
    });
  }

  Future<void> deleteMessage(String chatId, String messageId) async {
    await firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .update({
      'message': 'this message has been deleted',
    });

    await FirebaseFirestore.instance.collection('chats').doc(chatId).update({
      'lastMessageTime': DateTime.now(),
      'lastMessage': 'this message has been deleted',
    });
  }

  Future<void> deleteChat(String chatId) async {
    final chatRef = FirebaseFirestore.instance.collection('chats').doc(chatId);

    final messages = await chatRef.collection('messages').get();
    for (var msg in messages.docs) {
      await msg.reference.delete();
    }

    await chatRef.delete();
  }
}
