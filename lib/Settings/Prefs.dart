import 'package:case_planner/WorkWithData/AllDeals.dart';
import 'package:case_planner/WorkWithData/ClockFace.dart';
import 'package:case_planner/WorkWithData/TODOList.dart';

class Settings {
  static int _startDayHour;
  static int _endDayHour;
  static DateTime _startDay;
  static DateTime _endDay;

  static int get startDayHour => _startDayHour;

  static int get endDayHour => _endDayHour;

  static DateTime get startDay => _startDay;

  static DateTime get endDay => _endDay;

  static void initPrefs() {
    _startDayHour = 9;
    _endDayHour = 23;
    _currentDay = DateTime.now();
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
    AllDeals.changeDayInterval();
    TODOList.updateList();
    ClockFace.updateAll();
  }
}