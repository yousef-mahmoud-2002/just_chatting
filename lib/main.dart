import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:just_chatting/core/utils/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const JustChatting());
}

class JustChatting extends StatelessWidget {
  const JustChatting({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Just Chatting',
      home: Scaffold(
        body: Center(
          child: Text('Just Chatting'),
        ),
      ),
    );
  }
}
