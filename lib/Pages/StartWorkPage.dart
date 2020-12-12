import 'dart:developer';

import 'package:case_planner/Pages/MainPage.dart';
import 'package:case_planner/Settings/Settings.dart';
import 'package:case_planner/WorkWithData/AllDeals.dart';
import 'package:case_planner/WorkWithData/ClockFace.dart';
import 'package:case_planner/WorkWithData/DatabaseManager.dart';
import 'package:case_planner/WorkWithData/TODOList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class StartWorkPage extends StatefulWidget {
  @override
  _StartWorkPageState createState() => _StartWorkPageState();
}

class _StartWorkPageState extends State<StartWorkPage> {
  static TextEditingController _inputStartHour = TextEditingController();
  static TextEditingController _inputEndHour = TextEditingController();
  static Size _screenSize;
  bool _rightStartDay = true;
  bool _rightEndDay = true;

  @override
  void initState() {
    super.initState();
    log('init StartWorkPage');
  }

  @override
  void dispose() {
    log('dispose StartWorkPage');
    super.dispose();
  }

  bool isHoursValid(String hours) {
    if (hours.length == 0) {
      return true;
    }
    try {
      int h = int.parse(hours);
      return 0 <= h && h <= 23;
    }
    catch (e) {
      return false;
    }
  }

  void startWork() async {
    try {
      SharedPreferences prefs = await SharedPreferences
          .getInstance();

      int startDayHour = int.parse(_inputStartHour.text);
      int endDayHour = int.parse(_inputEndHour.text);
      assert(0 <= startDayHour && startDayHour <= 23 &&
          0 <= endDayHour && endDayHour <= 23);

      prefs.setInt('startDayHour', startDayHour);
      prefs.setInt('endDayHour', endDayHour);
      await Settings.initSettings();
      await DatabaseManager.initDB();
      await AllDeals.initList();
      TODOList.initList();
      ClockFace.initClockFace();
      Navigator.pushReplacementNamed(context, MainPage.route);
    }
    catch (e) {

    }
  }

  @override
  Widget build(BuildContext context) {

    if (_screenSize == null) {
      _screenSize = MediaQuery.of(context).size;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
      ),
      body: Container(
        alignment: Alignment.bottomLeft,
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 0.05)
              ),
              margin: EdgeInsets.only(bottom: 20.0),
              child: SizedBox(
                height: _screenSize.height * 0.2,
                width: _screenSize.width * 0.8,
                child: Container(
                  alignment: Alignment.center,
                  child: Text('Приветствую вас!\n'
                      'Это приложение для\nпланирования дел.\n'
                      'Чтобы продолжить работу, \nвведите начало и конец дня.\n'
                      'Вы всегда сможете изменить параметры в настройках.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Color(0xFF667676)
                      )),
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: _screenSize.width / 2 - 30,
                      height: 120,
                      child: Column(
                        children: [
                          Text(
                              'Начало дня'
                          ),
                          TextFormField(
                            controller: _inputStartHour,
                            showCursor: true,
                            maxLength: 2,
                            maxLines: 1,
                            keyboardType: TextInputType.number,
                            onChanged: (s) {
                              if (isHoursValid(s)) {
                                setState(() {
                                  _rightStartDay = true;
                                });
                              }
                              else {
                                setState(() {
                                  _rightStartDay = false;
                                });
                              }
                            },
                          ),
                          Text(
                            _rightStartDay ? '' : 'Неверное время',
                            style: TextStyle(
                                color: Colors.red
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: _screenSize.width / 2 - 30,
                      height: 120,
                      child: Column(
                        children: [
                          Text(
                              'Конец дня'
                          ),
                          TextFormField(
                            controller: _inputEndHour,
                            showCursor: true,
                            maxLength: 2,
                            maxLines: 1,
                            keyboardType: TextInputType.number,
                            onChanged: (s) {
                              if (isHoursValid(s)) {
                                setState(() {
                                  _rightEndDay = true;
                                });
                              }
                              else {
                                setState(() {
                                  _rightEndDay = false;
                                });
                              }
                            },
                          ),
                          Text(
                            _rightEndDay ? '' : 'Неверное время',
                            style: TextStyle(
                                color: Colors.red
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )
            ),
            RaisedButton(
                child: Text('Начать\nработу'),
                color: Color(0xCFFFFFFF),
                onPressed: startWork
            ),
          ],
        ),
      ),
    );
  }
}
