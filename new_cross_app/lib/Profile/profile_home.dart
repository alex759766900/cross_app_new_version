import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_cross_app/Home%20Page/responsive.dart';
import '../Home Page/constants.dart';
import '../Home Page/decorations.dart';
import '../Home Page/home.dart';
import '../Routes/route_const.dart';

class ProfileHome extends StatefulWidget {
  String userId;

  ProfileHome({super.key, required this.userId});

  @override
  _ProfileHomeState createState() => _ProfileHomeState(userId: userId);
}

late bool _isConsumer = true;
final databaseReference = FirebaseFirestore.instance;
final CollectionReference colRef = databaseReference.collection('customers');

class _ProfileHomeState extends State<ProfileHome> {
  String userId;

  _ProfileHomeState({required this.userId});

  late String name = "";
  late String address = "";
  late String email = "";
  late String phone = "";
  String person_intro = 'Personal Introduction';
  String person_intro_cont =
      'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';
  String strip_acc = 'Stripe Account';

  @override
  void initState() {
    super.initState();
    isConsumer(userId).then((value) {
      print(value);
      _isConsumer = false; //value;
    });
    getUserProfile(userId);
  }

  Future<void> getUserProfile(String userId) async {
    DocumentSnapshot docSnapshot = await colRef.doc(userId).get();
    Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

    setState(() {
      name =
          data['fullName']?.isEmpty ? 'No Name Information' : data['fullName'];
      address =
          data['address']?.isEmpty ? 'No Address Information' : data['address'];
      email = data['email']?.isEmpty ? 'No Mail Information' : data['email'];
      phone = data['Phone']?.isEmpty ? 'No Phone Information' : data['Phone'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var scrollController = ScrollController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile", style: TextStyle(color: Colors.black54)),
      ),
      body: Scrollbar(
        controller: scrollController,
        child: Center(
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(children: [
              // General customer information part
              customerInfo(size),
              SizedBox(height: 2.5.ph(size)),
              if (_isConsumer)
                TextButton(
                    onPressed: () {},
                    child: Text('Register as a tradie',
                        style: TextStyle(color: Colors.black87))),
              if (!_isConsumer)
                Container(
                  width: 50.pw(size),
                  constraints: const BoxConstraints(minWidth: 400),
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: defaultShadows,
                    borderRadius: BorderRadius.circular(HomeState.borderRadius),
                    border: Border.all(
                      color: kLogoColor,
                      width: 2.0,
                    ),
                  ),
                  child: Column(
                    children: [
                      const Text('Tradie Information',
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 20,
                              fontWeight: FontWeight.w600)),
                      certificateInfo(size),
                      ratingInfo(size),
                      workingTimeInfo(size),
                      workDescriptionIno(size),
                    ],
                  ),
                ),
            ]),
          ),
        ),
      ),
    );
  }

  Container customerInfo(Size size) {
    return Container(
      width: 50.pw(size),
      // height: 240,
      constraints: const BoxConstraints(minWidth: 400),
      margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
      padding: EdgeInsets.all(4.pw(size)),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: defaultShadows,
        borderRadius: BorderRadius.circular(HomeState.borderRadius),
        border: Border.all(
          color: kLogoColor,
          width: 2.0,
        ),
      ),
      child: Row(
        children: [
          // avatar and contact
          Column(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage("images/Tom.jpg"),
                radius: 55,
              ),
              SizedBox(
                height: 20,
              ),
              TextButton(
                  onPressed: () {},
                  child:
                      Text(strip_acc, style: TextStyle(color: Colors.black87))),
            ],
          ),
          // Personal Info
          SizedBox(width: 5.pw(size)),
          Stack(clipBehavior: Clip.none, children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 20,
                        fontWeight: FontWeight.w600)),
                SizedBox(height: 6.ph(size)),
                Text(
                  email,
                  style: TextStyle(color: Colors.black87),
                ),
                SizedBox(height: 3.ph(size)),
                Container(
                  width: 25.pw(size),
                  constraints: const BoxConstraints(minWidth: 150),
                  child: Text(
                    address,
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
                SizedBox(height: 3.ph(size)),
                Text(
                  phone,
                  style: TextStyle(color: Colors.black87),
                ),
                // Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                //   Text(
                //     person_intro,
                //     style: TextStyle(color: Colors.black87),
                //   ),
                //   Container(
                //     padding: EdgeInsets.all(4.0),
                //     margin: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                //     width: 25.pw(size),
                //     constraints: const BoxConstraints(
                //         minWidth: 150, maxHeight: 50),
                //     decoration: BoxDecoration(
                //         border: Border.all(color: Colors.grey),
                //         color: Colors.grey.withOpacity(0.15)),
                //     child: Text(person_intro_cont,
                //         style: TextStyle(
                //             color: Colors.black54, fontSize: 10)),
                //   ),
                // ]),
              ],
            ),
            Positioned(
                top: -5,
                right: 0,
                child: IconButton(
                  onPressed: () {
                    try {
                      GoRouter.of(context).pushNamed(RouterName.InfoEdit);
                    } catch (e) {
                      print("Error navigating: $e");
                    }
                  },
                  icon: Icon(Icons.edit, size: 20),
                ))
          ]),
        ],
      ),
    );
  }

  Container certificateInfo(Size size) {
    return Container(
        width: 40.pw(size),
        constraints: const BoxConstraints(minWidth: 320),
        margin: EdgeInsets.fromLTRB(1.pw(size), 30, 1.pw(size), 0),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: defaultShadows,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'Certification',
                style: TextStyle(
                    color: kTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 2.ph(size)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image(
                    image: AssetImage("images/certificate.png"),
                    width: 100,
                  ),
                  SizedBox(width: 4.pw(size)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 1.5.ph(size)),
                      Text('Electrician', style: TextStyle(fontSize: 12)),
                      SizedBox(height: 1.5.ph(size)),
                      Text('EL02343458ASDFA8', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ]),
            Positioned(
                top: -10,
                right: 10,
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.edit, size: 20),
                ))
          ],
        ));
  }

  Container ratingInfo(Size size) {
    return Container(
      width: 40.pw(size),
      constraints: const BoxConstraints(minWidth: 320),
      margin: EdgeInsets.fromLTRB(1.pw(size), 30, 1.pw(size), 0),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: defaultShadows,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'Tradie Rating',
          style: TextStyle(
              color: kTextColor, fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 2.ph(size)),
        Image(
          image: AssetImage("images/five_star.png"),
          width: 150,
        ),
      ]),
    );
  }

  Container workingTimeInfo(Size size) {
    return Container(
        width: 40.pw(size),
        constraints: const BoxConstraints(minWidth: 320),
        margin: EdgeInsets.fromLTRB(1.pw(size), 30, 1.pw(size), 0),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: defaultShadows,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Working Time',
                  style: TextStyle(
                      color: kTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 2.ph(size)),
                Container(
                  padding: EdgeInsets.fromLTRB(1.pw(size), 4, 1.pw(size), 4),
                  width: 36.pw(size),
                  constraints:
                      const BoxConstraints(minWidth: 240, maxHeight: 50),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: Colors.grey.withOpacity(0.15)),
                  child: Text(person_intro_cont,
                      style: TextStyle(color: Colors.black54, fontSize: 10)),
                ),
                SizedBox(height: 2.ph(size)),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_month,
                      color: Colors.green.shade500,
                    ),
                    TextButton(
                        onPressed: () {},
                        child: Text(
                          "Go to Tradie's Calendar",
                          style: TextStyle(color: Colors.black87),
                        ))
                  ],
                ),
              ],
            ),
            Positioned(
                top: -18,
                right: 10,
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.edit, size: 20),
                ))
          ],
        ));
  }

  Container workDescriptionIno(Size size) {
    return Container(
        width: 40.pw(size),
        constraints: const BoxConstraints(minWidth: 320),
        margin: EdgeInsets.fromLTRB(1.pw(size), 30, 1.pw(size), 0),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: defaultShadows,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Work Description',
                  style: TextStyle(
                      color: kTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 2.ph(size)),
                Container(
                  padding: EdgeInsets.fromLTRB(1.pw(size), 4, 1.pw(size), 4),
                  width: 36.pw(size),
                  constraints:
                      const BoxConstraints(minWidth: 240, maxHeight: 50),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: Colors.grey.withOpacity(0.15)),
                  child: Text(person_intro_cont,
                      style: TextStyle(color: Colors.black54, fontSize: 10)),
                ),
              ],
            ),
            Positioned(
                top: -18,
                right: 10,
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.edit, size: 20),
                ))
          ],
        ));
  }
}

Future<bool> isConsumer(userId) async {
  late bool result;
  await FirebaseFirestore.instance
      .collection('customers')
      .where('uid', isEqualTo: userId)
      .get()
      .then(
    (querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        print('it is consumer');
        result = true;
      } else {
        print('it is tradie');
        result = false;
      }
    },
    onError: (e) => print("Error completing: $e"),
  );
  return result;
}
