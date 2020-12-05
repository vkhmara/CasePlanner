import 'package:case_planner/CurrentDay/Prefs.dart';

import 'WorkWithDateAndTime.dart';
import 'DatabaseManager.dart';
import 'Deal.dart';

class AllDeals {
  // TODO: edit deals
  static List<Deal> _allDeals = new List();

  static Future<void> initList() async {
    _allDeals = await DatabaseManager.downloadAll();
    changeDayInterval();
    print(count);
  }

  static void addNote(Deal note) {
    DatabaseManager.addNote(note);
    _allDeals.add(note);
  }

  static Future<void> deleteNote(Deal note) async {
    await DatabaseManager.deleteNote(note);
    _allDeals.remove(note);
  }

  static Future<void> deleteNoteAt(int pos) async {
    await DatabaseManager.deleteNote(_allDeals[pos]);
    _allDeals.removeAt(pos);
  }

  static List<Deal> dealsOnDay() {
    return _allDeals.where((element) =>
    WorkWithDateAndTime.isLess(Prefs.startDay, element.start) &&
        WorkWithDateAndTime.isLess(element.start, Prefs.endDay))
        .toList();
  }

  static void changeDayInterval() {
    _allDeals.removeWhere((element) => !element.validate());
    DatabaseManager.updateDB(_allDeals);
  }

  static Deal at(int index) {
    return _allDeals[index];
  }

  static int get count {
    return _allDeals.length;
  }

  static List<Deal> get allDeals => _allDeals;

}