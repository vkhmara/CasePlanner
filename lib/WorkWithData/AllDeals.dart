import 'dart:developer';

import 'package:case_planner/Settings/Settings.dart';

import 'DateTimeUtility.dart';
import 'DatabaseManager.dart';
import 'Deal.dart';

class AllDeals {

  static List<Deal> _allDeals = new List();

  static Future<void> initList() async {
    _allDeals = await DatabaseManager.downloadAll();
    _allDeals.removeWhere((element) => !element.validate());
    DatabaseManager.updateDB(_allDeals);
  }

  static Future<void> addDeal(Deal note) async {
   _allDeals.add(note);
    log('new deal was added');
  }

  static Future<bool> editDeal(Deal oldDeal, Deal newDeal) async {
    if (!_allDeals.contains(oldDeal)|| !newDeal.validate()) {
      return false;
    }
    _allDeals.remove(oldDeal);
    if (!isDealCompatible(newDeal)) {
      _allDeals.add(oldDeal);
      return false;
    }
    _allDeals.add(newDeal);
    log('deal was edited');
    return true;
  }

  static Future<void> deleteDeal(Deal deal) async {
    _allDeals.remove(deal);
    log('deal was deleted');
  }

  static Future<void> deleteDealAt(int pos) async {
    _allDeals.removeAt(pos);
    log('deal was deleted');
  }

  static bool isDealCompatible(Deal deal) {
    return _allDeals.every((element) => (
        DateTimeUtility.isLessOrEqual(deal.end, element.start) ||
            DateTimeUtility.isLessOrEqual(element.end, deal.start)
    ));
  }

  static List<Deal> dealsOnDay() {
    return _allDeals.where((element) =>
    DateTimeUtility.isLessOrEqual(Settings.startDay, element.start) &&
        DateTimeUtility.isLessOrEqual(element.start, Settings.endDay))
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