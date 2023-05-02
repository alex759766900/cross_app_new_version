//import 'package:chatapp/helper/authenticate.dart';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:new_cross_app/Login/utils/constants.dart';
import 'package:new_cross_app/helper/constants.dart';
import 'package:new_cross_app/helper/helper_function.dart';
//import 'package:new_cross_app/helper/theme.dart';
import 'package:new_cross_app/services/auth_service.dart';
import 'package:new_cross_app/services/database_service.dart';
import 'package:new_cross_app/chat/screens/chat_screen.dart';
import 'package:new_cross_app/chat/screens/search_page.dart';
import 'package:flutter/material.dart';

import '../../Routes/route_const.dart';
import '../../main.dart';
import '../widgets/my_tab_bar.dart';

class ChatRoom extends StatefulWidget {
  String userId;
  ChatRoom({super.key, required this.userId});

  @override
  _ChatRoomState createState() => _ChatRoomState(userId);
}

final chatRef = FirebaseFirestore.instance.collection('chatRoom');

class _ChatRoomState extends State<ChatRoom> with TickerProviderStateMixin {
  String userId = '';
  late Stream<QuerySnapshot> chatRooms;
  _ChatRoomState(String id) {
    this.userId = id;
    chatRef.where('user', arrayContains: userId).snapshots().listen(
        (event) => print("get query"+"chatroom"),
        onError: (error) => print("Listen failed: $error"));
    chatRooms = chatRef.where('users', arrayContains: userId).snapshots();
  }

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
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
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
                var ulist=snapshot.data!.docs[index]['users'];
                var talkerId='';
                for(var u in ulist){
                  if(u!=userId){
                    talkerId=u;
                    break;
                  }
                }
                return ChatRoomsTile(
                  userId: talkerId,
                  chatRoomId: snapshot.data!.docs[index]["chatRoomId"],
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
    //getUserInfogetChats();
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
    Constants.MyId = (await HelperFunctions.getUserIdFromSF())!;
    print(Constants.MyId);
    DatabaseService().getUserChats(Constants.MyId).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print(
            "we got the data + ${chatRooms.toString()} this is name  ${Constants.MyId}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String userId = widget.userId;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Jemma',
        ),
        leading: IconButton(
          onPressed: () {
            GoRouter.of(context).pushNamed(RouterName.homePage, params: {
              'userId': userId,
            });
          },
          icon: const Icon(Icons.arrow_back),
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
          GoRouter.of(context).pushNamed(RouterName.ChatSearch, params: {
            'userId': userId,
          });
        },
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userId;
  final String chatRoomId;

  ChatRoomsTile({Key? key, required this.userId, required this.chatRoomId})
      : super(key: key);
  String userName='';

  Stream<Map<String, dynamic>> GetLastMessage() async* {
    final controller = StreamController<Map<String, dynamic>>();
    controller.onListen = () async {
      try {
        userName=(await HelperFunctions.getUserNameFromId(userId))!;
        print(userName);
        FirebaseFirestore.instance
            .collection('chatRoom')
            .doc(chatRoomId)
            .collection('chats')
            .orderBy('time', descending: true)
            .limit(1)
            .snapshots()
            .listen((QuerySnapshot querySnapshot) {
          if (querySnapshot.docs.isNotEmpty) {
            Map<String, dynamic> messageData =
                (querySnapshot.docs[0].data() as Map<String, dynamic>);
            String messageText = messageData['message'];
            String sender = messageData['sendBy'];
            bool Readstatus = messageData['Isread'];
            bool isUnreadAndNotSentByUser =
                Readstatus == false && sender != Constants.myName;
            controller
                .add({'text': messageText, 'status': isUnreadAndNotSentByUser});
          } else {
            controller.add({'text': "Start your chat!", 'status': false});
          }
        });
      } catch (e) {
        print(e.toString());
      }
    };
    yield* controller.stream;
    controller.onCancel = () {};
  }


  @override
  Widget build(BuildContext context) {

    return StreamBuilder<Map<String, dynamic>>(
      stream: GetLastMessage(),
      builder: (context, snapshot) {
        String latestMessage =
            snapshot.hasData ? snapshot.data!['text'] : "Start your chat!";
        bool isUnreadAndNotSentByUser =
            snapshot.hasData && snapshot.data!['status'] != null
                ? snapshot.data!['status']
                : false;

        return GestureDetector(
          onTap: () {
            GoRouter.of(context).pushNamed(RouterName.ChatRoom, params: {
              'userId': userId,
              'chatRoomId':chatRoomId,
            });
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
                      //TODO: username
                      userName,
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
                            //TODO
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
