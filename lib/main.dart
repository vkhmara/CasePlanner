import 'package:case_planner/Pages/StartWorkPage.dart';
import 'package:case_planner/Settings/Settings.dart';
import 'package:case_planner/WorkWithData/AllDeals.dart';
import 'package:case_planner/WorkWithData/ClockFace.dart';
import 'package:case_planner/WorkWithData/DatabaseManager.dart';
import 'package:flutter/material.dart';

import 'Pages/HomePage.dart';
import 'WorkWithData/TODOList.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isInit = await Settings.initSettings();
  if (isInit) {
    await DatabaseManager.initDB();
    await AllDeals.initList();
    TODOList.initList();
    ClockFace.initClockFace();
  }
  runApp(MyApp(isInit: isInit));
}

class MyApp extends StatelessWidget {
  final bool isInit;
  MyApp({bool isInit}): isInit = isInit;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: isInit ? MyHomePage() : StartWorkPage(),
      routes: {
        MyHomePage.route: (context) => MyHomePage()
      },
    );
  }
}
