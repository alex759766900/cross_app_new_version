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

  //String consumer='';
  ConsumerProfilePage({Key? key,required Consumer_person consumer}) : super(key: key);

  @override
  ConsumerProfileState createState() => ConsumerProfileState();
}
//Variables
List<Color> _colorCollection = <Color>[];
List<String> _colorNames = <String>[];
int _selectedStatusIndex = 0;
List<String> _statusNames=<String>[];
final Consumer_person _consumer=new Consumer_person('Lance');
late DataSource _events;
Booking? _selectedAppointment;
String _tradie='';
late DateTime _startDate;
late TimeOfDay _startTime;
late DateTime _endDate;
late TimeOfDay _endTime;
bool _isAllDay = false;
String _subject = '';
String _notes = '';

class ConsumerProfileState extends State<ConsumerProfilePage> {
  final List<String> options = <String>['Add', 'Delete', 'Update'];
  final databaseReference = FirebaseFirestore.instance;
  //ConsumerProfileState();
  late List<String> eventNameCollection;
  late List<Booking> appointments=<Booking>[];
  CalendarController calendarController = CalendarController();
  initializeFirestore() async{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }
  //Calendar Initialisation
  @override
  void initState() {
    getDataFromFireStore().then((results) {
      SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
        setState(() {});
      });
    });
    super.initState();
  }

  Future<void> getDataFromFireStore() async {
    var snapShotsValue = await databaseReference
        .collection("CalendarAppointmentCollection")
        .get();

    final Random random = new Random();
    List<Booking> list = snapShotsValue.docs
        .map((e) => Booking(
        eventName: e.data()['Subject'],
        from:
            DateFormat('dd/MM/yyyy HH:mm:ss').parse(e.data()['StartTime']),
        to: DateFormat('dd/MM/yyyy HH:mm:ss').parse(e.data()['EndTime']),
        //background: _colorCollection[random.nextInt(9)],
        //isAllDay: false)
         ))
        .toList();
    setState(() {
      _events = DataSource(list);
    });
  }

  //Main Page
  @override
  Widget build(BuildContext context) {
    initializeFirestore();
    return Scaffold(
      appBar: AppBar(
          leading: PopupMenuButton<String>(
            icon: Icon(Icons.settings),
            itemBuilder: (BuildContext context) => options.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList(),
            onSelected: (String value) {
              if (value == 'Add') {
                databaseReference
                    .collection("CalendarAppointmentCollection")
                    .doc("1")
                    .set({
                  'Subject': 'Mastering Flutter',
                  'StartTime': '07/04/2020 08:00:00',
                  'EndTime': '07/04/2020 09:00:00'
                });
              } else if (value == "Delete") {
                try {
                  databaseReference
                      .collection('CalendarAppointmentCollection')
                      .doc('1')
                      .delete();
                } catch (e) {}
              } else if (value == "Update") {
                try {
                  databaseReference
                      .collection('CalendarAppointmentCollection')
                      .doc('1')
                      .update({'Subject': 'Meeting'});
                } catch (e) {}
              }
            },
          )),
        resizeToAvoidBottomInset: true,
        body: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: getEventCalendar(_events, onCalendarTapped)),
    );
  }

  //Set up Calendar
  SfCalendar getEventCalendar(
      CalendarDataSource _calendarDataSource,
      CalendarTapCallback calendarTapCallback) {
    return SfCalendar(
        view: CalendarView.month,
        controller: calendarController,
        //Display Mode:
        allowedViews: const [CalendarView.week, CalendarView.month],
        dataSource: _calendarDataSource,
        onTap: calendarTapCallback,

        //看不懂的部分
        appointmentBuilder: (context, calendarAppointmentDetails) {
          final Booking meeting =
              calendarAppointmentDetails.appointments.first;
          //Container for every meeting
          return Container(
            color: _colorCollection[_statusNames.indexOf(meeting.status)].withOpacity(0.5),
            child: Center(
               child: Text(
                 meeting.eventName,
                 textAlign: TextAlign.center,
                 overflow: TextOverflow.ellipsis,),
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
    }else{
      calendarController.view = CalendarView.day;
      /*if (calendarController.view == CalendarView.month) {
        calendarController.view = CalendarView.day;
      }*/
      if(calendarTapDetails.targetElement!=CalendarElement.calendarCell){
        setState(() {
          _selectedAppointment = null;
          _isAllDay = false;
          _selectedStatusIndex = 0;
          //_selectedTimeZoneIndex = 0;
          _subject = '';
          _notes = '';
          _tradie='';
          if (calendarTapDetails.appointments != null &&
              calendarTapDetails.appointments!.length == 1) {
            final Booking meetingDetails = calendarTapDetails.appointments![0];
            _startDate = meetingDetails.from;
            _endDate = meetingDetails.to;
            _selectedStatusIndex =
                _statusNames.indexOf(meetingDetails.status);
            _tradie=meetingDetails.tradieName;
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

  List<Booking> getMeetingDetails() {
    final List<Booking> meetingCollection = <Booking>[];
    eventNameCollection = <String>[];
    eventNameCollection.add('Demolition');
    eventNameCollection.add('Bricklaying');
    eventNameCollection.add('Plastering');
    eventNameCollection.add('Coating');
    eventNameCollection.add('Plumbing and electrical renovation');
    eventNameCollection.add('Waterproofing treatment');
    eventNameCollection.add('Furniture arrangement');
    eventNameCollection.add('Wall decoration');
    eventNameCollection.add('Air conditioning installation');
    eventNameCollection.add('Green decoration');

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

    _colorNames = <String>[];
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

    final DateTime today = DateTime.now();
    final Random random = Random();
    for (int month = -1; month < 2; month++) {
      for (int day = -5; day < 5; day++) {
        for (int hour = 9; hour < 18; hour += 5) {
          meetingCollection.add(Booking(
            from: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: hour)),
            to: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: hour + 2)),
            status: _statusNames[random.nextInt(5)],
            tradieName: "Tom",
            description: '',
            eventName: eventNameCollection[random.nextInt(7)],
          ));
        }
      }
    }

    return meetingCollection;
  }
}

