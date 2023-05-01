import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_cross_app/blocs/payment/payment_bloc.dart';
import 'package:new_cross_app/stripe/screens/card_form_screen.dart';
import 'package:new_cross_app/stripe/screens/.env';

// import 'package:flutter_stripe_web/flutter_stripe_web.dart';

//import 'package:stripe/stripe.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

/// sk_test_51MxqKoCLNEXP0Gmv34Ixc05ATpLLTkXxK1VmLe4rng6eaiPqiyiDn5iYhaeGA9iZXEdDYIEDZDuTQMMvy4lRKW3J003L5D13iI
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      stripePublishableKey; //JemmaAUGroup@gmail.com code:JemmaTeam2023
  await Stripe.instance.applySettings();
  // TODO Replace with your actual merchant identifier
  //Stripe.merchantIdentifier = 'YOUR_MERCHANT_IDENTIFIER';
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentBloc(),
      child: MaterialApp(
        title: 'Jemma Australia',
        theme: ThemeData(
          colorScheme: const ColorScheme.light(
              primary: Color(0xFF000A1F), secondary: Color(0xFF000A1F)),
          // primarySwatch: Colors.green,
          primaryColor: Colors.white,
        ),
        home: const CardFormScreen(),
        // HomeScreen,
      ),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//   final String title;
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// Consumer consumer = Consumer('Lance');
//
// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Home Page"),
//       ),
//       //TODO:
//       // body: ,
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             const DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Colors.lightGreen,
//               ),
//               child: Text('Menu'),
//             ),
//             ListTile(
//               title: const Text('Consumer Calendar'),
//               onTap: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) =>
//                             ConsumerProfilePage(consumer: consumer)));
//               },
//             ),
//             ListTile(
//               title: const Text('Tradie Selection'),
//               onTap: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => TradieDemo(
//                               consumer: consumer,
//                             )));
//               },
//             ),
//             // Stripe CardPayment
//             ListTile(
//               title: const Text('Stripe Payment'),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => CardFormScreen()),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
