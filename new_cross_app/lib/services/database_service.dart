import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

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
      "Phone": "",
      "CardName": "",
      "CardNumber": "",
      "CardValidDate": "",
      "cardCVV": "",
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
      "companyName": "",
      "companyABN": "",
      "bankName": "",
      "bankNumber": "",
      "bankBSB": "",
      "address": "",
      "Chatlist": [],
      "profilePic": "",
      "uid": uid,
    });
  }

  // getting user data
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot_c =
        await CostumerCollection.where("email", isEqualTo: email).get();
    QuerySnapshot snapshot_t =
        await TradieCollection.where("email", isEqualTo: email).get();
    if (snapshot_c != null) {
      return snapshot_c;
    } else {
      return snapshot_t;
    }
  }
}
