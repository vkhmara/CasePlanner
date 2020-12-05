import 'package:case_planner/CurrentDay/Prefs.dart';
import 'package:case_planner/Pages/TODOListPage.dart';
import 'package:case_planner/WorkWithData/AllDeals.dart';
import 'package:case_planner/WorkWithData/ClockFace.dart';
import 'package:case_planner/WorkWithData/DatabaseManager.dart';
import 'package:flutter/material.dart';

import 'Pages/HomePage.dart';
import 'WorkWithData/TODOList.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Prefs.initPrefs();
  await DatabaseManager.initDB();
  await AllDeals.initList();
  TODOList.initList();
  ClockFace.initClockFace();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  String title;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: '${Prefs.startDay.day}.${Prefs.startDay.month}'),
      routes: {
        TODOListContainer.route: (BuildContext context) => TODOListContainer(),
        MyHomePage.route: (BuildContext context) => MyHomePage(title: '${Prefs.startDay.day}.${Prefs.startDay.month}'),
      },
    );
  }
}
