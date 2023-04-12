import 'dart:math';
import 'package:flutter/material.dart';
import 'package:new_cross_app/Login/utils/responsive.dart';
import 'package:string_validator/string_validator.dart';

class AccountDetails extends StatefulWidget {
  final TextEditingController email, password;

  const AccountDetails({
    Key? key,
    required this.email,
    required this.password,
  }) : super(key: key);

  @override
  State<AccountDetails> createState() => AccountDetailsState();
}

class AccountDetailsState extends State<AccountDetails> {
  bool showPassword = false, showConfirmPassword = false;

  @override
  Container build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
        alignment: Alignment.centerLeft,
        child: Wrap(
            alignment: WrapAlignment.start,
            direction: Axis.horizontal,
            spacing: 10,
            children: <Container>[
              /* Email */
              Container(
                  width: 50.ph(size),
                  margin: EdgeInsets.only(bottom: max(1.5.ph(size), 10)),
                  child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textInputAction: TextInputAction.next,
                      controller: widget.email,
                      validator: (String? value) {
                        if ((value == null) || (value.isEmpty)) {
                          return "This value is required.";
                        } else if (!isEmail(value)) {
                          return "Enter a valid email address.";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          labelText: "Email",
                          hintText: "Enter your email address.",
                          labelStyle: TextStyle(fontSize: 14),
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder()))),

              /* Password */
              Container(
                  width: 50.ph(size),
                  margin: EdgeInsets.only(bottom: max(1.5.ph(size), 10)),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.next,
                    controller: widget.password,
                    obscureText: !showPassword,
                    validator: (String? value) {
                      if ((value == null) || (value.isEmpty)) {
                        return "This value is required.";
                      }

                      List<String> o = [];
                      if (!RegExp(r"(?=.*[a-z])(?=.*[A-Z])\w+")
                          .hasMatch(value)) {
                        o.add(
                            "- The value must have at least a Lower and Upper case.");
                      }
                      if (!RegExp(r"(?=.*[0-9])\w+").hasMatch(value)) {
                        o.add(
                            "- The value must have at least a numeric value.");
                      }
                      if (!RegExp(r"(?=.*[#$%&()*+,-./:;<=>?@[\]^_`{|}~])\w+")
                          .hasMatch(value)) {
                        o.add(
                            "- The value must have at least a special character.");
                      }
                      if (value.length < 8) {
                        o.add("- The value must be of at least 8 characters.");
                      }

                      if (o.isNotEmpty) return o.join("\n");
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Enter your Password.",
                      labelStyle: const TextStyle(fontSize: 14),
                      prefixIcon: const Icon(Icons.lock),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                            (showPassword
                                ? Icons.visibility
                                : Icons.visibility_off),
                            color: Theme.of(context).primaryColorDark),
                        onPressed: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                      ),
                    ),
                  )),

              /* Confirm Password */
              Container(
                  width: 50.ph(size),
                  margin: EdgeInsets.only(bottom: max(1.5.ph(size), 10)),
                  child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textInputAction: TextInputAction.next,
                      controller: TextEditingController(text: ""),
                      obscureText: !showConfirmPassword,
                      validator: (String? value) {
                        if ((value == null) || (value.isEmpty)) {
                          return "This value is required";
                        } else if (value != widget.password.text) {
                          return "The value does not match the Password";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        hintText: "Enter to confirm your Password.",
                        labelStyle: const TextStyle(fontSize: 14),
                        prefixIcon: const Icon(Icons.lock),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                              (showConfirmPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              color: Theme.of(context).primaryColorDark),
                          onPressed: () {
                            setState(() {
                              showConfirmPassword = !showConfirmPassword;
                            });
                          },
                        ),
                      )))
            ]));
  }
}
