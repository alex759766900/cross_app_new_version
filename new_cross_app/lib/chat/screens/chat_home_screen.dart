//import 'package:chatapp/helper/authenticate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_cross_app/Login/utils/constants.dart';
import 'package:new_cross_app/helper/constants.dart';
import 'package:new_cross_app/helper/helper_function.dart';
//import 'package:new_cross_app/helper/theme.dart';
import 'package:new_cross_app/services/auth_service.dart';
import 'package:new_cross_app/services/database_service.dart';
import 'package:new_cross_app/chat/screens/chat_screen.dart';
import 'package:new_cross_app/chat/screens/search_page.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../widgets/my_tab_bar.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({super.key});

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> with TickerProviderStateMixin {
  late Stream chatRooms = const Stream.empty();
  late TabController tabController;
  int currentTabIndex = 0;

  void onTabChange() {
    setState(() {
      currentTabIndex = tabController.index;
    });
  }

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data?.docs.length == 0) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "You haven't chatted with anyone yet, "
                    "tap on the search icon  to search for the trade person "
                    "you are interested in communicating with.",
                    textAlign: TextAlign.center,
                    selectionColor: Colors.black,
                  )
                ],
              ),
            ),
          );
        } else {
          return ListView.builder(
              itemCount: snapshot.data?.docs.length ?? 0,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ChatRoomsTile(
                  userName: snapshot.data.docs[index]
                      .data()['chatRoomId']
                      .toString()
                      .replaceAll("_", "")
                      .replaceAll(Constants.myName, ""),
                  chatRoomId: snapshot.data.docs[index].data()["chatRoomId"],
                );
              });
        }
      },
    );
  }

  @override
  void initState() {
    tabController = TabController(length: 1, vsync: this);

    tabController.addListener(() {
      onTabChange();
    });
    super.initState();
    getUserInfogetChats();
  }

  @override
  void dispose() {
    tabController.addListener(() {
      onTabChange();
    });

    tabController.dispose();

    super.dispose();
  }

  getUserInfogetChats() async {
    Constants.myName = (await HelperFunctions.getUserNameFromSF())!;
    print(Constants.myName);
    DatabaseService().getUserChats(Constants.myName).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print(
            "we got the data + ${chatRooms.toString()} this is name  ${Constants.myName}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const MyApp()));
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Jemma',
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 0,
            child: Container(
              color: kMenuColor,
              child: MyTabBar(tabController: tabController),
            ),
          ),
          //MyTabBar(tabController: tabController),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  )),
              child: TabBarView(
                controller: tabController,
                children: [
                  chatRoomsList(),
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Search()));
        },
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  ChatRoomsTile({Key? key, required this.userName, required this.chatRoomId})
      : super(key: key);

  Future<Map<String, dynamic>> GetLastMessage() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(chatRoomId)
        .collection('chats')
        .orderBy('time', descending: true)
        .limit(1)
        .get();

    print(querySnapshot.docs.length);
    print("the last message length should be 1!");

    if (querySnapshot.docs.isNotEmpty) {
      Map<String, dynamic> messageData =
          (querySnapshot.docs[0].data() as Map<String, dynamic>);
      String messageText = messageData['message'];
      String sender = messageData['sendBy'];
      bool Readstatus = messageData['Isread'];
      bool isUnreadAndNotSentByUser =
          Readstatus == false && sender != Constants.myName;
      return {'text': messageText, 'status': isUnreadAndNotSentByUser};
    } else {
      return {'text': "Start your chat!", 'status': false};
    }

    // add a default return statement
    return {};
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: GetLastMessage(),
      builder: (context, snapshot) {
        String latestMessage =
            snapshot.hasData ? snapshot.data!['text'] : "Start your chat!";
        bool isUnreadAndNotSentByUser =
            snapshot.hasData && snapshot.data!['status'] != null
                ? snapshot.data!['status']
                : false;
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    Chat(chatRoomId: chatRoomId, userName: userName),
              ),
            );
          },
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Text(
                      userName.substring(0, 1).toUpperCase(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 87, 87, 87),
                        fontSize: 16,
                        fontFamily: 'OverpassRegular',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 87, 87, 87),
                              fontSize: 18,
                              fontFamily: 'OverpassRegular',
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            latestMessage,
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontFamily: 'OverpassRegular',
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 16,
                        width: 16,
                        decoration: BoxDecoration(
                          color: isUnreadAndNotSentByUser
                              ? Colors.green
                              : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
