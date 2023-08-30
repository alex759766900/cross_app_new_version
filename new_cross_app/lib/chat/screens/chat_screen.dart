import 'dart:io';
import 'package:go_router/go_router.dart';
import 'package:new_cross_app/chat/screens/chat_home_screen.dart';
import 'package:new_cross_app/helper/constants.dart';
import 'package:new_cross_app/services/database_service.dart';
//import 'package:new_cross_app/chat/chatting/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../Routes/route_const.dart';
import '../../helper/helper_function.dart';
import '../../main.dart';

class Chat extends StatefulWidget {
  final String chatRoomId;
  final String userId;

  Chat({super.key, required this.chatRoomId, required this.userId});

  @override
  _ChatState createState() => _ChatState();
}

final chatRef = FirebaseFirestore.instance.collection('chatRoom');

class _ChatState extends State<Chat> {
  Stream<QuerySnapshot>? chats;
  TextEditingController messageEditingController = TextEditingController();
  //String latestMessageId = '';
  /*_ChatState(String chatRoomId, String userId){
    //TODO
    chatRef.where('user', arrayContains: userId).snapshots().listen(
            (event) => print("get query"),
        onError: (error) => print("Listen failed: $error"));
    chats=chatRef.where('users',arrayContains: userId).snapshots();
  }*/
  String userName = 'Test_User';
  Widget chatMessages() {
    if (chats == null) {
      return Container();
    }

    return StreamBuilder(
      stream: chats!,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                reverse: false,
                itemCount: snapshot.data?.docs.length ?? 0,
                itemBuilder: (context, index) {
                  final Map<String, dynamic>? messageData =
                      snapshot.data?.docs[index].data()
                          as Map<String, dynamic>?;
                  final DateTime sendTime = DateTime.fromMillisecondsSinceEpoch(
                      messageData?['time'] ?? 0);
                  final DateFormat formatter = DateFormat('yy/MM/dd  HH:mm');
                  final String formattedTime = formatter.format(sendTime);
                  final bool Isread = messageData?['Isread'];
                  return MessageTile(
                    message: messageData?['message'],
                    sendByMe: Constants.MyId == messageData?['sendBy'],
                    sendTime: formattedTime,
                    Isread: Isread,
                    chatRoomId: widget.chatRoomId,
                  );
                },
              )
            : Container();
      },
    );
  }

  addMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": Constants.MyId,
        "message": messageEditingController.text,
        'time': DateTime.now().millisecondsSinceEpoch,
        'Isread': false,
      };

      DatabaseService().addMessage(widget.chatRoomId, chatMessageMap);

      setState(() {
        messageEditingController.text = "";
        //latestMessageId = '';
      });
    }
  }

  @override
  initState() {
    super.initState();
    DatabaseService().getChats(widget.chatRoomId).then((val) {
      setState(() {
        chats = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String userId = widget.userId;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            GoRouter.of(context).pushNamed(RouterName.chat, params: {
              'userId': userId,
            });
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          //TODO: NAME
          userName,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: chatMessages(),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            color: Colors.white,
            height: 100,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.emoji_emotions_outlined,
                            size: 28,
                          ),
                          onPressed: () {},
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextField(
                            controller: messageEditingController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Type your message ...',
                              hintStyle: TextStyle(color: Colors.grey[500]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                GestureDetector(
                  onTap: () {
                    // Do something when the CircleAvatar is tapped
                    addMessage();
                    //print('CircleAvatar tapped!');
                  },
                  child: const CircleAvatar(
                    backgroundColor: Color(0xFF4CAF50),
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;
  final String sendTime;
  final bool Isread;
  final String chatRoomId;

  const MessageTile({
    Key? key,
    required this.message,
    required this.sendByMe,
    required this.sendTime,
    required this.Isread,
    required this.chatRoomId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!sendByMe) {
      DatabaseService().updateMessageReadStatus(chatRoomId);
    }
    ;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment:
            sendByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Text(
                sendTime,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.done_all,
                size: 16,
                color: sendByMe
                    ? (Isread ? Colors.green : Colors.grey[600])
                    : Colors.white,
              )
            ],
          ),
          Container(
            padding: EdgeInsets.only(
              top: 8,
              bottom: 8,
              left: sendByMe ? 0 : 24,
              right: sendByMe ? 24 : 0,
            ),
            alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin: sendByMe
                  ? const EdgeInsets.only(left: 30)
                  : const EdgeInsets.only(right: 30),
              padding: const EdgeInsets.symmetric(
                vertical: 17,
                horizontal: 20,
              ),
              decoration: BoxDecoration(
                borderRadius: sendByMe
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(23),
                        topRight: Radius.circular(23),
                        bottomLeft: Radius.circular(23),
                      )
                    : const BorderRadius.only(
                        topLeft: Radius.circular(23),
                        topRight: Radius.circular(23),
                        bottomRight: Radius.circular(23),
                      ),
                color: sendByMe ? const Color(0xFF4CAF50) : Colors.grey[200],
              ),
              child: Text(
                message,
                textAlign: sendByMe ? TextAlign.right : TextAlign.left,
                style: TextStyle(
                  color: sendByMe ? Colors.white : Colors.black,
                  fontSize: 16,
                  fontFamily: 'OverpassRegular',
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
