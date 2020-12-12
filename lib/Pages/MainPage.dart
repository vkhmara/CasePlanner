import 'dart:developer';

import 'package:case_planner/Pages/AddDealPage.dart';
import 'package:case_planner/Settings/Settings.dart';
import 'package:case_planner/WorkWithData/DateTimeUtility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'SettingsPage.dart';
import 'TODOListPage.dart';
import 'ClockFacePage.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  static const String route = '/homepage';

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String title = 'Текущий день ' + DateTimeUtility.dateAsString(Settings.startDay);

  Widget getCurrentPage() {
    switch (Settings.currentPage) {
      case 0:
        return TODOListPage();
      case 1:
        return AddDealPage(
            toTODOListPage: () {
              setState(() {
                Settings.currentPage = 0;
              });
            });
      case 2:
        return ClockFacePage();
      case 3:
        return SettingsPage(
            toTODOListPage: () {
              setState(() {
                Settings.currentPage = 0;
              });
            },
            updateAppBar: () {
              setState(() {
                title = 'Текущий день ' + DateTimeUtility
                    .dateAsString(Settings.startDay);
              });
            });
      default:
        return null;
    }
  }

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
            child: getCurrentPage(),
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
    log('initState MainPage');
  }

  @override
  void dispose() {
    log('dispose MainPage');
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }
}
