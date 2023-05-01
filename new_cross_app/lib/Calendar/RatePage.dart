// import 'dart:convert';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// main(){
//   runApp(Rate());
// }
// class Rate extends StatefulWidget{
//   Rate({Key? key}) : super(key: key);
//
//
//   @override
//   RateState createState() =>RateState();
//
// }
//
// class RateState extends State<Rate>{
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//           child: Column(
//             children:[
//                   const Text('Tradie Name'),
//                   FloatingActionButton(
//                       onPressed: () async {
//                         final transferresult= await callTransfer(destinationId: 'acct_1JMOJSIQL0S0pNLx', amount: 1);
//                         print(transferresult);
//                       }
//                   )
//                 ],
//               )
//           ),
//     );
//   }
//
// }
// Future<Map<String, dynamic>> callTransfer({
//   required String destinationId,
//   required num amount,
// }) async {
//   final url = Uri.parse(
//       'https://us-central1-jemma-b0fcd.cloudfunctions.net/StripeTransfer');
//
//   final response = await http.post(
//     url,
//     headers: {'Content-Type': 'application/json'},
//     body: json.encode(
//       {
//         'destination_id': destinationId,
//         'amount': amount,
//       },
//     ),
//   );
//
//   return jsonDecode(response.body);
// }

import 'dart:convert';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart'; // 添加这一行导入RatingBar库
import 'package:http/http.dart' as http;
import 'package:new_cross_app/Calendar/Tradie/TradieProfilePage.dart';


class Rate extends StatefulWidget {
  String bookingId;
  Rate({Key? key,required this.bookingId}) : super(key: key);

  @override
  RateState createState() => RateState();
}

class RateState extends State<Rate> {
  double rating = 3;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Rating Page')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Tutorial', style: TextStyle(fontSize: 40),),
              const SizedBox(height: 8),
              const Text('Date: 05/05/2023', style: TextStyle(fontSize: 10),),
              const SizedBox(height: 8),
              const Text('Tradie: Frank', style: TextStyle(fontSize: 10),),
              const SizedBox(height: 8),
              Text('Rating: $rating', style: TextStyle(fontSize: 40),),
              const SizedBox(height: 8),
              RatingBar.builder(
                initialRating: 3,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) => setState(() {
                  this.rating = rating;
                })
              ),
              FloatingActionButton(
                onPressed: () async {
                  final transferresult = await callTransfer(
                      destinationId: 'acct_1JMOJSIQL0S0pNLx', amount: 1);
                  print(transferresult);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<Map<String, dynamic>> callTransfer({
  required String destinationId,
  required num amount,
}) async {
  final url = Uri.parse(
      'https://us-central1-jemma-b0fcd.cloudfunctions.net/StripeTransfer');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode(
      {
        'destination_id': destinationId,
        'amount': amount,
      },
    ),
  );

  return jsonDecode(response.body);
}




