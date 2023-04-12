import 'package:new_cross_app/Calendar/Consumer/User.dart';

import 'ConsumerBookingPage.dart';

class Consumer {
  Consumer(this.name);
  int id=0;
  String name='';
  String firstname='';
  String address='';
  List<Booking> bookings=<Booking>[];
}