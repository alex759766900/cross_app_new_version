import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';


class Calendar extends StatefulWidget {
  const Calendar({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  _CalendarState();
  late List<String> eventNameCollection;
  late List<Meeting> appointments;
  CalendarController calendarController = CalendarController();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
        child: SfCalendar(
          view: CalendarView.week,
          firstDayOfWeek: 1,
          dataSource: BookingDataSource(getMeetingDetails()),
        ),

      )
    );
  }
}

List<Appointment> getAppointments(DateTime startTime,DateTime endTime){
  List<Appointment> bookings=<Appointment>[];
  bookings.add(Appointment(
    startTime: startTime,
    endTime: endTime,
    subject: 'Conference',
    color: Colors.cyan,
  ));
  return bookings;
}
class Meeting {
  Meeting(
      {required this.from,
        required this.to,
        this.background = Colors.green,
        this.isAllDay = false,
        this.eventName = '',
        this.startTimeZone = '',
        this.endTimeZone = '',
        this.description = ''});

  final String eventName;
  final DateTime from;
  final DateTime to;
  final Color background;
  final bool isAllDay;
  final String startTimeZone;
  final String endTimeZone;
  final String description;
}
class BookingDataSource extends CalendarDataSource{
  BookingDataSource(List<Meeting> source) {
    appointments = source;
  }
    @override
    bool isAllDay(int index) => appointments![index].isAllDay;

    @override
    String getSubject(int index) => appointments![index].eventName;

    @override
    String getStartTimeZone(int index) => appointments![index].startTimeZone;

    @override
    String getNotes(int index) => appointments![index].description;

    @override
    String getEndTimeZone(int index) => appointments![index].endTimeZone;

    @override
    Color getColor(int index) => appointments![index].background;

    @override
    DateTime getStartTime(int index) => appointments![index].from;

    @override
    DateTime getEndTime(int index) => appointments![index].to;


}

List<Meeting> getMeetingDetails() {
  final List<Meeting> meetingCollection = <Meeting>[];

  final DateTime today = DateTime.now();
  final Random random = Random();
  for (int month = -1; month < 2; month++) {
    for (int day = -5; day < 5; day++) {
      for (int hour = 9; hour < 18; hour += 5) {
        meetingCollection.add(Meeting(
          from: today
              .add(Duration(days: (month * 30) + day))
              .add(Duration(hours: hour)),
          to: today
              .add(Duration(days: (month * 30) + day))
              .add(Duration(hours: hour + 2)),
          background: Colors.deepOrange,
          startTimeZone: '',
          endTimeZone: '',
          description: '',
          isAllDay: false,
          eventName: 'Booking',
        ));
      }
    }
  }

  return meetingCollection;
}

