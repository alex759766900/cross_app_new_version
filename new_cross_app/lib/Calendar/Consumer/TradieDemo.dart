import 'package:flutter/material.dart';
import 'package:new_cross_app/Calendar/Consumer/ConsumerBookingPage.dart';

//ignore: must_be_immutable
class TradieDemo extends StatefulWidget {
  const TradieDemo({Key? key}) : super(key: key);

  @override
  TradieDemoState createState() => TradieDemoState();
}
class TradieDemoState extends State<TradieDemo>{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 60,
              color: Colors.blue,
              child: TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> new ConsumerBooking(tradie: 'Tom',work: 'Painting')));
                },
                child: const Text('Tom',selectionColor: Colors.black,),

              ),

            ),
            Container(
              width: 80,
              height: 60,
              color: Colors.purple,
              child: TextButton(
                onPressed: () {

                },
                child: const Text('Jack',selectionColor: Colors.black,),

              ),
            )
          ],
        ),
      ),

    );
  }

}