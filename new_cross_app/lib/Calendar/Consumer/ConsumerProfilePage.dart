library booking_Calendar;

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:new_cross_app/Calendar/Consumer/Consumer.dart';
import 'package:new_cross_app/Calendar/Consumer/TradieDemo.dart';
import 'package:new_cross_app/main.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'ConsumerBookingPage.dart';

part 'StatusPicker.dart';

part 'AppointmentEditor.dart';


//ignore: must_be_immutable
class ConsumerProfilePage extends StatefulWidget {
  String consumer='';
  ConsumerProfilePage({Key? key, required  this.consumer}) : super(key: key);

  @override
  ConsumerProfileState createState() => ConsumerProfileState(this.consumer);
}

//Variables
List<Color> _colorCollection = <Color>[];
List<String> _colorNames = <String>[];
int _selectedStatusIndex = 0;
List<String> _statusNames = <String>[];
String _consumer = '';
List<Booking> ls = <Booking>[];
late DataSource _events = DataSource(ls);
Booking? _selectedAppointment;
String _tradie = '';
late DateTime _startDate;
late TimeOfDay _startTime;
late DateTime _endDate;
late TimeOfDay _endTime;
bool _isAllDay = false;
String _subject = '';
String _notes = '';
final databaseReference = FirebaseFirestore.instance;


class ConsumerProfileState extends State<ConsumerProfilePage> {
  String consumer='';
  late DocumentReference docRef;
  late Stream<QuerySnapshot> _usersStream;
  ConsumerProfileState(String consumer){
    docRef = databaseReference.collection('consumer').doc(consumer);
    docRef.snapshots().listen(
          (event) => print("current data: ${event.data()}"),
      onError: (error) => print("Listen failed: $error"),
    );
    _usersStream = docRef.collection('bookings').snapshots();

  }



  final List<String> options = <String>['Add', 'Delete', 'Update'];

  late List<String> eventNameCollection;
  late List<Booking> appointments = <Booking>[];
  CalendarController calendarController = CalendarController();

  //Calendar Initialisation
  @override
  void initState() {
    addListDetails();
    super.initState();
  }

 
  //Main Page
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
        List<Booking> list = snapshot.data!.docs
            .map((e) => Booking(
          eventName: e['Subject'] ?? '',
          from: DateFormat('dd/MM/yyyy HH:mm:ss')
              .parse(e['StartTime']),
          to: DateFormat('dd/MM/yyyy HH:mm:ss').parse(e['EndTime']),
          status: e['Status'],
          consumerName: e['Consumer'] ?? '',
          tradieName: e['Tradie'] ?? '',
          description: e['Description'] ?? '',
        ))
            .toList();
        _events = DataSource(list);

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
            body: getEventCalendar(_events, onCalendarTapped));
      },
    );
  }

  //Set up Calendar
  SfCalendar getEventCalendar(
      DataSource _calendarDataSource, CalendarTapCallback calendarTapCallback) {
    return SfCalendar(
        view: CalendarView.month,
        controller: calendarController,
        //Display Mode:
        allowedViews: const [CalendarView.week, CalendarView.month],
        dataSource: _calendarDataSource,
        onTap: calendarTapCallback,

        //看不懂的部分

        appointmentBuilder: (context, calendarAppointmentDetails) {
          final Booking meeting = calendarAppointmentDetails.appointments.first;
          //Container for every meeting
          return Container(
            color: _colorCollection[_statusNames.indexOf(meeting.status==''?'Pending':meeting.status)]
                .withOpacity(0.5),
            child: Center(
              child: Text(
                meeting.eventName,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
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

    if (calendarTapDetails.targetElement != CalendarElement.calendarCell &&
        calendarTapDetails.targetElement != CalendarElement.appointment) {
      return;
    } else {
      calendarController.view = CalendarView.day;
      /*if (calendarController.view == CalendarView.month) {
        calendarController.view = CalendarView.day;
      }*/
      if (calendarTapDetails.targetElement != CalendarElement.calendarCell) {
        setState(() {
          _selectedAppointment = null;
          _isAllDay = false;
          _selectedStatusIndex = 0;
          //_selectedTimeZoneIndex = 0;
          _subject = '';
          _notes = '';
          _tradie = '';
          if (calendarTapDetails.appointments != null &&
              calendarTapDetails.appointments!.length == 1) {
            final Booking meetingDetails = calendarTapDetails.appointments![0];
            _startDate = meetingDetails.from;
            _endDate = meetingDetails.to;
            _selectedStatusIndex = _statusNames.indexOf(meetingDetails.status);
            _tradie = meetingDetails.tradieName;
            /*_selectedTimeZoneIndex = meetingDetails.startTimeZone == ''
              ? 0
              : _timeZoneCollection.indexOf(meetingDetails.startTimeZone);*/
            _subject = meetingDetails.eventName == '(No title)'
                ? ''
                : meetingDetails.eventName;
            _notes = meetingDetails.description;
            _selectedAppointment = meetingDetails;
            //如果返回appointments 为null，则说明是新的meeting,根据点击的时间点设置信息，并且跳转到appointment editor
          } else {
            final DateTime date = calendarTapDetails.date!;
            _startDate = date;
            _endDate = date.add(const Duration(hours: 1));
          }
          //点击当前存在的meeting只会返回list length 为1.

          _startTime =
              TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
          _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);
          Navigator.push<Widget>(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => AppointmentEditor()),
          );
        });
      }
    }

    /*if(calendarTapDetails.targetElement!=CalendarElement.appointment){
      return;
    }else{
      if (calendarController.view == CalendarView.month) {
        calendarController.view = CalendarView.day;
      }
    }*/
  }

  void addListDetails() {
    //_colorCollection = <Color>[];
    _colorCollection.add(const Color(0xFF0F8644));
    _colorCollection.add(const Color(0xFF8B1FA9));
    _colorCollection.add(const Color(0xFFD20100));
    _colorCollection.add(const Color(0xFFFC571D));
    _colorCollection.add(const Color(0xFF85461E));
    _colorCollection.add(const Color(0xFFFF00FF));
    _colorCollection.add(const Color(0xFF3D4FB5));
    _colorCollection.add(const Color(0xFFE47C73));
    _colorCollection.add(const Color(0xFF636363));

    //_colorNames = <String>[];
    _colorNames.add('Green');
    _colorNames.add('Purple');
    _colorNames.add('Red');
    _colorNames.add('Orange');
    _colorNames.add('Caramel');
    _colorNames.add('Magenta');
    _colorNames.add('Blue');
    _colorNames.add('Peach');
    _colorNames.add('Gray');

    _statusNames.add('Pending');
    _statusNames.add('Confirmed');
    _statusNames.add('Working');
    _statusNames.add('Rating');
    _statusNames.add('Complete');
  }

}
