library booking_calendar;

//import 'dart:js_util';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_cross_app/Calendar/Consumer/Consumer.dart';
import 'package:new_cross_app/Calendar/Consumer/ConsumerProfilePage.dart';
import 'package:new_cross_app/Calendar/Consumer/Tradie.dart';
import 'package:new_cross_app/Calendar/Consumer/TradieDemo.dart';
import 'package:new_cross_app/main.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
part 'BookingEditor.dart';

class ConsumerBooking extends StatefulWidget {
  String tradie;

  ConsumerBooking({Key? key, required this.tradie})
      : super(key: key);

  @override
  ConsumerBookingState createState() => ConsumerBookingState(tradie);
}

//Variables
List<Color> _colorCollection = <Color>[];
List<String> _colorNames = <String>[];
int _selectedStatusIndex = 0;
List<String> _statusNames = <String>[];
String _tradie = '';
String _work = '';
String selectedKey='';
String _tradieName = '';
String _consumerName='';
late DataSource _bookings;
Booking? _selectedAppointment;
String _consumer ='kmWX5dwrYVnmfbQjMxKX';
String _consumerId='';
String _tradieId='';
late DateTime _startDate;
late TimeOfDay _startTime;
late DateTime _endDate;
late TimeOfDay _endTime;
bool _isAllDay = false;
String _subject = '';
String _notes = '';

class ConsumerBookingState extends State<ConsumerBooking> {
  late Stream<QuerySnapshot> _usersStream;
  String tradie;
  ConsumerBookingState(this.tradie){
    _tradieId=this.tradie;
    print(_consumerId);
    colRef.where('tradieId', isEqualTo: _tradieId).snapshots().listen(
          (event) => print("get query"+_tradieId),

      onError: (error) => print("Listen failed: $error"),
    );
    _usersStream = colRef.where('tradieId', isEqualTo: _tradieId).snapshots();
  }

