import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:new_cross_app/Login/providers/login.dart';
//import 'package:jemma/routes.dart';
//import 'package:new_cross_app/Login/utils/adaptive.dart';
import 'package:new_cross_app/Login/utils/constants.dart';
import 'package:new_cross_app/Login/utils/notification.dart';
import 'package:new_cross_app/Login/utils/responsive.dart';
import 'package:new_cross_app/Sign_up/signup.dart';
import 'package:new_cross_app/Sign_up/widgets/signup/decoration_image_container.dart';
import 'package:new_cross_app/Sign_up/widgets/signup/input_fields.dart';
import 'package:new_cross_app/Sign_up/widgets/signup/show_snackbar.dart';
import 'package:new_cross_app/Sign_up/widgets/signup/signup_google_row.dart';
import 'package:logger/logger.dart';
import 'package:new_cross_app/services/auth_service.dart';
//import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../main.dart';

/// Screen through which Trade person users can Sign up.
///
/// Idea of using SizedBox for spacing instead of padding is from this:
/// https://stackoverflow.com/a/52774984/11200630
class SignupTradePerson extends StatefulWidget {
  const SignupTradePerson({Key? key}) : super(key: key);

  @override
  State<SignupTradePerson> createState() => _SignupTradePersonPageState();
}

class _SignupTradePersonPageState extends State<SignupTradePerson> {
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final logger = Logger(
    printer: PrettyPrinter(),
  );

  final jemmaTitle = Center(
    child: FittedBox(
        fit: BoxFit.contain,
        child: Text("Jemma", style: GoogleFonts.parisienne(fontSize: 40.sp))),
  );

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: 100.ph(size)),
            child: Stack(
              children: [
                SingleChildScrollView(
                  // Allow scrolling if screen size is too small
                  child: Form(
                    key: _formKey,
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      // Jemma title
                      ConstrainedBox(
                          constraints: BoxConstraints(minHeight: 30.ph(size)),
                          child: jemmaTitle),

                      // Input fields
                      ConstrainedBox(
                          constraints: BoxConstraints(
                              minHeight: 20.ph(size), maxWidth: 300),
                          child: InputFields(
                              fullnameController: fullnameController,
                              emailController: emailController,
                              passwordController: passwordController,
                              size: size)),

                      SizedBox(height: max(1.25.ph(size), 7.5)),

                      // Sign Up button
                      ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 100),
                          child: SizedBox(
                            width: 100,
                            child: ElevatedButton(
                              onPressed: () {
                                registerTradie();
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: const StadiumBorder(),
                                  padding: const EdgeInsets.all(20),
                                  backgroundColor: kLogoColor),
                              child: const Text(
                                "Sign Up",
                                overflow: TextOverflow.visible,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          )),

                      SizedBox(height: max(1.75.ph(size), 10)),

                      SignupGoogle(size: size)
                    ]),
                  ),
                ),

                // Decoration Image
                Positioned.fill(
                  child: Align(
                    alignment: const Alignment(0.7, 1),
                    child: TradieImageContainer(size: size),
                  ),
                )
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,

        /*floatingActionButton: isWeb()? null: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () { Navigator.pop(context);},
          child: const Icon(Icons.arrow_back, color: Colors.black87),
        )*/
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () => {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Signup()))
          },
          child: const Icon(Icons.arrow_back, color: Colors.black87),
        ));
  }

  registerTradie() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerTradepersonWithEmailAndPassword(fullnameController.text,
              emailController.text, passwordController.text)
          .then((value) {
        if (value == true) {
          // saving the shared preference state
        } else {
          showSnackbar(context, kMenuColor, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
