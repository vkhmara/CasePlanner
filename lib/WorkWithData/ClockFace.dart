import 'dart:math';

import 'package:case_planner/CurrentDay/Prefs.dart';
import 'package:case_planner/WorkWithData/Deal.dart';
import 'package:case_planner/WorkWithData/TODOList.dart';
import 'package:flutter/material.dart';

class ClockFace {
  // Hours from 0 till 23
  static List<Offset> _allPoints;
  static List<Offset> _dealPoints;
  static Size size = Size(200.0, 300.0);
  static double _a = 10.0;
  static double _r0 = 30.0;
  static double _phi0;
  static double _anglePerMinute = 4 * pi / (24 * 60);
  static Point center = Point(size.width / 2, size.height / 2);

  static void initClockFace() {
    changeDayInterval();
    updateDealPoints();
  }

  static void updateDay() {
    updateDealPoints();
  }

  static void updateDealPoints() {
    _dealPoints = List();
    for (Deal deal in TODOList.todoList) {
      _dealPoints.addAll(_getPointsOnCurve(
          TimeOfDay(hour: deal.start.hour, minute: deal.start.minute),
          TimeOfDay(hour: deal.end.hour, minute: deal.end.minute)));
    }
  }

  static void changeDayInterval() {
    _allPoints = List();
    _phi0 = _angleOfTime(TimeOfDay(hour:Prefs.startDayHour, minute: 0));
    for (double phi = _phi0; phi <= _angleOfTime(TimeOfDay(hour: Prefs.endDayHour, minute: 0)); phi += _anglePerMinute) {
      _allPoints.add(Offset(center.x + (_a * (phi-_phi0) + _r0) * cos(phi),
          center.y + (_a * (phi-_phi0) + _r0) * sin(phi)
      ));
    }
  }

  static double _angleOfTime(TimeOfDay tod) {
    return -pi / 2 + (tod.hour * 60 + tod.minute) * _anglePerMinute;
  }

  static List<Offset> _getPointsOnCurve(TimeOfDay tod1, TimeOfDay tod2) {
    List<Offset> list = List();
    for (double phi = _angleOfTime(tod1); phi <= _angleOfTime(tod2); phi += _anglePerMinute) {
      list.add(Offset(center.x + (_a * (phi-_phi0) + _r0) * cos(phi),
          center.y + (_a * (phi-_phi0) + _r0) * sin(phi)));
    }
    return list;
  }

  static List<Offset> get allPoints => _allPoints;
  static List<Offset> get dealPoints => _dealPoints;

  static void changeA(double aa) {
    _a = aa;
  }

  static void changeR0(double rr0) {
    _r0 = rr0;
  }

}