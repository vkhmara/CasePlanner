import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutProgramPage extends StatelessWidget {
  static const String route = '/aboutProgram';
  @override
  Widget build(BuildContext context) {
    log('show AboutProgramPage');
    return Scaffold(
      appBar: AppBar(
        title: Align(
          child: Container(
            margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
            child: Text(
                'О программе',
                style: TextStyle(
                  color: Colors.black,
                )
            ),
          ),
          alignment: Alignment.centerLeft,
        ),
        backgroundColor: Color(0xC0F0F0F0),
      ),
      body: Container(
        margin: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
                'Данное приложение поможет вам планировать дела на день.\n\n'
                    '1) Чтобы добавить дело, перейдите во вкладку, помеченную плюсиком',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 20.0,),
            SizedBox(
              height: 400.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  photo('images/Add deal 1.jpg'),
                  SizedBox(width: 20.0,),
                  photo('images/Add deal 2.jpg'),
                ],
              ),
            ),
            SizedBox(height: 20.0,),
            Text(
              '2) Чтобы удалить запись, нажмите и удерживайте её в списке',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 20.0,),
            SizedBox(
              height: 400.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  photo('images/Delete 1.jpg'),
                  SizedBox(width: 20.0,),
                  photo('images/Delete 2.jpg'),
                  SizedBox(width: 20.0,),
                  photo('images/Delete 3.jpg'),
                ],
              ),
            ),
            SizedBox(height: 20.0,),
            Text(
              '3) Чтобы перейти в визуальный режим, '
                  'перейдите во вкладку, помеченную циферблатом',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 20.0,),
            photo('images/Clockface.jpg'),
          ],
        ),
      ),
    );
  }

  Widget photo(String path) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Image.asset(
        path,
        width: 200.0,
        height: 400.0,
      ),
    );
  }
}
