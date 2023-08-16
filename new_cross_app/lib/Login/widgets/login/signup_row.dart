//import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
//import 'package:jemma/routes.dart';
//import 'package:new_cross_app/Login/login.dart';
import 'package:new_cross_app/Login/utils/responsive.dart';
import 'package:new_cross_app/Sign_up/signup_customer.dart';

///  Sign up and forgot TextButtons, that are part of the [Login] screen.
class SignupForgotRow extends StatelessWidget {
  /// [size] is the size of the [Login] screen.
  const SignupForgotRow({
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
            onPressed: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SignupComstomer()))
            },
            child: const Text(
              "Don't have an account?   Register here",
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
