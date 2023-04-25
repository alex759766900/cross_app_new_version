part of booking_Calendar;

class AppointmentEditor extends StatefulWidget {
  const AppointmentEditor({super.key});

  @override
  AppointmentEditorState createState() => AppointmentEditorState();
}

class AppointmentEditorState extends State<AppointmentEditor> {
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
                title: Text(_subject)),
            const Divider(
              height: 1.0,
              thickness: 1,
            ),
            //start and end time TODO:搞懂
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
                              DateFormat('EEE, MMM dd yyyy').format(_startDate),
                              textAlign: TextAlign.left),
                        ),
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
                                )),
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
                          /*onTap: () async {
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
                            }*/
                        ),
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
                                )),
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
              title: Text(_tradieName),
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

              /*onTap: () {
                showDialog<Widget>(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return _ColorPicker();
                  },
                ).then((dynamic value) => setState(() {}));
              }*/
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
                  onPressed: () {
                    final List<Booking> meetings = <Booking>[];
                    //如果是已存在的appointment，从列表中移除，加上更改的
                    if (_selectedAppointment != null) {
                      int remove = 0;
                      for (int i = 0; i < _events.appointments!.length; i++) {
                        Booking b = _events.appointments![i];
                        if (b.key == _selectedAppointment!.key) {
                          print('find');
                          remove = i;
                          break;
                        }
                      }
                      _events.appointments!.removeAt(remove);
                      print(_events.appointments!.length);
                      _events.notifyListeners(CalendarDataSourceAction.remove,
                          <Booking>[]..add(_selectedAppointment!));
                    }
                    meetings.add(Booking(
                        from: _startDate,
                        to: _endDate,
                        status: _statusNames[_selectedStatusIndex],
                        description: _notes,
                        eventName: _subject == '' ? '(No title)' : _subject,
                        consumerName: _consumerName,
                        tradieName: _tradieName,
                        key: selectedKey,
                        consumerId: _consumerId,
                        tradieId: _tradieId

                        ///eventName: _subject =_subject,
                        ));

                    _events.appointments!.add(meetings[0]);

                    _events.notifyListeners(
                        CalendarDataSourceAction.add, meetings);
                    colRef.doc(_selectedAppointment?.key).update({
                      'eventName': _subject,
                      'from': _startDate.toString(),
                      'to': _endDate.toString(),
                      'status': 'Pending',
                      'tradieName': _tradieName,
                      'consumerName': _consumerName,
                      'description': _notes,
                      'key': selectedKey,
                      'tradieId': _tradieId,
                      'consumerId': _consumerId,
                    });
                    _selectedAppointment = null;

                    //_consumer.bookings.add(meetings[0]);
                    Navigator.pop(context);
                  })
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
            child: Stack(
              children: <Widget>[_getAppointmentEditor(context)],
            ),
          ),
          floatingActionButton: _selectedAppointment == null
              ? const Text('')
              : FloatingActionButton(
                  onPressed: () {
                    if (_selectedAppointment != null) {
                      _events.appointments!.removeAt(
                          _events.appointments!.indexOf(_selectedAppointment));
                      _events.notifyListeners(CalendarDataSourceAction.remove,
                          <Booking>[]..add(_selectedAppointment!));

                      try {
                        colRef.doc(_selectedAppointment?.key).delete();
                      } catch (e) {}
                      _selectedAppointment = null;
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    'Cancel',
                    selectionColor: Colors.white,
                  ),
                  /*const Icon(Icons.delete_outline, color: Colors.white),*/
                  backgroundColor: Colors.red,
                ),
        ));
  }

  String getTile() {
    return _subject.isEmpty ? 'New event' : 'Event details';
  }
}
