import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:new_cross_app/Calendar/Consumer/User.dart';
import 'package:new_cross_app/helper/constants.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  // reference for our collections
  final CollectionReference CostumerCollection =
      FirebaseFirestore.instance.collection("customers");
  final CollectionReference TradieCollection =
      FirebaseFirestore.instance.collection("tradeperson");
  final CollectionReference ChatListCollection =
      FirebaseFirestore.instance.collection("groups");

  // saving the customer_user data
  Future savingCustomerData(String fullName, String email) async {
    return await CostumerCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "Is_Tradie": false,
      "Phone": "",
      "address": "",
      "Chatlist": [],
      "profilePic": "",
      "uid": uid,
    });
  }

  // saving the Tradie_user data
  Future savingTradieData(String fullName, String email) async {
    return await TradieCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "Phone": "",
      "address": "",
      "Chatlist": [],
      "profilePic": "",
      "job": "",
      "uid": uid,
    });
  }

  // getting user data
  Future gettingUserData(String email) async {
    QuerySnapshot snapshotC =
        await CostumerCollection.where("email", isEqualTo: email).get();
    QuerySnapshot snapshotT =
        await TradieCollection.where("email", isEqualTo: email).get();
    if (snapshotC.docs.isEmpty) {
      return snapshotT.docs.isEmpty ? null : snapshotT;
    } else {
      return snapshotC;
    }
  }

  searchByName(String searchField) {
    //final List<User> categoryList = [];
    //QuerySnapshot snapshot_c =
    //await CostumerCollection.where("fullname", isEqualTo: searchField)
    //.get();

    /*
    if (snapshot_c != null) {
      categoryList.add(snapshot_c as User);
    } else {
      categoryList.add(snapshot_t as User);
    }
    */
    //categoryList.add(snapshot_t as User);
    return TradieCollection.where("fullName", isEqualTo: searchField).get();
  }

  //
  Future<bool> addChatRoom(chatRoom, chatRoomId) async {
    try {
      await FirebaseFirestore.instance
          .collection("chatRoom")
          .doc(chatRoomId)
          .set(chatRoom);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  getChats(String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
  }

  Future<void> addMessage(String chatRoomId, chatMessageData) async {
    try {
      await FirebaseFirestore.instance
          .collection("chatRoom")
          .doc(chatRoomId)
          .collection("chats")
          .add(chatMessageData);
    } catch (e) {
      print(e.toString());
    }
  }

  getUserChats(String itIsMyId) async {
    return await FirebaseFirestore.instance
        .collection("chatRoom")
        .where('users', arrayContains: itIsMyId)
        .snapshots();
  }

  //update message read status
  void updateMessageReadStatus(String chatRoomId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('chatRoom')
          .doc(chatRoomId)
          .collection('chats')
          .where('sendBy', isNotEqualTo: Constants.myName)
          .where('Isread', isEqualTo: false)
          .limit(50)
          .get();

      print(Constants.myName);
      print(querySnapshot.docs.length);
      //print("there should be 1 unread message!");
      WriteBatch batch = FirebaseFirestore.instance.batch();
      List<DocumentReference> messagesToUpdate = [];

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        String messageId = documentSnapshot.id;
        DocumentReference messageRef = FirebaseFirestore.instance
            .collection('chatRoom')
            .doc(chatRoomId)
            .collection('chats')
            .doc(messageId);

        batch.update(messageRef, {'Isread': true});
        messagesToUpdate.add(messageRef);
      }

      // Commit the batched write
      await batch.commit();

      //if (querySnapshot.docs[0]['Isread'] == true) {
      //print("update sucessful!");
      //} else {
      //print("update fail!");
      //}
      /*
      // Listen for new unread messages
      FirebaseFirestore.instance
          .collection('chatRoom')
          .doc(chatRoomId)
          .collection('chats')
          .where('sendBy', isNotEqualTo: Constants.myName)
          .where('Isread', isEqualTo: false)
          //.orderBy('time', descending: true)
          .limit(50)
          .snapshots()
          .listen((querySnapshot) {
        WriteBatch batch = FirebaseFirestore.instance.batch();
        List<DocumentReference> messagesToUpdate = [];

        for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
          String messageId = documentSnapshot.id;
          DocumentReference messageRef = FirebaseFirestore.instance
              .collection('chatRoom')
              .doc(chatRoomId)
              .collection('chats')
              .doc(messageId);

          batch.update(messageRef, {'Isread': true});
          messagesToUpdate.add(messageRef);
        }

        // Commit the batched write
        batch.commit();
      });
      */
    } catch (e) {
      // Handle the error gracefully
      print('Error: $e');
    }
  }
}
