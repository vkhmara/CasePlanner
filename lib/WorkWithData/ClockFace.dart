import 'dart:math';

import 'package:case_planner/CurrentDay/Prefs.dart';
import 'package:case_planner/WorkWithData/Deal.dart';
import 'package:case_planner/WorkWithData/TODOList.dart';
import 'package:flutter/material.dart';

import 'WorkWithDateAndTime.dart';

class ClockFace {
  //TODO: add hatches in clockface
  // Hours from 0 till 23
  static List<Offset> _allPoints;
  static List<Offset> _dealPoints;
  static List<Offset> _hourLabels;
  static Size size = Size(350.0, 300.0);
  static double _a = 10.0;
  static double _r0 = 30.0;
  static double _phi0;
  static double _anglePerMinute = 4 * pi / (24 * 60);
  static Point<double> _center = Point(size.width / 2, size.height / 2);
  static Deal _selectedDeal;
  static Offset selectedPoint = Offset(0, 0);
  static List<Offset> _selectedPoints = List();
  static bool _selected = false;
  static TimeOfDay currentTime = TimeOfDay(hour: 0, minute: 0);
  static double borderDist = 15.0;

  static void initClockFace() {
    updateAllPoints();
    updateHourLabels();
    updateDealPoints();
  }

  static void changeDay() {
    updateDealPoints();
  }

  static void updateDealPoints() {
    _dealPoints = List();
    for (Deal deal in TODOList.todoList) {
      _dealPoints.addAll(_getPointsOnCurve(
          TimeOfDay.fromDateTime(deal.start),
          TimeOfDay.fromDateTime(deal.end)
      ));
    }
  }

  static void updateAllPoints() {
    _allPoints = List();
    _phi0 = -pi / 2 + pi / 6 * Prefs.startDayHour;
    if (_phi0 >= 2 * pi) {
      _phi0 -= 2 * pi;
    }
    for (double phi = _phi0; phi <=
        angleOfTime(TimeOfDay(hour: Prefs.endDayHour, minute: 0));
    phi += _anglePerMinute) {
      _allPoints.add(Offset(_center.x + (_a * (phi - _phi0) + _r0) * cos(phi),
          _center.y + (_a * (phi - _phi0) + _r0) * sin(phi)
      ));
    }
  }

  static void updateHourLabels() {
    _hourLabels = List();
    int upperHour = Prefs.startDayHour == Prefs.endDayHour
        ? Prefs.endDayHour
        : (Prefs.endDayHour + 1) % 24;
    double offRadius = 15;
    double sliceX = -offRadius / 2.5;
    double sliceY = -offRadius / 3;

    for (int hour = Prefs.startDayHour; hour != upperHour;
    hour = (hour + 1) % 24) {
      double angle = angleOfTime(TimeOfDay(hour: hour, minute: 0));
      _hourLabels.add(Offset(
          _center.x + (_a * (angle - _phi0) + _r0 + offRadius) * cos(angle) +
              sliceX,
          _center.y + (_a * (angle - _phi0) + _r0 + offRadius) * sin(angle) +
              sliceY
      ));
    }
  }

  static void changeDayInterval() {
    updateAllPoints();
    updateHourLabels();
  }

  static double angleOfTime(TimeOfDay tod) {
    int hours = tod.hour - Prefs.startDayHour;
    if (hours < 0) {
      hours += 24;
    }
    return _phi0 + (hours * 60 + tod.minute) * _anglePerMinute;
  }

  static List<Offset> _getPointsOnCurve(TimeOfDay tod1, TimeOfDay tod2) {
    List<Offset> list = List();
    for (double phi = angleOfTime(tod1); phi <= angleOfTime(tod2);
    phi += _anglePerMinute) {
      list.add(Offset(_center.x + (_a * (phi - _phi0) + _r0) * cos(phi),
          _center.y + (_a * (phi - _phi0) + _r0) * sin(phi)));
    }
    return list;
  }

  static void updateAll() {
    updateAllPoints();
    updateDealPoints();
    updateHourLabels();
  }

  static void handleTap(Offset tapPoint) {
    _selectedPoints = List();
    Point rad = Point(tapPoint.dx, tapPoint.dy) - _center;
    double r = rad.magnitude;
    double phi = atan2(rad.y, rad.x);
    if (phi < -pi / 2) {
      phi += 2 * pi;
    }
    for (int i = 0; i < 2; i++) {
      if ((r - _r0 - _a * (phi - _phi0)).abs() < borderDist) {
        double minutes = (phi + pi / 2) / _anglePerMinute;
        TimeOfDay tod = TimeOfDay(
            hour: (minutes / 60).floor(), minute: minutes.floor() % 60);
        currentTime = tod;
        for (Deal deal in TODOList.todoList) {
          if (WorkWithDateAndTime.isTimeBetween(tod, TimeOfDay.fromDateTime(deal.start),
              TimeOfDay.fromDateTime(deal.end))) {
            _selected = true;
            _selectedPoints = _getPointsOnCurve(TimeOfDay.fromDateTime(deal.start),
                TimeOfDay.fromDateTime(deal.end));
            _selectedDeal = deal;
            return;
          }
        }
      }
      phi += 2 * pi;
    }
    _selected = false;
  }

  static List<Offset> get allPoints => _allPoints;

  static List<Offset> get dealPoints => _dealPoints;

  static List<Offset> get hourLabels => _hourLabels;

  static List<Offset> get selectedPoints =>
      _selected ? _selectedPoints : null;

  static set r0(double value) {
    _r0 = value;
    changeDay();
    changeDayInterval();
  }

  static set a(double value) {
    _a = value;
    changeDay();
    changeDayInterval();
  }

  static Deal get selectedDeal =>
      _selected ? _selectedDeal : null;
}