//import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
//import 'package:jemma/routes.dart';
import 'package:new_cross_app/Sign_up/signup_customer.dart';
import 'package:new_cross_app/Sign_up/signup_tradeperson.dart';
import 'package:new_cross_app/Login/utils/responsive.dart';

///  Sign up with Google account, that are part of the [Sign Up] screen.
class SignupGoogle extends StatelessWidget {
  /// [size] is the size of the [Sign Up] screen.
  const SignupGoogle({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // For Sign up
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
            ),
            onPressed: () {
              //Navigator.pushNamed(
              //context, Screen.signup.getURL()); //TODO:need navigate to sign up with google page
            },
            child: const Text(
              'Sign up with Google account',
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
          ),
          SizedBox(
            width: 2.pw(size),
          ),
        ],
      ),
    );
  }
}
