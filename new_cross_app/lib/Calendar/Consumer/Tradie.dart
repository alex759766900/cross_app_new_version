import 'package:new_cross_app/Calendar/Consumer/User.dart';

import 'ConsumerBookingPage.dart';

class Tradie {
  Tradie(this.name,this.work);
  int id=0;
  String name='';
  String firstname='';
  String address='';
  String work='';
  int workingFrom=8;
  int workingTo=17;
  List<Booking> bookings=<Booking>[];
}