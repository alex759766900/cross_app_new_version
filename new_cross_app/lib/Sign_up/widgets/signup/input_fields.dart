import 'dart:math';

//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
import 'package:new_cross_app/Sign_up/signup_customer.dart';
import 'package:new_cross_app/Login/utils/responsive.dart';
import 'package:string_validator/string_validator.dart';

/// Email and password TextFormFields, that are part of [Sign Up].
class InputFields extends StatelessWidget {
  /// [emailController] which will be used to fetch email input in [Sign Up].
  /// [passwordController] which will be used to fetch the password input in [Sign Up].
  /// [size] is the size of the [Sign Up] screen.
  const InputFields({
    Key? key,
    required this.fullnameController,
    required this.emailController,
    required this.passwordController,
    required this.size,
  }) : super(key: key);

  final TextEditingController fullnameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final Size size;
  // String email = "";
  // String password = "";
  // String fullName = "";
  //final TextEditingController fullnameController = TextEditingController();
  //final TextEditingController emailController = TextEditingController();
  //final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //var size = MediaQuery.of(context).size;
    return Center(
      child: Column(children: [
        // For Fullname
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.name],
          validator: (value) {
            String patttern = r'^[a-z A-Z,.\-]+$';
            RegExp regExp = RegExp(patttern);
            if (value == null || regExp.hasMatch(value)) {
              return null;
            }
            return "Enter a valid fullname.";
          },
          controller: fullnameController,
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Fullname',
              labelStyle: TextStyle(fontSize: 14),
              prefixIcon: Icon(
                Icons.person,
              ),
              hintText: 'Enter your fullname.'),
        ),

        SizedBox(height: max(1.5.ph(size), 10)),

        // For Email
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.email],
          validator: (value) {
            if (value == null || isEmail(value)) {
              return null;
            }
            return "Enter a valid email address.";
          },
          controller: emailController,
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Email',
              labelStyle: TextStyle(fontSize: 14),
              prefixIcon: Icon(
                Icons.email,
              ),
              hintText: 'Enter your email address.'),
        ),

        SizedBox(height: max(1.5.ph(size), 10)),

        // For password
        TextFormField(
          controller: passwordController,
          obscureText: true,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          autofillHints: const [AutofillHints.password],
          textInputAction: TextInputAction.done,
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              return null;
            }
            return "Enter your password.";
          },
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelStyle: TextStyle(fontSize: 14),
              labelText: 'Password',
              prefixIcon: Icon(
                Icons.lock,
              ),
              hintText: 'Enter your password.'),
        ),
      ]),
    );
  }
}
