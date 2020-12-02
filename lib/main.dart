import 'package:case_planner/Pages/AddNotePage.dart';
import 'package:case_planner/WorkWithData/DatabaseManager.dart';
import 'package:flutter/material.dart';

import 'Pages/HomePage.dart';
import 'WorkWithData/TODOList.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseManager.initDB();
  await TODOList.initList();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Планировщик дел'),
      routes: {
        AddNotePage.route: (context) => AddNotePage(),
      },
    );
  }
}
