import 'package:case_planner/WorkWithData/AllDeals.dart';
import 'package:case_planner/WorkWithData/DateTimeUtility.dart';

import 'Deal.dart';

class TODOList {

  static List<Deal> _todoList = new List();

  static void initList() {
    updateList();
  }

  static void addDeal(Deal deal) {
    _todoList.add(deal);
  }

  static void deleteDeal(Deal deal) {
    if (_todoList.contains(deal)) {
      _todoList.remove(deal);
    }
  }

  static void deleteDealAt(int pos) {
    _todoList.removeAt(pos);
  }

  static int _compare(Deal deal1, Deal deal2) {
    return DateTimeUtility.isLess(deal1.start, deal2.start) ? -1:
    (DateTimeUtility.isLessOrEqual(deal1.start, deal2.start) ? 0 : 1);
  }

  static void editDealAt(int pos, Deal newDeal) {
    todoList[pos] = newDeal;
  }

  static bool switchDoneAt(int pos) {
    bool done = !_todoList[pos].done;
    editDealAt(pos, Deal(
        deal: _todoList[pos].deal,
        start: _todoList[pos].start,
        end: _todoList[pos].end,
        done: done
    ));
    return done;
  }

  static void updateList() {
    _todoList = AllDeals.dealsOnDay()
      ..sort(_compare);
  }

  static Deal at(int index) {
    return todoList[index];
  }

  static int get count {
    return _todoList.length;
  }

  static List<Deal> get todoList => _todoList;

}
