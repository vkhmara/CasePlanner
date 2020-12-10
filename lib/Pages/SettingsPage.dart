import 'dart:developer';

import 'package:case_planner/HelperComponents/MenuPoint.dart';
import 'package:case_planner/Pages/AboutProgramPage.dart';
import 'package:case_planner/Settings/Settings.dart';
import 'package:case_planner/HelperComponents/InputDateTimeField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SettingsPage extends StatefulWidget{
  final void Function() _toTODOListPage;
  final void Function() _updateAppBar;

  SettingsPage(this._toTODOListPage, this._updateAppBar);
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>{
  TextEditingController _inputStartHour = TextEditingController();
  TextEditingController _inputEndHour = TextEditingController();
  static DateTime date = Settings.minimStartDay;
  static bool _changeDayTapped = false;
  static bool _changeIntervalTapped = false;
  static Size _screenSize;
  bool _rightStartDay = true;
  bool _rightEndDay = true;
  @override
  Widget build(BuildContext context) {
    if (_screenSize == null) {
      _screenSize = MediaQuery.of(context).size;
    }
    List<Widget> list = [
      MenuPoint(
          'Изменить текущий день', () {
        setState(() {
          _changeDayTapped = !_changeDayTapped;
          if (_changeDayTapped) {
            _changeIntervalTapped = false;
          }
        });
      })
    ];
    if (_changeDayTapped) {
      list.add(Container(
        margin: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 10.0),
        child: Column(
          children: [
            DatePicker(
              labelText: 'Введите интересующий день',
              selectedDate: date,
              selectDate: (value) {
                setState(() {
                  date = value;
                });
              },
            ),
            RaisedButton(
              child: Text('Применить'),
              color: Color(0x00000000),
              onPressed: () async {
                Settings.changeCurrentDay(date);
                _changeIntervalTapped = _changeDayTapped = false;
                setState(() {
                  widget._toTODOListPage();
                  widget._updateAppBar();
                });
              },
            ),
          ],
        ),
      ));
    }
    list.add(
        MenuPoint('Изменить дневной интервал', () {
          setState(() {
            _changeIntervalTapped = !_changeIntervalTapped;
            if (_changeIntervalTapped) {
              _changeDayTapped = false;
            }
          });
        }));
    if (_changeIntervalTapped) {
      list.add(Container(
        margin: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        child: Column(
          children: [
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
                              'Начало дня',
                            style: TextStyle(
                              color: Colors.blue
                            ),
                          ),
                          TextFormField(
                            controller: _inputStartHour,
                            showCursor: true,
                            maxLength: 2,
                            maxLines: 1,
                            keyboardType: TextInputType.number,
                            onChanged: (s) {
                              try {
                                if (s.length == 0) {
                                  setState(() {
                                    _rightStartDay = true;
                                  });
                                  return;
                                }
                                int res = int.parse(s);
                                if (!(0 <= res && res <= 23)) {
                                  _rightStartDay = false;
                                }
                                else {
                                  _rightStartDay = true;
                                }
                              }
                              catch (e) {
                                _rightStartDay = false;
                              }
                              setState(() {

                              });
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
                              'Конец дня',
                            style: TextStyle(
                                color: Colors.blue
                            ),
                          ),
                          TextFormField(
                            controller: _inputEndHour,
                            showCursor: true,
                            maxLength: 2,
                            maxLines: 1,
                            keyboardType: TextInputType.number,
                            onChanged: (s) {
                              try {
                                if (s.length == 0) {
                                  setState(() {
                                    _rightEndDay = true;
                                  });
                                  return;
                                }
                                int res = int.parse(s);
                                if (!(0 <= res && res <= 23)) {
                                  _rightEndDay = false;
                                }
                                else {
                                  _rightEndDay = true;
                                }
                              }
                              catch (e) {
                                _rightStartDay = false;
                              }
                              setState(() {

                              });
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
              child: Text('Применить'),
              color: Color(0x00000000),
              onPressed: () async {
                try {
                  int startDayHour = int.parse(_inputStartHour.text);
                  int endDayHour = int.parse(_inputEndHour.text);
                  assert(0 <= startDayHour && startDayHour <= 23 &&
                      0 <= endDayHour && endDayHour <= 23);
                  Settings.changeDayInterval(startDayHour, endDayHour);
                  _changeIntervalTapped = _changeDayTapped = false;
                  setState(() {
                    widget._toTODOListPage();
                    widget._updateAppBar();
                  });
                }
                catch (e) {}
              },
            ),
          ],
        ),
      ));
      list.add(Container(
        alignment: Alignment.center,
        child: Text(
          'ВНИМАНИЕ: НЕКОТОРЫЕ ЗАПИСИ МОГУТ ПРОПАСТЬ',
          style: TextStyle(
            fontSize: 13.0,
            color: Color(0x7AA00000)
          ),
        ),
      ));
    }
    list.add(
      MenuPoint('О программе', () {
        Navigator.pushNamed(context, AboutProgramPage.route);
      })
    );
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, pos) => list[pos]);
  }

  @override
  void dispose() {
    log('dispose SettingsPage');
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    log('init SettingsPage');
  }
}
