import 'dart:convert';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

main(){
  runApp(Rate());
}
class Rate extends StatefulWidget{
  Rate({Key? key}) : super(key: key);


  @override
  RateState createState() =>RateState();

}

class RateState extends State<Rate>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
            children:[
                  const Text('Tradie Name'),
                  FloatingActionButton(
                      onPressed: () async {
                        final transferresult= await callTransfer(destinationId: 'acct_1JMOJSIQL0S0pNLx', amount: 1);
                        print(transferresult);
                      }
                  )
                ],
              )
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




