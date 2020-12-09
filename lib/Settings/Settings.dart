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
  static int currentPage = 0;
  static SharedPreferences _prefs;

  // You can show start menu where the user will input the day interval
  static Future<bool> initSettings() async {
    _prefs = await SharedPreferences.getInstance();
    if (!_prefs.getKeys().contains('startDayHour')) {
      return false;
    }
    _startDayHour = _prefs.getInt('startDayHour');
    _endDayHour = _prefs.getInt('endDayHour');
    _currentDay = DateTime.now()
        .subtract(Duration(hours: _startDayHour));
    return true;
  }

  static void changeCurrentDay(DateTime newDay) {
    _currentDay = newDay;
    _updateInputFields();
    TODOList.updateList();
    ClockFace.changeDay();
  }

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

    _startDay = _startDay.add(Duration(hours: newStartDayHour - _startDayHour));
    _startDayHour = newStartDayHour;
    _endDayHour = newEndDayHour;
    _endDay = _startDay;
    _endDay = _endDay.add(Duration( hours: _startDayHour < _endDayHour ?
    _endDayHour - _startDayHour :
    _endDayHour - _startDayHour + 24));

    _prefs.setInt('startDayHour', _startDayHour);
    _prefs.setInt('endDayHour', _endDayHour);
    _updateInputFields();
    AllDeals.changeDayInterval();
    TODOList.updateList();
    ClockFace.updateAll();
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
  }

  static int get startDayHour => _startDayHour;

  static int get endDayHour => _endDayHour;

  static DateTime get startDay => _startDay;

  static DateTime get endDay => _endDay;

  static DateTime get inputEndDate {
    return _prefs.containsKey('inputEndDate')?
    DateTime.fromMillisecondsSinceEpoch(_prefs.getInt('inputEndDate')) :
    _endDay;
  }

  static set inputEndDate(DateTime value) {
    _prefs.setInt('inputEndDate', value.millisecondsSinceEpoch);
  }

  static TimeOfDay get inputStartTime {
    return _prefs.containsKey('inputStartTime')?
    DateTimeUtility.fromMinutes(_prefs.getInt('inputStartTime')) :
    TimeOfDay(hour:startDayHour, minute: 0);
  }

  static set inputStartTime(TimeOfDay value) {
    _prefs.setInt('inputStartTime', DateTimeUtility.toMinutes(value));
  }

  static TimeOfDay get inputEndTime {
    return _prefs.containsKey('inputEndTime')?
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

  static String get inputDeal {
    return _prefs.containsKey('inputDeal')?
    _prefs.getString('inputDeal') : '';
  }

  static set inputDeal(String value) {
    _prefs.setString('inputDeal', value);
  }
}