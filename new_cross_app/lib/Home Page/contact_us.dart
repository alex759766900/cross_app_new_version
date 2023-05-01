
import 'package:flutter/material.dart';
import 'package:new_cross_app/Home Page/nav_bar.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Contact Us"),
        ),
        drawer: NavBar());
  }
}

