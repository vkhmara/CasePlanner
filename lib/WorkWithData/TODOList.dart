import 'package:case_planner/WorkWithData/AllDeals.dart';
import 'package:case_planner/WorkWithData/WorkWithDateAndTime.dart';
import 'package:flutter/material.dart';

import 'Deal.dart';

class TODOList {

  static List<Deal> _todoList = new List();

  static bool isNoteCompatible(Deal deal) {
    return _todoList.every((element) => (
    WorkWithDateAndTime.isTimeLessOrEqual(TimeOfDay.fromDateTime(deal.end), TimeOfDay.fromDateTime(element.start)) ||
    WorkWithDateAndTime.isTimeLessOrEqual(TimeOfDay.fromDateTime(element.end), TimeOfDay.fromDateTime(deal.start))
    ));
  }

  static void initList() async {
    updateList();
  }

  static void addNote(Deal note) {
    _todoList.add(note);
  }

  static void updateList() async {
    _todoList = AllDeals.dealsOnDay();
  }

  static Deal at(int index) {
    return todoList[index];
  }

  static int get count {
    return _todoList.length;
  }

  static List<Deal> get todoList => _todoList;

}
