import 'package:flutter/material.dart';
import 'dart:async';

import 'package:new_cross_app/Login/login.dart';

class NotLoggedInPage extends StatefulWidget {
  const NotLoggedInPage({Key? key}) : super(key: key);

  @override
  _NotLoggedInPageState createState() => _NotLoggedInPageState();
}

class _NotLoggedInPageState extends State<NotLoggedInPage> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      print('Navigating to LoginPage...');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
      print("done");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You are not logged in.',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              'Redirecting to Login page...',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
