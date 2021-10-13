import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_internship_project/screens/home/message_bubbles.dart';
import 'package:firebase_internship_project/services/database.dart';
import 'package:firebase_internship_project/shared/constants.dart';
import 'package:flutter/material.dart';

class NewMessages extends StatefulWidget {
  final String chatRoomId;

  NewMessages(this.chatRoomId);

  @override
  _NewMessagesState createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  DatabaseService _databaseService = DatabaseService();

  var _enteredMessage = '';
  final _controller = TextEditingController();

  Stream? chatMessagesStream;

  Widget chatMessagesList() {
    return StreamBuilder(
      initialData: [],
      stream: chatMessagesStream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return snapshot.hasData ? ListView.builder(
            itemCount: snapshot.data.docs.length,
            reverse: true,
            itemBuilder: (context, index) {
              return MessageBubble(snapshot.data.docs[index]['message'],
                  snapshot.data.docs[index]['sendBy'] == Constants.myName);
            }) : Container();
      },
    );
  }

  void _sendMessage() {
    FocusScope.of(context).unfocus();
    if (_controller.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        'message': _enteredMessage,
        'sendBy': Constants.myName,
        'time': Timestamp.now(),
      };
      _databaseService.addConversationMessage(widget.chatRoomId, messageMap);
    }
    _controller.clear();
  }

  @override
  void initState() {
    _databaseService.getConversationMessage(widget.chatRoomId).then((value) {
      setState(() {
        chatMessagesStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: chatMessagesList()),
        Container(
          margin: EdgeInsets.only(top: 8.0),
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: 'Send a message...',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _enteredMessage = value;
                    });
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.purple[400],
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed:
                      _enteredMessage.trim().isEmpty ? null : _sendMessage,
                  icon: Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

