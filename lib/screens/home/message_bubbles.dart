import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  MessageBubble(this.message, this.isMe);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color:isMe ? Colors.grey[400] : Colors.purpleAccent,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: !isMe ? Radius.circular(0):Radius.circular(12),
              bottomRight: isMe  ? Radius.circular(0): Radius.circular(12),
            ),
          ),
          width: 170,
          padding: EdgeInsets.symmetric(vertical: 12,horizontal: 16),
          margin: EdgeInsets.symmetric(vertical: 4,horizontal: 8),
          child: Text(message,style: TextStyle(color: Colors.black),),
        ),
      ],
    );
  }
}
