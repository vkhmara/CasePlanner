import 'package:case_planner/Pages/AddNotePage.dart';
import 'package:flutter/material.dart';

import 'package:case_planner/PageNumber.dart';
import 'SettingsPage.dart';
import 'TODOListPage.dart';
import 'TestPaintPage.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  static const String route = '/homepage';

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> implements PageNumber {

  final List<Widget> _children = [
    TODOListContainer(),
    AddNotePage(),
    PaintPage(),
    SettingsPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(color: Colors.pink)),
        backgroundColor: Colors.white,
      ),
      body: _children[PageNumber.currentPage],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Список дел',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Создать',
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
            PageNumber.currentPage = index;
          });
        },
        currentIndex: PageNumber.currentPage,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
      ),
    );
  }
}
