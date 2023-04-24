part of booking_calendar;


class BookingEditor extends StatefulWidget {
  const BookingEditor({super.key});
  @override
  BookingEditorState createState() => BookingEditorState();
}

class BookingEditorState extends State<BookingEditor> {
  Widget _getAppointmentEditor(BuildContext context) {
    return Container(
        color: Colors.white,
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: <Widget>[
            //Booking Title
            ListTile(
                contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                leading: const Text(''),
                title: Text(_work),
            ),
            const Divider(
              height: 1.0,
              thickness: 1,
            ),
            ListTile(
                contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                leading: const Text(''),
                title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 7,
                        child: GestureDetector(
                            child: Text(
                                DateFormat('EEE, MMM dd yyyy')
                                    .format(_startDate),
                                textAlign: TextAlign.left),
                            onTap: () async {
                              final DateTime? date = await showDatePicker(
                                context: context,
                                initialDate: _startDate,
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100),
                              );
                              if (date != null && date != _startDate) {
                                setState(() {
                                  final Duration difference =
                                  _endDate.difference(_startDate);
                                  _startDate = DateTime(
                                      date.year,
                                      date.month,
                                      date.day,
                                      _startTime.hour,
                                      _startTime.minute,
                                      0);
                                  _endDate = _startDate.add(difference);
                                  _endTime = TimeOfDay(
                                      hour: _endDate.hour,
                                      minute: _endDate.minute);
                                });
                              }
                            }),
                      ),
                      Expanded(
                          flex: 3,
                          child: false
                              ? const Text('')
                              : GestureDetector(
                              child: Text(
                                DateFormat('hh:mm a').format(_startDate),
                                textAlign: TextAlign.right,
                              ),
                              onTap: () async {
                                final TimeOfDay? time =
                                await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay(
                                        hour: _startTime.hour,
                                        minute: _startTime.minute));

                                if (time != null && time != _startTime) {
                                  setState(() {
                                    _startTime = time;
                                    final Duration difference =
                                    _endDate.difference(_startDate);
                                    _startDate = DateTime(
                                        _startDate.year,
                                        _startDate.month,
                                        _startDate.day,
                                        _startTime.hour,
                                        _startTime.minute,
                                        0);
                                    _endDate = _startDate.add(difference);
                                    _endTime = TimeOfDay(
                                        hour: _endDate.hour,
                                        minute: _endDate.minute);
                                  });
                                }
                              })),
                    ])),
            ListTile(
                contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                leading: const Text(''),
                title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 7,
                        child: GestureDetector(
                            child: Text(
                              DateFormat('EEE, MMM dd yyyy').format(_endDate),
                              textAlign: TextAlign.left,
                            ),
                            onTap: () async {
                              final DateTime? date = await showDatePicker(
                                context: context,
                                initialDate: _endDate,
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100),
                              );

                              if (date != null && date != _endDate) {
                                setState(() {
                                  final Duration difference =
                                  _endDate.difference(_startDate);
                                  _endDate = DateTime(
                                      date.year,
                                      date.month,
                                      date.day,
                                      _endTime.hour,
                                      _endTime.minute,
                                      0);
                                  if (_endDate.isBefore(_startDate)) {
                                    _startDate = _endDate.subtract(difference);
                                    _startTime = TimeOfDay(
                                        hour: _startDate.hour,
                                        minute: _startDate.minute);
                                  }
                                });
                              }
                            }),
                      ),
                      Expanded(
                          flex: 3,
                          child: _isAllDay
                              ? const Text('')
                              : GestureDetector(
                              child: Text(
                                DateFormat('hh:mm a').format(_endDate),
                                textAlign: TextAlign.right,
                              ),
                              onTap: () async {
                                final TimeOfDay? time =
                                await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay(
                                        hour: _endTime.hour,
                                        minute: _endTime.minute));

                                if (time != null && time != _endTime) {
                                  setState(() {
                                    _endTime = time;
                                    final Duration difference =
                                    _endDate.difference(_startDate);
                                    _endDate = DateTime(
                                        _endDate.year,
                                        _endDate.month,
                                        _endDate.day,
                                        _endTime.hour,
                                        _endTime.minute,
                                        0);
                                    if (_endDate.isBefore(_startDate)) {
                                      _startDate =
                                          _endDate.subtract(difference);
                                      _startTime = TimeOfDay(
                                          hour: _startDate.hour,
                                          minute: _startDate.minute);
                                    }
                                  });
                                }
                              })),
                    ])),
            const Divider(
              height: 1.0,
              thickness: 1,
            ),
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
              leading: Icon(
                Icons.people_alt,
              ),
              title: Text(_tradie),
            ),
            const Divider(
              height: 1.0,
              thickness: 1,
            ),
            //Status
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
              leading: Icon(Icons.lens,
                  color: _colorCollection[_selectedStatusIndex]),
              title: Text(
                _statusNames[_selectedStatusIndex],
              ),
            ),
            const Divider(
              height: 1.0,
              thickness: 1,
            ),
            //Description
            ListTile(
              contentPadding: const EdgeInsets.all(5),
              leading: const Icon(
                Icons.subject,
                color: Colors.black87,
              ),
              title: TextField(
                controller: TextEditingController(text: _notes),
                onChanged: (String value) {
                  _notes = value;
                },
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    fontWeight: FontWeight.w400),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Add Note',
                ),
              ),
            ),
            const Divider(
              height: 1.0,
              thickness: 1,
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            //最上方一行 new event
            appBar: AppBar(
              title: Text(getTile()),
              backgroundColor: _colorCollection[_selectedStatusIndex],
              //x 按钮
              leading: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              // √ botton
              actions: <Widget>[
                IconButton(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    icon: const Icon(
                      Icons.done,
                      color: Colors.white,
                    ),
                    onPressed: () async{
                      AlertDialog alert_outBound;
                      if(_startDate.hour<9||_endDate.hour>17){
                        Widget OKButton = TextButton(
                          child: const Text("Ok"),
                          onPressed: () {
                            Navigator.pop(context,true);
                          },
                        );
                        alert_outBound = AlertDialog(
                          title: const Text("Alert"),
                          content: const Text('Out of Tradie Working Time'),
                          actions: [
                            OKButton,
                          ],
                        );
                        await showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) {
                            return alert_outBound;
                          },
                        );
                        return;
                      }
                      final Booking? newTimeAppointment =
                      _isInterceptExistingAppointments(
                          _startDate,_endDate);
                      AlertDialog alert_conflict;
                      if (newTimeAppointment != null) {
                        Widget okButton = TextButton(
                          child: const Text("Ok"),
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                        );
                        alert_conflict = AlertDialog(
                          title: const Text("Alert"),
                          content: const Text('Have intercept with existing'),
                          actions: [
                            okButton,
                          ],
                        );

                        await showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) {
                            return alert_conflict;
                          },
                        );
                        return;
                      }
                      final List<Booking> meetings = <Booking>[];
                      //如果是已存在的appointment，从列表中移除，加上更改的
                      if (_selectedAppointment != null) {
                        _bookings.appointments!.removeAt(_bookings.appointments!
                            .indexOf(_selectedAppointment));
                        _bookings.notifyListeners(CalendarDataSourceAction.remove,
                            <Booking>[]..add(_selectedAppointment!));
                        colRef.doc(_selectedAppointment?.key).update({
                          'eventName': _subject,
                          'from': _startDate.toString(),
                          'to': _endDate.toString(),
                          'status':'Pending',
                          'tradieName':_tradieName,
                          'consumerName':_consumerName,
                          'description':_notes,
                          'key':selectedKey,
                          'tradieId':_tradieId,
                          'consumerId':_consumerId,
                        });
                      }
                      meetings.add(Booking(
                        from: _startDate,
                        to: _endDate,
                        status: _statusNames[_selectedStatusIndex],
                        consumerName: _consumerName,
                        tradieName: _tradieName,
                        description: _notes,
                        eventName: _subject,
                        consumerId: _consumerId,
                        tradieId: _tradieId,
                        key: selectedKey,

                      ));
                      _bookings.appointments!.add(meetings[0]);
                      _bookings.notifyListeners(
                          CalendarDataSourceAction.add, meetings);
                      colRef.doc().set({
                        'eventName': _subject,
                        'from': _startDate.toString(),
                        'to': _endDate.toString(),
                        'status':'Pending',
                        'tradieName':_tradieName,
                        'consumerName':_consumerName,
                        'description':_notes,
                        'key':selectedKey,
                        'tradieId':_tradieId,
                        'consumerId':_consumerId,
                      });
                      _selectedAppointment = null;
                      //_consumer.bookings.add(meetings[0]);
                      Navigator.pop(context);
                    })
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
              //TODO 搞懂
              child: Stack(
                children: <Widget>[_getAppointmentEditor(context)],
              ),
            ),
            floatingActionButton: _selectedAppointment == null
                ? const Text('')
                : FloatingActionButton(
              onPressed: () {
                if (_selectedAppointment != null) {
                  _bookings.appointments!.removeAt(_bookings.appointments!
                      .indexOf(_selectedAppointment));
                  _bookings.notifyListeners(CalendarDataSourceAction.remove,
                      <Booking>[]..add(_selectedAppointment!));
                  try {
                    colRef.doc(_selectedAppointment?.key).delete();
                  } catch (e) {}
                  _selectedAppointment = null;
                  Navigator.pop(context);
                }
              },
              child:
                const Text('Cancel',selectionColor: Colors.white,),
              /*const Icon(Icons.delete_outline, color: Colors.white),*/
              backgroundColor: Colors.red,
            )));
  }

  String getTile() {
    return _subject.isEmpty ? 'New event' : 'Event details';
  }
  dynamic _isInterceptExistingAppointments(DateTime from, DateTime to) {
    if(from == null || to==null ||_bookings ==null || _bookings.appointments == null || _bookings.appointments!.isEmpty)
      return null;
    for (int i = 0; i < _bookings.appointments!.length; i++) {
      Booking appointment = _bookings.appointments![i];
      if (_isSameDay(appointment.from, from)&&_isSameDay(appointment.to, to)&&(
          (appointment.from.hour<from.hour&&from.hour<appointment.to.hour)
          ||(appointment.from.hour<to.hour&&to.hour<appointment.to.hour)
          ||(appointment.from.hour<from.hour&&to.hour<appointment.to.hour)
          ||(appointment.from.hour==from.hour&&to.hour==appointment.to.hour)))
      {
        return appointment;
      }
    }
    return null;
  }
  bool _isSameDay(DateTime date1, DateTime date2) {
    if (date1 == date2) {
      return true;
    }

    if (date1 == null || date2 == null) {
      return false;
    }

    if (date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day) {
      return true;
    }

    return false;
  }
}
