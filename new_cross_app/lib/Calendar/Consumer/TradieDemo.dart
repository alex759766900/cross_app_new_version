import 'package:flutter/material.dart';
import 'package:new_cross_app/Calendar/Consumer/Consumer.dart';
import 'package:new_cross_app/Calendar/Consumer/ConsumerBookingPage.dart';
import 'package:new_cross_app/Calendar/Consumer/ConsumerProfilePage.dart';
import 'package:new_cross_app/Calendar/Consumer/Tradie.dart';

//ignore: must_be_immutable
class TradieDemo extends StatefulWidget {
  Consumer_person consumer;
  TradieDemo({Key? key, required this.consumer}) : super(key: key);

  @override
  TradieDemoState createState() => TradieDemoState();
}

class TradieDemoState extends State<TradieDemo> {
  @override
  Widget build(BuildContext context) {
    Consumer_person consumer = widget.consumer;
    return Scaffold(
        appBar: AppBar(
          title: Text('Select Tradie'),
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Container(
                          width: 150,
                          height: 150,
                          child: Image(
                            image: AssetImage('images/Tom.jpg'),
                          )),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => new ConsumerBooking(
                                        tradie: 'Tom',
                                        work: 'Wall Repair',
                                      )));
                        },
                        child: const Text(
                          'Tom',
                          textScaleFactor: 5.0,
                          selectionColor: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                          width: 150,
                          height: 150,
                          child: Image(
                            image: AssetImage('images/Jack.jpg'),
                          )),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => new ConsumerBooking(
                                        tradie: 'Jack',
                                        work: 'Wall Repair',
                                      )));
                        },
                        child: const Text(
                          'Jack',
                          textScaleFactor: 5.0,
                          selectionColor: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
