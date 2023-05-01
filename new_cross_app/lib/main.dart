import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_cross_app/Calendar/Consumer/Consumer.dart';
import 'package:new_cross_app/Calendar/Consumer/ConsumerProfilePage.dart';
import 'package:new_cross_app/Calendar/Consumer/TradieDemo.dart';
import 'package:new_cross_app/Home%20Page/home.dart';
import 'package:new_cross_app/Profile/profile.dart';
import 'package:new_cross_app/Routes/route_config.dart';
import 'package:new_cross_app/Sign_up/signup_customer.dart';
import 'package:new_cross_app/Sign_up/signup_tradeperson.dart';
import 'package:new_cross_app/chat/screens/chat_screen.dart';
import 'package:new_cross_app/chat/screens/chat_home_screen.dart';
//import 'package:new_cross_app/chat/chatting/screens/chat_home_screen.dart';
import 'package:new_cross_app/stripe/card_form_screen.dart';
import 'package:new_cross_app/stripe/cardpayment.dart';
import 'package:new_cross_app/Calendar/Tradie/TradieProfilePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:new_cross_app/Login/login.dart';
import 'package:new_cross_app/Login/not_logged_in_page.dart';
import 'package:new_cross_app/Sign_up/signup.dart';
//import 'package:new_cross_app/chat/chat_home_page.dart';
//import 'package:new_cross_app/chat/chat_home_page.dart';
import 'package:new_cross_app/chat/screens/chat_home_screen.dart';
import 'package:new_cross_app/stripe/check_out.dart';
import 'package:provider/provider.dart';
import 'Calendar/RatePage.dart';
import 'Login/providers/login.dart';
import 'firebase_options.dart';

import 'package:hive/hive.dart';
import 'package:new_cross_app/Login/repository.dart';
//import 'package:jemma/routes.dart';
import 'package:sizer/sizer.dart';
import 'Login/config/configure_non_web.dart'
    if (dart.library.html) 'Login/config/configure_web.dart';
import 'package:logger/logger.dart';
import 'package:hive_flutter/hive_flutter.dart';

final logger = Logger(
  printer: PrettyPrinter(),
);

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        routeInformationParser: MyRouter().router.routeInformationParser,
        routerDelegate: MyRouter().router.routerDelegate,
      );
    });
  }
}

