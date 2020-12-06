import 'package:case_planner/Pages/HomePage.dart';
import 'package:case_planner/Settings/Prefs.dart';
import 'package:case_planner/WorkWithData/AllDeals.dart';
import 'package:case_planner/WorkWithData/ClockFace.dart';
import 'package:case_planner/WorkWithData/DatabaseManager.dart';
import 'package:case_planner/WorkWithData/TODOList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class StartWorkPage extends StatelessWidget {
  final TextEditingController _tecStartDay = TextEditingController();
  final TextEditingController _tecEndDay = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(36.0),
        child: Column(
          children: [
            Text('Начало дня'),
            TextFormField(
              controller: _tecStartDay,
              maxLines: 1,
              maxLength: 2,
            ),
            Text('Конец дня'),
            TextFormField(
              controller: _tecEndDay,
              maxLines: 1,
              maxLength: 2,
            ),
            RaisedButton(
                child: Text('Input'),
                onPressed: () async {
                  try {
                    SharedPreferences prefs = await SharedPreferences
                        .getInstance();

                    int startDayHour = int.parse(_tecStartDay.text);
                    int endDayHour = int.parse(_tecEndDay.text);

                    prefs.setInt('startDayHour', startDayHour);
                    prefs.setInt('endDayHour', endDayHour);
                    await Settings.initSettings();
                    await DatabaseManager.initDB();
                    await AllDeals.initList();
                    TODOList.initList();
                    ClockFace.initClockFace();
                    Navigator.pushReplacementNamed(context, MyHomePage.route);
                  }
                  catch (e) {

                  }
                }),
          ],
        ),
      ),
    );
  }
}
