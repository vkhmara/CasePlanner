import 'package:case_planner/Settings/Prefs.dart';
import 'package:case_planner/InputDateTimeField.dart';
import 'package:case_planner/PageNumber.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'HomePage.dart';

class SettingsPage extends StatefulWidget{
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> implements PageNumber {
  static TextEditingController _inputStartHour = TextEditingController();
  static TextEditingController _inputEndHour = TextEditingController();
  static DateTime date = DateTime.now();
  static bool isException = false;
  static String errorException = 'exception';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: _inputStartHour,
            showCursor: true,
            maxLength: 2,
            maxLines: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: _inputEndHour,
            showCursor: true,
            maxLength: 2,
            maxLines: 1,
          ),
        ),
        DateTimePicker(
          labelText: 'End',
          selectedDate: date,
          selectedTime: TimeOfDay.now(),
          selectDate: (value) {
            setState(() {
              date = value;
            });
          },
          selectTime: (value) {
          },
        ),
        Container(
          child: Text(isException ? errorException : ''),
        ),
        FloatingActionButton(
          onPressed: () async {
            try {
              int startDayHour = int.parse(_inputStartHour.text);
              int endDayHour = int.parse(_inputEndHour.text);
              Settings.changeDayInterval(startDayHour, endDayHour);
            }
            catch (e) {
            }
            Settings.changeCurrentDay(date);
            setState(() {
              isException = false;
              Navigator.pushReplacementNamed(context, MyHomePage.route);
              PageNumber.currentPage = 0;
            });
          },
        ),
      ],
    );
  }
}