  late List<Booking> appointments;
  CalendarController calendarController = CalendarController();
  @override
  void initState() {
    appointments = getBookingDetails(_tradie);
    _bookings = DataSource(appointments);
    _selectedAppointment = null;
    _selectedStatusIndex = 0;
    _subject = '';
    _notes = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        List<Booking>? list = snapshot.data?.docs
            .map((e) => Booking(
          eventName: e['eventName'] ?? '',
          from: DateFormat('yyyy-MM-dd HH:mm:ss.sss').parse(e['from']),
          to: DateFormat('yyyy-MM-dd HH:mm:ss.sss').parse(e['to']),
          status: e['status'],
          consumerName: e['consumerName'] ?? '',
          tradieName: e['tradieName'] ?? '',
          description: e['description'] ?? '',
          key: e['key'],
          consumerId: e['consumerId'] ?? '',
          tradieId: e['tradieId'] ?? '',
        ))
            .toList();
        _bookings = DataSource(list!);

        return Scaffold(
            appBar: AppBar(
                leading: IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                      Icons.arrow_back
                  ),
                )
            ),
            resizeToAvoidBottomInset: true,
            body: getBookingCalendar(_bookings, onCalendarTapped));
      },
    );
  }

  SfCalendar getBookingCalendar(
      CalendarDataSource dataSource, CalendarTapCallback calendarTapCallback) {
    print(appointments.length);
    print(appointments.first);
    return SfCalendar(
        view: CalendarView.month,
        controller: calendarController,
        //Display Mode:
        allowedViews: const [CalendarView.week, CalendarView.month],
        dataSource: dataSource,
        onTap: calendarTapCallback,
        appointmentBuilder: (context, calendarAppointmentDetails) {
          final Booking booking = calendarAppointmentDetails.appointments.first;
          //Container for every meeting
          if (booking.consumerId != _consumer) {
            return Container(
              color: Colors.deepOrange.withOpacity(0.5),
              child: Text('Unavaliable'),
            );
          } else {
            return Container(
              color: Colors.lightGreen.withOpacity(0.5),
              child: Text(booking.eventName),
            );
          }
        },
        initialDisplayDate: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 0, 0, 0),
        monthViewSettings: const MonthViewSettings(
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
        //Minimum appointment duration set to be 60 mins
        timeSlotViewSettings: const TimeSlotViewSettings(
            minimumAppointmentDuration: Duration(minutes: 60)));
  }

  void onCalendarTapped(CalendarTapDetails calendarTapDetails) {
    print(calendarTapDetails.targetElement.name);
    if (calendarController.view == CalendarView.month) {
      if (calendarTapDetails.targetElement != CalendarElement.calendarCell &&
          calendarTapDetails.targetElement != CalendarElement.appointment) {
        return;
      } else if (calendarTapDetails.targetElement ==
          CalendarElement.calendarCell) {
        calendarController.view = CalendarView.day;
      }
    } else if (calendarController.view == CalendarView.day) {
      if (calendarTapDetails.targetElement != CalendarElement.calendarCell &&
          calendarTapDetails.targetElement != CalendarElement.appointment) {
        return;
      } else {
        setState(() {
          _selectedAppointment = null;
          _selectedStatusIndex = 0;
          //_selectedTimeZoneIndex = 0;
          _subject = _work;
          _notes = '';
          //_tradie=_tradie;
          if (calendarTapDetails.appointments != null &&
              calendarTapDetails.appointments!.length == 1) {
            final Booking meetingDetails = calendarTapDetails.appointments![0];
            _selectedAppointment = meetingDetails;
            if (meetingDetails.consumerId == _consumer) {
              _startDate = meetingDetails.from;
              _endDate = meetingDetails.to;
              _selectedStatusIndex =
                  _statusNames.indexOf(meetingDetails.status);
              _tradieName = meetingDetails.tradieName;
              _consumerName=meetingDetails.consumerName;
              _subject = meetingDetails.eventName;
              _notes = meetingDetails.description;
              selectedKey=meetingDetails.key;
              _consumerId=meetingDetails.consumerId;
              _tradieId=meetingDetails.tradieId;

              Navigator.push<Widget>(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => BookingEditor()),
              );
            }
            //如果返回appointments 为null，则说明是新的meeting,根据点击的时间点设置信息，并且跳转到appointment editor
          } else {
            final DateTime date = calendarTapDetails.date!;
            _startDate = date;
            _endDate = date.add(const Duration(hours: 1));
            _startTime =
                TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
            _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);
            Navigator.push<Widget>(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => BookingEditor()),
            );
          }
        });
      }
    }
  }
}

class DataSource extends CalendarDataSource {
  DataSource(List<Booking> source) {
    appointments = source;
  }

  @override
  String getSubject(int index) => appointments![index].eventName;

  //@override
  //String getStartTimeZone(int index) => appointments![index].startTimeZone;

  @override
  String getNotes(int index) => appointments![index].description;

  /*@override
  String getTradie(int index)=>appointments![index].toString();*/
  //@override
  //String getEndTimeZone(int index) => appointments![index].endTimeZone;

  /*@override
  Color getColor(int index) => appointments![index].status;*/

  @override
  DateTime getStartTime(int index) => appointments![index].from;

  @override
  DateTime getEndTime(int index) => appointments![index].to;
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
      this.tradieId=''});

  final String tradieName;
  final String consumerName;
  final String eventName;
  DateTime from;
  DateTime to;
  String status;
  String description;
  String key;
  String consumerId;
  String tradieId;
}

List<Booking> getBookingDetails(String tradie) {
  _statusNames.add('Pending');
  _statusNames.add('Confirmed');
  _statusNames.add('Working');
  _statusNames.add('Rating');
  _statusNames.add('Complete');

  _colorCollection = <Color>[];
  _colorCollection.add(const Color(0xFF0F8644));
  _colorCollection.add(const Color(0xFF8B1FA9));
  _colorCollection.add(const Color(0xFFD20100));
  _colorCollection.add(const Color(0xFFFC571D));
  _colorCollection.add(const Color(0xFF85461E));
  _colorCollection.add(const Color(0xFFFF00FF));
  _colorCollection.add(const Color(0xFF3D4FB5));
  _colorCollection.add(const Color(0xFFE47C73));
  _colorCollection.add(const Color(0xFF636363));
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
