import 'package:flutter/material.dart';
import 'package:new_cross_app/chat/chatting/all_chat.dart';
import 'package:new_cross_app/chat/chatting/recent_chats.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const RecentChats(),
          AllChats(),
        ],
      ),
    );
  }
}