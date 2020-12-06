import 'package:case_planner/Pages/StartWorkPage.dart';
import 'package:case_planner/Settings/Prefs.dart';
import 'package:case_planner/Pages/TODOListPage.dart';
import 'package:case_planner/WorkWithData/AllDeals.dart';
import 'package:case_planner/WorkWithData/ClockFace.dart';
import 'package:case_planner/WorkWithData/DatabaseManager.dart';
import 'package:flutter/material.dart';
//import 'package:shared_preferences/shared_preferences.dart';

import 'Pages/HomePage.dart';
import 'WorkWithData/TODOList.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SharedPreferences sp = await SharedPreferences.getInstance();
  // sp.remove('startDayHour');
  // sp.remove('endDayHour');
  bool isInit = await Settings.initSettings();
  if (!isInit) {
    runApp(MyApp(isInit: isInit));
  }
  else {
    await DatabaseManager.initDB();
    await AllDeals.initList();
    TODOList.initList();
    ClockFace.initClockFace();
    runApp(MyApp(isInit: isInit));
  }
}

class MyApp extends StatelessWidget {
  final bool isInit;
  MyApp({bool isInit}): isInit = isInit;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: isInit ? MyHomePage(title:
      '${Settings.startDay.day < 10 ? '0' : ''}${Settings.startDay.day}.'
          '${Settings.startDay.month < 10 ? '0' : ''}${Settings.startDay.month}') :
      StartWorkPage(),
      routes: {
        TODOListContainer.route: (BuildContext context) => TODOListContainer(),
        MyHomePage.route: (BuildContext context) => MyHomePage(title: '${Settings.startDay.day < 10 ? '0' : ''}${Settings.startDay.day}.'
            '${Settings.startDay.month < 10 ? '0' : ''}${Settings.startDay.month}'),
      },
    );
  }
}
