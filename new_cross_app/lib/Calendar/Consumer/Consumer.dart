import 'package:new_cross_app/Calendar/Consumer/User.dart';

import 'ConsumerBookingPage.dart';

class Consumer extends User{
  Consumer(this.name);
  String id='';
  String name='';
  String address='';
  List<Booking> bookings=<Booking>[];
}