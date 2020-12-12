import 'dart:developer';

import 'package:case_planner/WorkWithData/AllDeals.dart';
import 'package:case_planner/WorkWithData/ClockFace.dart';
import 'package:case_planner/WorkWithData/DateTimeUtility.dart';
import 'package:case_planner/WorkWithData/TODOList.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  static int _startDayHour;
  static int _endDayHour;
  static DateTime _startDay;
  static DateTime _endDay;
  static DateTime _minimStartDay;
  static DateTime _minimEndDay;
  static int currentPage = 0;
  static SharedPreferences _prefs;


  static Future<bool> initSettings() async {
    _prefs = await SharedPreferences.getInstance();
    if (!_prefs.getKeys().contains('startDayHour')) {
      return false;
    }
    _startDayHour = _prefs.getInt('startDayHour');
    _endDayHour = _prefs.getInt('endDayHour');

    initMinimDates();

    _startDay = _minimStartDay;
    _endDay = _minimEndDay;
    return true;
  }

  static void initMinimDates() {
    DateTime now = DateTime.now();
    _minimStartDay = DateTimeUtility
        .withoutTime(now)
        .add(Duration(hours: _startDayHour));
    _minimEndDay = _minimStartDay.add(Duration(
        hours: _startDayHour < _endDayHour ?
        _endDayHour - _startDayHour :
        _endDayHour - _startDayHour + 24
    ));
    if (now.isBefore(_minimStartDay)) {
      _minimStartDay = _minimStartDay.subtract(Duration(days: 1));
      _minimEndDay = _minimEndDay.subtract(Duration(days: 1));
    }
  }

  static void changeCurrentDay(DateTime newDay) {
    _currentDay = newDay;
    _updateInputFields();
    TODOList.updateList();
    ClockFace.changeDay();
    log('current day changed');
  }

  static DateTime get minimStartDay => _minimStartDay;

  /// [newDay] can be any. Only the date part is important
  static set _currentDay(DateTime newDay) {
    _startDay = DateTimeUtility
        .withoutTime(newDay)
        .add(Duration(hours: _startDayHour));
    _endDay = _startDay.add(Duration(
        hours: _startDayHour < _endDayHour ?
        _endDayHour - _startDayHour :
        _endDayHour - _startDayHour + 24
    ));
  }

  ///[newStartDayHour] and [newEndDayHour] should be from 0 till 23
  static void changeDayInterval(int newStartDayHour, int newEndDayHour) {
    if (newStartDayHour < 0 || newStartDayHour > 23 ||
        newEndDayHour < 0 || newEndDayHour > 23) {
      return;
    }
    _startDayHour = newStartDayHour;
    _endDayHour = newEndDayHour;
    _prefs.setInt('startDayHour', _startDayHour);
    _prefs.setInt('endDayHour', _endDayHour);

    initMinimDates();
    _startDay = _minimStartDay;
    _endDay = _minimEndDay;

    _updateInputFields();
    AllDeals.changeDayInterval();
    TODOList.updateList();
    ClockFace.updateAll();
    log('day interval changed');
  }

  static void _updateInputFields() {
    inputStartDate = _startDay;
    inputStartTime = DateTimeUtility.timeFromHour(_startDayHour);
    inputEndDate = _endDay;
    inputEndTime = DateTimeUtility.timeFromHour(_endDayHour);
  }

  static Future<void> clearAllInputData() async {
    await _prefs.remove('inputStartDate');
    await _prefs.remove('inputEndDate');
    await _prefs.remove('inputStartTime');
    await _prefs.remove('inputEndTime');
    await _prefs.remove('inputDeal');
    log('all input data disposed');
  }

  static int get startDayHour => _startDayHour;

  static int get endDayHour => _endDayHour;

  static DateTime get startDay => _startDay;

  static DateTime get endDay => _endDay;

  static DateTime get minimEndDay => _minimEndDay;

  static TimeOfDay get inputStartTime {
    return _prefs.containsKey('inputStartTime') ?
    DateTimeUtility.fromMinutes(_prefs.getInt('inputStartTime')) :
    TimeOfDay(hour:startDayHour, minute: 0);
  }

  static set inputStartTime(TimeOfDay value) {
    _prefs.setInt('inputStartTime', DateTimeUtility.toMinutes(value));
  }

  static TimeOfDay get inputEndTime {
    return _prefs.containsKey('inputEndTime') ?
    DateTimeUtility.fromMinutes(_prefs.getInt('inputEndTime')) :
    TimeOfDay(hour:endDayHour, minute: 0);
  }

  static set inputEndTime(TimeOfDay value) {
    _prefs.setInt('inputEndTime', DateTimeUtility.toMinutes(value));
  }

  static DateTime get inputStartDate {
    return _prefs.containsKey('inputStartDate') ?
    DateTime.fromMillisecondsSinceEpoch(_prefs.getInt('inputStartDate')) :
        _startDay;
  }

  static set inputStartDate(DateTime value) {
    _prefs.setInt('inputStartDate', value.millisecondsSinceEpoch);
  }

  static DateTime get inputEndDate {
    return _prefs.containsKey('inputEndDate')?
    DateTime.fromMillisecondsSinceEpoch(_prefs.getInt('inputEndDate')) :
    _endDay;
  }

  static set inputEndDate(DateTime value) {
    _prefs.setInt('inputEndDate', value.millisecondsSinceEpoch);
  }

  static String get inputDeal {
    return _prefs.containsKey('inputDeal') ?
    _prefs.getString('inputDeal') : '';
  }

  static set inputDeal(String value) {
    _prefs.setString('inputDeal', value);
  }
}