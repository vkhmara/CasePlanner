import 'dart:convert';

class Note {
  String deal;
  DateTime start;
  DateTime end;
  bool done;

  Note({this.deal, this.start, this.end, this.done});

  Map<String, dynamic> toJson() =>
      {
        "note": deal,
        "start": start,
        "end": end,
        "done": done
      };

  Note.fromJson(Map<String, dynamic> json)
      : deal = json["deal"],
        start = DateTime.parse(json["start"]),
        end = DateTime.parse(json["end"]),
        done = json["done"] == 0 ? false : true;

  Note.fromString(String string) {
    Note.fromJson(json.decode(string));
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
}