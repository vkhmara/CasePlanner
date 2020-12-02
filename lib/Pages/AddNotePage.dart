import 'package:case_planner/InputDateTimeField.dart';
import 'package:case_planner/WorkWithData/Note.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AddNotePage extends StatefulWidget {
  final String title = 'Планировщик дел';
  static const String route = '/addNote';

  @override
  _AddNotePageState createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  TextEditingController _inputDeal = TextEditingController();

  DateTime startDate;
  TimeOfDay startTime;
  DateTime endDate;
  TimeOfDay endTime;

  DateTime _addDateAndTime(DateTime dt, TimeOfDay tod) {
    return dt.add(Duration(hours: tod.hour, minutes: tod.minute));
  }

  @override
  Widget build(BuildContext context) {
    if (startDate == null) {
      startDate = DateTime.now();
      startTime = TimeOfDay.now();
      endDate = DateTime.now();
      endTime = TimeOfDay.now();
    }
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title, style: TextStyle(color: Colors.pink)),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          /*Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _inputStart,
                      showCursor: true,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _inputEnd,
                      showCursor: true,
                    ),
                  ),
                ),
              ],
          ),*/
          DateTimePicker(
            labelText: 'Start',
            selectedDate: startDate,
            selectedTime: startTime,
            selectDate: (value) {
              setState(() {
                startDate = value;
              });
            },
            selectTime: (value) {
              setState(() {
                startTime = value;
              });
            },
          ),
          DateTimePicker(
            labelText: 'End',
            selectedDate: endDate,
            selectedTime: endTime,
            selectDate: (value) {
              setState(() {
                endDate = value;
              });
            },
            selectTime: (value) {
              setState(() {
                endTime = value;
              });
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _inputDeal,
                showCursor: true,
              ),
            ),
          ),
          RaisedButton(onPressed: () {
            try {
              Note note = Note(
                deal: _inputDeal.text,
                start: _addDateAndTime(startDate, startTime),
                end: _addDateAndTime(endDate, endTime),
                done: false,
              );
              Navigator.pop(context, note);
            }
            catch(e) {
              Navigator.pop(context);
            }
          }),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _inputDeal.dispose();

    super.dispose();
  }
}
