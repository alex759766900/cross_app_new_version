import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_cross_app/Login/utils/constants.dart';
import 'package:new_cross_app/Login/utils/responsive.dart';
import 'package:logger/logger.dart';
import 'package:new_cross_app/services/auth_service.dart';
import 'package:sizer/sizer.dart';
import '../main.dart';

class RegisterTradiePage extends StatefulWidget {
  const RegisterTradiePage({Key? key}) : super(key: key);
  @override
  State<RegisterTradiePage> createState() => _RegisterTradiePage();
}

class _RegisterTradiePage extends State<RegisterTradiePage> {

  final TextEditingController licenseController = TextEditingController();
  AuthService authService = AuthService();

  final logger = Logger(
    printer: PrettyPrinter(),
  );

  final jemmaTitle = Center(
    child: FittedBox(
        fit: BoxFit.contain,
        child: Text("Jemma", style: GoogleFonts.parisienne(fontSize: 40.sp))),
  );

  final _formKey = GlobalKey<FormState>();

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

                      SizedBox(height: max(10.ph(size), 20)),

                      // Center the input fields with upload button
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                width: 200,
                                // constraints: BoxConstraints(
                                //     minHeight: 200.ph(size), maxWidth: 200),

                                child: TextField(
                                  controller: licenseController,
                                  decoration: InputDecoration(
                                    labelText: 'Enter tradie license',
                                    hintText: 'Input your tradie license here',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                    ),
                                  ),
                                )),
                            SizedBox(width: 10), // Adjust the gap as needed
                            //upload license picture
                            ElevatedButton(
                              onPressed: () {
                                // add more code to upload the license picture
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kLogoColor, // color
                                minimumSize: Size(50, 50), // button size
                              ),
                              child: Icon(Icons.upload), // logo
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: max(10.ph(size), 20)),

                      // Register button
                      ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 100),
                          child: SizedBox(
                            width: 100,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: const StadiumBorder(),
                                  padding: const EdgeInsets.all(20),
                                  backgroundColor: kLogoColor),
                              onPressed: () {},
                              child: const Text(
                                "Register",
                                overflow: TextOverflow.visible,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          )),

                      SizedBox(height: max(1.75.ph(size), 10)),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyApp()));
          },
          child: const Icon(Icons.arrow_back, color: Colors.black87),
        ));
  }

}
