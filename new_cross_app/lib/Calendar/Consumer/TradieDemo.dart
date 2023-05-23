import 'package:flutter/material.dart';
import 'package:new_cross_app/Calendar/Consumer/Consumer.dart';
import 'package:new_cross_app/Calendar/Consumer/ConsumerBookingPage.dart';
import 'package:new_cross_app/Calendar/Consumer/ConsumerProfilePage.dart';
import 'package:new_cross_app/Calendar/Consumer/Tradie.dart';

//ignore: must_be_immutable
class TradieDemo extends StatefulWidget {
  String userId;
  TradieDemo({Key? key, required this.userId}) : super(key: key);

  @override
  TradieDemoState createState() => TradieDemoState();
}

class TradieDemoState extends State<TradieDemo> {
  @override
  Widget build(BuildContext context) {
    String consumer = widget.userId;
    print('tradie selection page consumer ');
    print(consumer);
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
                                        tradie: '93kYkjf3g0OkB2ZLI5yx8krxQb53',
                                        userId: consumer,
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
                                        tradie: '93kYkjf3g0OkB2ZLI5yx8krxQb53',
                                        userId: consumer,

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
