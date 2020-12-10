import 'dart:developer';

import 'package:case_planner/Pages/AddDealPage.dart';
import 'package:case_planner/Settings/Settings.dart';
import 'package:case_planner/WorkWithData/AllDeals.dart';
import 'package:case_planner/WorkWithData/DatabaseManager.dart';
import 'package:case_planner/WorkWithData/DateTimeUtility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'SettingsPage.dart';
import 'TODOListPage.dart';
import 'ClockFacePage.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  static const String route = '/homepage';

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String title = 'Текущий день ' + DateTimeUtility.dateAsString(Settings.startDay);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          child: Text(
              title,
              style: TextStyle(color: Colors.black)
          ),
          alignment: Alignment.center,
        ),
        backgroundColor: Color(0xC0F0F0F0),
      ),
      body: Column(
        children: [
          Expanded(
              child: ((pageNumber) {
                switch (Settings.currentPage) {
                  case 0:
                    return TODOListPage();
                  case 1:
                    return AddDealPage(() {
                      setState(() {
                        Settings.currentPage = 0;
                      });
                    });
                  case 2:
                    return ClockFacePage();
                  case 3:
                    return SettingsPage(() {
                      setState(() {
                        Settings.currentPage = 0;
                      });
                    },() {
                      setState(() {
                        title = 'Текущий день ' + DateTimeUtility.dateAsString(Settings.startDay);
                      });
                    });
                  default:
                    return null;
                }
              })(Settings.currentPage),
          ),
        ],
      ),
      backgroundColor: Color(0xF0CAD9D9),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Список дел',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Добавить',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Циферблат',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Настройки',
          ),
        ],
        onTap: (index) {
          setState(() {
            Settings.currentPage = index;
          });
        },
        currentIndex: Settings.currentPage,
        selectedItemColor: Colors.black,
        unselectedItemColor: Color(0xFF303030),
        backgroundColor: Color(0xFFFFFFFF),
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    Settings.clearAllInputData();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    log('initState HomePage');
  }

  @override
  void dispose() {
    log('dispose HomePage');
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    DatabaseManager.updateDB(AllDeals.allDeals);
    super.dispose();
  }
}
