//import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:new_cross_app/Login/utils/responsive.dart';
import 'package:new_cross_app/Sign_up/signup_customer.dart';
import 'package:new_cross_app/Sign_up/signup_tradeperson.dart';

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
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MyApp()));
            },
            child: const Icon(Icons.arrow_back, color: Colors.black87)));
  }
}
