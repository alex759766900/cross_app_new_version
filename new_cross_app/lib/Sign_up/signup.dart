import 'dart:convert';
import 'dart:math';
//import 'dart:js' as js;
import 'package:hive/hive.dart';
import 'package:http/http.dart';

import 'package:flutter/material.dart';
import 'package:new_cross_app/Login/models/user.dart';
import 'package:new_cross_app/Login/providers/login.dart';
import 'package:new_cross_app/Login/repository.dart';

//import 'package:jemma/routes.dart';
import 'package:new_cross_app/Login/utils/adaptive.dart';
import 'package:new_cross_app/Login/utils/constants.dart';
import 'package:new_cross_app/Login/utils/responsive.dart';
import 'package:new_cross_app/Login/utils/notification.dart';
//import 'package:new_cross_app/Sign_up/widgets/signup/account_details.dart';
//import 'package:new_cross_app/Sign_up/widgets/signup/address_details.dart';
//import 'package:new_cross_app/Sign_up/widgets/signup/bank_details.dart';
//import 'package:new_cross_app/Sign_up/widgets/signup/card_details.dart';
//import 'package:new_cross_app/Sign_up/widgets/signup/company_details.dart';
//import 'package:new_cross_app/Sign_up/widgets/signup/decoration_image_container.dart';
//import 'package:new_cross_app/Sign_up/widgets/signup/personal_details.dart';
//import 'package:new_cross_app/Sign_up/widgets/signup/tradesperson_profile_details.dart';
import 'package:new_cross_app/Sign_up/signup_customer.dart';
import 'package:new_cross_app/Sign_up/signup_tradeperson.dart';
//import 'package:provider/provider.dart';

import '../Login/login.dart';
import '../main.dart';

enum SignupOf { customer, tradesperson }

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: SafeArea(
            child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: 100.ph(size)),
                child: Stack(children: <Widget>[
                  SingleChildScrollView(
                      child: Form(
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                        /* Title */
                        ConstrainedBox(
                            constraints: BoxConstraints(minHeight: 30.ph(size)),
                            child: const Center(
                                child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Text("Sign up",
                                        style: TextStyle(fontSize: 50))))),

                        /* Header */
                        ConstrainedBox(
                            constraints: BoxConstraints(minHeight: 10.ph(size)),
                            child: const Text(
                                "In which way would you like to use Jemma?",
                                style: TextStyle(fontSize: 15))),
                        Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              /* Customer Icon */
                              GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SignupComstomer()));
                                  },
                                  child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        SizedBox(
                                            width: min(
                                                17.5.pw(size), 17.5.ph(size)),
                                            child: Icon(
                                                Icons.account_circle_outlined,
                                                size: 7.pw(size))),
                                        SizedBox(height: 1.pw(size)),
                                        const Text("Customer",
                                            style: TextStyle(fontSize: 15))
                                      ])),
                              SizedBox(width: 15.pw(size)),

                              /* Tradesperson Icon */
                              GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SignupTradePerson()));
                                  },
                                  child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        SizedBox(
                                            width: min(
                                                17.5.pw(size), 17.5.ph(size)),
                                            child: Icon(
                                                Icons.account_circle_outlined,
                                                size: 7.pw(size))),
                                        SizedBox(height: 1.pw(size)),
                                        const Text("Tradesperson",
                                            style: TextStyle(fontSize: 15))
                                      ]))
                            ])
                      ]))),
                ]))),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        /*floatingActionButton: isWeb()
            ? null
            : FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back, color: Colors.black87)));*/
        // TODO: Jump to Home Page
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MyApp()));
            },
            child: const Icon(Icons.arrow_back, color: Colors.black87)));
  }
}
