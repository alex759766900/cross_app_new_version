import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_cross_app/Login/login.dart';
import 'package:new_cross_app/Login/not_logged_in_page.dart';
import 'package:new_cross_app/helper/helper_function.dart';
import 'package:sizer/sizer.dart';

import '../helper/constants.dart';

class Profile extends StatefulWidget {
  final String userId;
  const Profile({Key? key, required this.userId}) : super(key: key);

  @override
  ProfileState createState() => ProfileState();
}

final databaseReference = FirebaseFirestore.instance;
final CollectionReference colRef = databaseReference.collection('customers');

class ProfileState extends State<Profile> {
  final _formkey = GlobalKey<FormState>();
  var scrollController = ScrollController();
  final TextEditingController name = new TextEditingController(),
      age = new TextEditingController(),
      phone = new TextEditingController(),
      aaddress = new TextEditingController();
  // card = new TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserProfile();
  }

  Future<void> getUserProfile() async {
    // Constants.myId = "Siyuan0001";
    Constants.MyId = (await HelperFunctions.getUserIdFromSF()) ?? "";
    print("id: " + Constants.MyId);

    // Check if user is logged in
    if (Constants.MyId.isEmpty || Constants.MyId == '') {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => NotLoggedInPage()));
      print("you have to log in " + Constants.MyId);
    } else {
      DocumentSnapshot docSnapshot = await colRef.doc(Constants.MyId).get();
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

      setState(() {
        name.text = data['name'] ?? '';
        age.text = data['age'] ?? '';
        phone.text = data['phone'] ?? '';
        aaddress.text = data['address'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget iconSection = Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CircleAvatar(
            backgroundImage: const AssetImage("images/Tom.jpg"),
            radius: 60,
          ),
          const IconButton(
              onPressed: null, icon: const Icon(Icons.edit, size: 40.0)),
        ],
      ),
    );

    Widget personalInformation = Container(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Icon(Icons.account_box_rounded, size: 40.0)),
            Center(
              child: Form(
                  key: _formkey,
                  child: OverflowBar(
                      spacing: 5.w,
                      overflowAlignment: OverflowBarAlignment.center,
                      overflowSpacing: 16,
                      children: [
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 400),
                              child: TextFormField(
                                controller: name,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Name',
                                    hintText: 'Enter your full name'),
                              ),
                            )),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 400),
                              child: TextFormField(
                                controller: age,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Age',
                                    hintText: 'Enter your age'),
                              ),
                            )),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 400),
                              child: TextFormField(
                                controller: phone,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Phone Number',
                                    hintText: 'Enter your phone number'),
                              ),
                            )),
                      ])),
            ),
          ],
        ));

    Widget address = Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30.0, top: 30.0),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Icon(Icons.house, size: 40.0),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 20, bottom: 10),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 400),
                child: TextFormField(
                  controller: aaddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Address',
                      hintText: 'Enter your full address'),
                ),
              )),
        ],
      ),
    );

    // Widget bankAccount = Container(
    //   child: Column(
    //     mainAxisSize: MainAxisSize.min,
    //     children: [
    //       Padding(
    //         padding: const EdgeInsets.only(left: 30.0, top: 30.0),
    //         child: const Align(
    //           alignment: Alignment.centerLeft,
    //           child: Icon(Icons.credit_card_outlined, size: 40.0),
    //         ),
    //       ),
    //       Padding(
    //           padding: const EdgeInsets.only(
    //               left: 15.0, right: 15.0, top: 20, bottom: 10),
    //           child: ConstrainedBox(
    //             constraints: BoxConstraints(maxWidth: 300),
    //             child: TextFormField(
    //               controller: card,
    //               validator: (value) {
    //                 if (value == null || value.isEmpty) {
    //                   return 'Please enter some text';
    //                 }
    //                 return null;
    //               },
    //               decoration: InputDecoration(
    //                   border: OutlineInputBorder(),
    //                   labelText: 'Card number',
    //                   hintText: 'Enter your card number'),
    //             ),
    //           )),
    //     ],
    //   ),
    // );

    Widget submitbutton = Container(
      padding: const EdgeInsets.only(top: 30.0, bottom: 20.0),
      child: ElevatedButton(
        onPressed: () {
          if (_formkey.currentState!.validate()) {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Form Submitted'),
                content:
                    const Text('Your profile information has been submitted.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );

            // Save the data to the database
            colRef.doc(Constants.MyId).set({
              "name": name.text,
              "age": age.text,
              "phone": phone.text,
              "address": aaddress.text,
              // "card": card.text,
            });
          }
        },
        child: const Text('Submit'),
        style: ElevatedButton.styleFrom(
          primary: Theme.of(context).primaryColor,
          onPrimary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView(
        controller: scrollController,
        children: [
          iconSection,
          personalInformation,
          address,
          // bankAccount,
          submitbutton,
        ],
      ),
    );
  }
}
