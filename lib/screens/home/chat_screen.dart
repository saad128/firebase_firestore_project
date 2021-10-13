import 'package:firebase_internship_project/widgets/new_messages.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final String chatRoomId;
  final String chatRoomName;

  ChatScreen({required this.chatRoomId,required this.chatRoomName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        title: Text(chatRoomName),
        backgroundColor: Colors.purple[400],
        elevation: 0.0,
      ),
      body: NewMessages(chatRoomId),
    );
  }
}
