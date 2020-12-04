import 'package:case_planner/Pages/AddNotePage.dart';
import 'package:flutter/material.dart';

import 'TODOListPage.dart';
import 'TestPaintPage.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _currentIndex = 0;
  final List<Widget> _children = [
    TODOListContainer(),
    AddNotePage(),
    PaintPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(color: Colors.pink)),
        backgroundColor: Colors.white,
      ),
      body: _children[_currentIndex],
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
            label: 'School',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        currentIndex: _currentIndex,
      ),
    );
  }
}
