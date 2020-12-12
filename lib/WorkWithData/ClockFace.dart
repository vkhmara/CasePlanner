import 'dart:math';

import 'package:case_planner/Settings/Settings.dart';
import 'package:case_planner/WorkWithData/Deal.dart';
import 'package:case_planner/WorkWithData/TODOList.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'DateTimeUtility.dart';

class ClockFace {
  // Hours from 0 till 23
  static List<Offset> _allPoints;
  static List<Offset> _dealPoints;
  static List<Offset> _hourLabels;
  static List<OffsetPair> _hatches;

  static Size size = Size(350.0, 350.0);
  static double _a = 10.0;
  static double _r0 = 150.0;
  static double _phi0;
  static double _anglePerMinute = 4 * pi / (24 * 60);
  static Point<double> _center = Point(size.width / 2, size.height / 2);
  static Deal _selectedDeal;
  static Offset selectedPoint = Offset(0, 0);
  static List<Offset> _selectedPoints = List();
  static bool _selected = false;
  static double _borderDist = 25.0;

  static void initClockFace() {
    updateAllPoints();
    updateHourLabels();
    updateDealPoints();
    updateHatches();
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

  /// Polar coordinate of spiral with offset
  static double r(double phi, {double offset = 0}) {
    return _r0 + offset + _a * (phi - _phi0);
  }

  static void updateHatches() {
    _hatches = List();
    int numOfHours = (Settings.endDayHour == Settings.startDayHour) ?
        25 : ((Settings.endDayHour - Settings.startDayHour) % 24 + 1);
    int hour = Settings.endDayHour;
    double hatchLength = 8;
    for (int i= 0; i < numOfHours; i++, hour = (hour - 1) % 24) {
      double phi = angleOfTime(TimeOfDay(hour: hour, minute: 0));
      if (i == 24) {
        phi -= 4 * pi;
      }
      _hatches.add(OffsetPair(
        local: Offset(
          _center.x + r(phi, offset: -hatchLength / 2) * cos(phi),
            _center.y + r(phi, offset: -hatchLength / 2) * sin(phi)
        ),
        global: Offset(
            _center.x + r(phi, offset: hatchLength / 2) * cos(phi),
            _center.y + r(phi, offset: hatchLength / 2) * sin(phi)
        )
      ));
    }
  }

  static void updateAllPoints() {
    _allPoints = List();
    _phi0 = -pi / 2 + pi / 6 * Settings.endDayHour;
    double lowerPhi = Settings.startDayHour == Settings.endDayHour ?
    _phi0 - 4 * pi :
    angleOfTime(TimeOfDay(hour: Settings.startDayHour, minute: 0));
    for (double phi = _phi0; phi >= lowerPhi; phi -= _anglePerMinute) {
      _allPoints.add(Offset(_center.x + r(phi) * cos(phi),
          _center.y + r(phi) * sin(phi)
      ));
    }
    developer.log('all points on clockface updated');
  }

  static void updateHourLabels() {
    _hourLabels = List();
    int len = Settings.endDayHour - Settings.startDayHour;
    if (len <= 0) {
      len += 24;
    }
    double offRadius = 15;
    double sliceX = -offRadius / 2;
    double sliceY = -offRadius / 2;
    int hour = Settings.startDayHour;
    for ( int i = 0; i <= len; i++, hour = (hour + 1) % 24) {
      double phi = angleOfTime(TimeOfDay(hour: hour, minute: 0));
      if (len == 24 && i == 0) {
        phi -= 4 * pi;
      }
      _hourLabels.add(Offset(
          _center.x + r(phi, offset: offRadius) * cos(phi) +
              sliceX,
          _center.y + r(phi, offset: offRadius) * sin(phi) +
              sliceY
      ));
    }
  }

  static void changeDayInterval() {
    updateAllPoints();
    updateHourLabels();
    updateHatches();
  }

  // works on shift from endDayHour
  static double angleOfTime(TimeOfDay tod) {
    int hours = (Settings.endDayHour - tod.hour) % 24;
    return _phi0 - (hours * 60 - tod.minute) * _anglePerMinute;
  }

  static List<Offset> _getPointsOnCurve(TimeOfDay tod1, TimeOfDay tod2) {
    List<Offset> list = List();
    double startAngle = angleOfTime(tod1);
    if (Settings.startDayHour == Settings.endDayHour &&
    tod1.hour == Settings.startDayHour) {
      startAngle -= 4 * pi;
    }
    double endAngle = angleOfTime(tod2);
    for (double phi = startAngle; phi <= endAngle;
    phi += _anglePerMinute) {
      list.add(Offset(_center.x + r(phi) * cos(phi),
          _center.y + r(phi) * sin(phi)));
    }
    return list;
  }

  static void updateAll() {
    updateAllPoints();
    updateDealPoints();
    updateHourLabels();
    updateHatches();
  }

  static void handleTap(Offset tapPoint) {
    _selectedPoints = List();
    Point rad = Point(tapPoint.dx, tapPoint.dy) - _center;
    double magn = rad.magnitude;
    double phi = atan2(rad.y, rad.x);
    phi += 6 * pi; // to make it above _phi0
    while (phi >= _phi0) {
      phi -= 2 * pi;
    }
    while (phi >= _phi0 - 4 * pi) {
      if ((magn - r(phi)).abs() < _borderDist) {
        double minutes = (_phi0 - phi) / _anglePerMinute;
        TimeOfDay diff = DateTimeUtility.fromMinutes(minutes.floor());
        TimeOfDay tod = TimeOfDay.fromDateTime(
            Settings.endDay.subtract(Duration(
                hours: diff.hour,
                minutes: diff.minute
            ))
        );
        for (Deal deal in TODOList.todoList) {
          if (DateTimeUtility.isTimeBetween(
              tod, TimeOfDay.fromDateTime(deal.start),
              TimeOfDay.fromDateTime(deal.end))) {
            _selected = true;
            _selectedPoints =
                _getPointsOnCurve(TimeOfDay.fromDateTime(deal.start),
                    TimeOfDay.fromDateTime(deal.end));
            _selectedDeal = deal;
            return;
          }
        }
      }
      phi -= 2 * pi;
    }
    _selected = false;
  }

  static List<Offset> get allPoints => _allPoints;

  static List<Offset> get dealPoints => _dealPoints;

  static List<Offset> get hourLabels => _hourLabels;

  static List<Offset> get selectedPoints =>
      _selected ? _selectedPoints : List();

  static List<OffsetPair> get hatches => _hatches;

  static Deal get selectedDeal =>
      _selected ? _selectedDeal : null;
}