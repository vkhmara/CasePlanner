import 'dart:convert';

import 'package:case_planner/CurrentDay/Prefs.dart';

class Deal {
  String deal;
  DateTime start;
  DateTime end;
  bool done;

  Deal({this.deal, this.start, this.end, this.done});

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
    return "${dt.year}-${_twoDigits(dt.month)}-${_twoDigits(dt.day)}T"
        "${_twoDigits(dt.hour)}:${_twoDigits(dt.minute)}:${_twoDigits(dt.second)}";
  }

  static bool _isLess(DateTime dt1, DateTime dt2) {
    return dt1.compareTo(dt2) < 0;
  }

  bool validate() {
    if (Prefs.startDayHour < Prefs.endDayHour) {
      return start.day == end.day &&
          Prefs.startDayHour <= start.hour &&
          _isLess(start, end) &&
          end.hour <= Prefs.endDayHour &&
          deal.length <= 200 && deal.length > 0;
    }
    return _isLess(start, end) && start.day + 1 >= end.day && (
        (Prefs.startDayHour <= start.day && start.day <= 23) ||
            (0 <= start.day && start.day <= Prefs.endDayHour)) && (
            (Prefs.startDayHour <= end.day && end.day <= 23) ||
                (0 <= end.day && end.day <= Prefs.endDayHour)) &&
        deal.length <= 200 && deal.length > 0;

  }
}