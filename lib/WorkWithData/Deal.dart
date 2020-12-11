import 'dart:convert';

import 'package:case_planner/Settings/Settings.dart';

import 'DateTimeUtility.dart';

class Deal {
  String deal;
  DateTime start;
  DateTime end;
  bool done;

  Deal({this.deal, this.start, this.end, this.done});

  Deal.fromDeal(Deal deal):
      this.deal = deal.deal,
      this.start = deal.start,
      this.end = deal.end,
      this.done = deal.done;

  Map<String, dynamic> toJson() =>
      {
        "note": deal,
        "start": dateTimeToString(start),
        "end": dateTimeToString(end),
        "done": done
      };

  Deal.fromJson(Map<String, dynamic> json)
      : deal = json["deal"],
        start = DateTime.parse(json["start"]),
        end = DateTime.parse(json["end"]),
        done = json["done"] == 0 ? false : true;

  Deal.fromString(String string) {
    Deal.fromJson(json.decode(string));
  }

  String toString() {
    return toJson().toString();
  }

  static String _twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  static String dateTimeToString(DateTime dt) {
    return "${dt.year}-${_twoDigits(dt.month)}-${_twoDigits(dt.day)} "
        "${_twoDigits(dt.hour)}:${_twoDigits(dt.minute)}:${_twoDigits(dt.second)}";
  }

  bool _isInDay(DateTime currentStartDay, DateTime currentEndDay) {
    return DateTimeUtility.isLess(start, end) &&
        DateTimeUtility.isLessOrEqual(currentStartDay, start) &&
        DateTimeUtility.isLessOrEqual(start, currentEndDay) &&
        DateTimeUtility.isLessOrEqual(currentStartDay, end) &&
        DateTimeUtility.isLessOrEqual(end, currentEndDay);
  }

  bool validate() {
    DateTime currentStartDay = DateTimeUtility
        .withoutTime(start)
        .add(Duration(hours: Settings.startDayHour));
    DateTime currentEndDay = currentStartDay.add(Duration(hours:
    (Settings.endDayHour - Settings.startDayHour) <= 0 ?
    (Settings.endDayHour - Settings.startDayHour) + 24 :
    Settings.endDayHour - Settings.startDayHour));
    return (_isInDay(currentStartDay, currentEndDay) ||
    _isInDay(currentStartDay.subtract(Duration(days: 1)),
        currentEndDay.subtract(Duration(days: 1)))) //in case incorrect detecting day
        && deal.length <= 200 && deal.length > 0;
  }
}