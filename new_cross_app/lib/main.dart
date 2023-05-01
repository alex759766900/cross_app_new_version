import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_cross_app/Calendar/Consumer/Consumer.dart';
import 'package:new_cross_app/Calendar/Consumer/ConsumerProfilePage.dart';
import 'package:new_cross_app/Calendar/Consumer/TradieDemo.dart';
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
import 'package:new_cross_app/Profile/profile.dart';
//import 'package:new_cross_app/chat/chat_home_page.dart';
import 'package:provider/provider.dart';
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
    //name: "jemma",
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //configureApp();
  // initialise();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.green,
        ),
        // home: const MyHomePage(title: 'Jemma'),
        routes: {
          '/': (context) => MyHomePage(title: 'Jemma'),
          '/login': (context) => LoginPage(),
          '/profile': (context) => Profile(),
          '/not_logged_in': (context) => NotLoggedInPage(),
        },
      );
    });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

Consumer_person consumer = Consumer_person('Lance');

FirebaseFirestore db = FirebaseFirestore.instance;

getFirebaseExample() {
  var data;
  final docRef = db.collection("users").doc("consumer");
  docRef.get().then(
    (DocumentSnapshot doc) {
      data = doc.data() as Map<String, dynamic>;
      print(data);
      return data;
      // ...
    },
    onError: (e) => print("Error getting document: $e"),
  );
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    //var mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.lightGreen,
              ),
              child: Text(
                'Menu',
              ),
            ),
            ListTile(
              title: const Text('Consumer Calendar'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ConsumerProfilePage(
                            consumer: 'kmWX5dwrYVnmfbQjMxKX')));
              },
            ),
            ListTile(
              title: const Text('Tradie Calendar'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TradieProfilePage(
                              // tradie id in Firebase
                              tradie: '7ylyCreV44uORAfvRxJT',
                            )));
              },
            ),
            ListTile(
              title: const Text('Tradie Selection'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TradieDemo(
                              consumer: consumer,
                            )));
              },
            ),
            // Stripe CardPayment
            ListTile(
              title: const Text('Stripe Payment'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CardFormScreen()));
              },
            ),
            ListTile(
              title: const Text('FirebaseTest'),
              onTap: () {
                var data = getFirebaseExample();
              },
            ),
            ListTile(
              title: const Text('LoginTest'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
            ),
            ListTile(
              title: const Text('Sign Up Test'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Signup()));
              },
            ),
            ListTile(
              title: const Text('Chat home page Test'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const ChatRoom()));
              },
            ),
            ListTile(
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Profile()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
