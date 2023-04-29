import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'card_form_screen.dart';

import 'package:flutter/material.dart';


void main() {
  runApp(StripeApp());
}



class StripeApp extends StatelessWidget{
  const StripeApp({Key? key}) : super(key: key);




  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('bookings').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          List<Booking>? list = snapshot.data?.docs
              .map((e) =>
              Booking(
                eventName: e['eventName'] ?? '',
                from: DateFormat('yyyy-MM-dd HH:mm:ss.sss').parse(e['from']),
                to: DateFormat('yyyy-MM-dd HH:mm:ss.sss').parse(e['to']),
                status: e['status'],
                consumerName: e['consumerName'] ?? '',
                tradieName: e['tradieName'] ?? '',
                description: e['description'] ?? '',
                key: e['key'],
                quote: e['quote'] ?? '',
                consumerId: e['consumerId'] ?? '',
                tradieId: e['tradieId'] ?? '',
              ))
              .toList();

        

          return Scaffold(

            appBar: AppBar(
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              title: Text("Check Out"),
            ),
            body: SafeArea(

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text("Request Information",
                        style: TextStyle(fontSize: 30.0)),
                    Container(
                        color: Colors.lightGreen,
                        height: 200.0,
                        child: Row(children: [
                          Image(
                              image: NetworkImage(
                                  'https://www.tradieshirts.com.au/rshared/ssc/i/riq/5717778/1600/1600/t/0/0/Tradie%20Shirts%20Printed%20Sydney1.jpg?1621509120')),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Type of work:"),
                              Text("The number of worker:"),
                              Text("From:"),
                              Text("To:"),
                              Text("Money:"),
                              Text("Name:"),
                              Text("Status:")
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(list![0].eventName),
                              Text("Tradie 1"),
                              Text(list[0].from.toString()),
                              Text(list[0].to.toString()),
                              Text(list[0].quote.toString()),
                              Text(list[0].tradieName),
                              Text(list[0].status)
                            ],
                          ),

                        ])),

                    ElevatedButton(
                        child: Text("make a payment"),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return CardFormScreen();
                              }));
                        }

                    )
                  ],

                )

            ),);
        }
    );
  }



}

class Booking {
  Booking(
      {required this.from,
        required this.to,
        this.status = 'Pending',
        this.eventName = '',
        this.tradieName = '',
        this.consumerName = '',
        this.description = '',
        this.key='',
        this.consumerId='',
        this.tradieId='',
        this.quote = ''});

  final String tradieName;
  final String consumerName;
  final String eventName;
  DateTime from;
  DateTime to;
  String status;
  String description;
  String key;
  String quote;
  String consumerId;
  String tradieId;

}
/*
List<Booking> getBookingDetails(String tradie) {

  List<Booking> bookings = <Booking>[];
  DateTime today = DateTime.now();
  if (tradie == 'Jack') {
    Booking b1 = Booking(
        from: DateTime(today.year, today.month, today.day, 10, 0, 0),
        to: DateTime(today.year, today.month, today.day, 11, 0, 0),
        tradieName: 'Jack',
        consumerName: 'Black',
        eventName: 'Painting',
        status: 'Pending');
    Booking b2 = Booking(
        from: DateTime(today.year, today.month, today.day, 12, 0, 0),
        to: DateTime(today.year, today.month, today.day, 14, 0, 0),
        tradieName: 'Jack',
        consumerName: 'Lance',
        eventName: 'Painting',
        status: 'Pending');
    bookings.add(b1);
    bookings.add(b2);
  } else {
    Booking b1 = Booking(
        from: DateTime(today.year, today.month, today.day, 10, 0, 0),
        to: DateTime(today.year, today.month, today.day, 11, 0, 0),
        tradieName: 'Tom',
        consumerName: 'Black',
        eventName: 'Painting',
        status: 'Pending');
    Booking b2 = Booking(
        from: DateTime(today.year, today.month, today.day, 15, 0, 0),
        to: DateTime(today.year, today.month, today.day, 17, 0, 0),
        tradieName: 'Tom',
        consumerName: 'Lance',
        eventName: 'Painting',
        status: 'Pending');
    bookings.add(b1);
    bookings.add(b2);
  }
  return bookings;
}
*/
