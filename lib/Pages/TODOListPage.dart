import 'dart:developer';

import 'package:case_planner/WorkWithData/AllDeals.dart';
import 'package:case_planner/WorkWithData/ClockFace.dart';
import 'package:case_planner/WorkWithData/TODOList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:case_planner/HelperComponents/DealContainer.dart';


class TODOListPage extends StatefulWidget {
  static const String route = '/TODOList';
  @override
  _TODOListPageState createState() => _TODOListPageState();
}

class _TODOListPageState extends State<TODOListPage> {
  @override
  Widget build(BuildContext context) {
    if (TODOList.count == 0) {
      return Column(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Text('На текущий день ничего не запланировано'),
              ),
            ),
          ]
      );
    }
    return Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: TODOList.count,
              itemBuilder: (context, pos) =>
                  GestureDetector(
                    child: DealContainer(dealPos: pos),
                    onLongPressStart: (details) {
                      showDialog(context: context,
                          builder: (BuildContext buildContext) {
                            return Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(5.0),
                                    color: Colors.white,
                                    alignment: Alignment.center,
                                    child: Text('Вы уверены, что хотите удалить запись?',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.0,
                                    ))
                                  ),
                                  Container(
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: RaisedButton(
                                              onPressed: () {
                                                Navigator.pop(buildContext, true);
                                              },
                                              child: Text('Да'),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: RaisedButton(
                                              onPressed: () {
                                                Navigator.pop(buildContext, false);
                                              },
                                              child: Text('Нет'),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).
                      then((toDelete) async {
                        if (toDelete == null || !toDelete) {
                          return;
                        }
                        await AllDeals.deleteDeal(TODOList.at(pos));
                        setState(() {
                          TODOList.deleteDealAt(pos);
                          ClockFace.updateDealPoints();
                        });
                      });
                    },
                  ),
            ),
          ),
        ]
    );
  }

  @override
  void dispose() {
    log('dispose TODOListPage');
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    log('init TODOListPage');
  }
}
