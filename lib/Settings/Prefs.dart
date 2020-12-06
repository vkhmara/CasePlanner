import 'package:case_planner/WorkWithData/AllDeals.dart';
import 'package:case_planner/WorkWithData/ClockFace.dart';
import 'package:case_planner/WorkWithData/TODOList.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  static int _startDayHour;
  static int _endDayHour;
  static DateTime _startDay;
  static DateTime _endDay;
  static SharedPreferences _prefs;

  static int get startDayHour => _startDayHour;

  static int get endDayHour => _endDayHour;

  static DateTime get startDay => _startDay;

  static DateTime get endDay => _endDay;

  // You can show start menu where the user will input the day interval
  static Future<bool> initSettings() async {
    _prefs = await SharedPreferences.getInstance();
    if (!_prefs.getKeys().contains('startDayHour')) {
      return false;
    }
    _startDayHour = _prefs.getInt('startDayHour');
    _endDayHour = _prefs.getInt('endDayHour');
    _currentDay = DateTime.now();
    return true;
  }

  static void changeCurrentDay(DateTime newDay) {
    _currentDay = newDay;
    TODOList.updateList();
    ClockFace.changeDay();
  }

  /// [newDay] can be any. Only the date part is important
  static set _currentDay(DateTime newDay) {
    _startDay = newDay.subtract(
        Duration(
            hours: newDay.hour,
            minutes: newDay.minute,
            seconds: newDay.second,
            milliseconds: newDay.millisecond,
            microseconds: newDay.microsecond
        )).add(Duration(hours: _startDayHour));
    _endDay = _startDay.add(Duration(
        hours: _startDayHour < _endDayHour ?
        _endDayHour - _startDayHour :
        _endDayHour - _startDayHour + 24
    ));
  }

  ///[newStartDayHour] and [newEndDayHour] must be from 0 till 23
  static void changeDayInterval(int newStartDayHour, int newEndDayHour) {
    if (newStartDayHour < 0 || newStartDayHour > 23 ||
        newEndDayHour < 0 || newEndDayHour > 23) {
      return;
    }

    _startDay = _startDay.add(Duration(hours: _startDayHour - newStartDayHour));
    _startDayHour = newStartDayHour;
    _endDayHour = newEndDayHour;
    _endDay = _startDay;
    _endDay = _endDay.add(Duration( hours: _startDayHour < _endDayHour ?
    _endDayHour - _startDayHour :
    _endDayHour - _startDayHour + 24));

    _prefs.setInt('startDayHour', _startDayHour);
    _prefs.setInt('endDayHour', _endDayHour);
    AllDeals.changeDayInterval();
    TODOList.updateList();
    ClockFace.updateAll();
  }
}