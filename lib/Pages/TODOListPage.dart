import 'package:case_planner/WorkWithData/AllDeals.dart';
import 'package:case_planner/WorkWithData/ClockFace.dart';
import 'package:case_planner/WorkWithData/Deal.dart';
import 'package:case_planner/WorkWithData/TODOList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../PageNumber.dart';


class TODOListContainer extends StatefulWidget {
  static const String route = '/TODOList';
  @override
  _TODOListContainerState createState() => _TODOListContainerState();
}

class _TODOListContainerState extends State<TODOListContainer> implements PageNumber {
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: TODOList.count,
              itemBuilder: (context, pos) =>
                  GestureDetector(
                    child: Container(
                      margin: EdgeInsets.all(8.0),
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFF0FF050),
                            width: 3.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10.0))
                      ),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Начало: ${Deal.dateTimeToString(
                                TODOList
                                    .at(pos)
                                    .start)}"),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Конец: ${Deal.dateTimeToString(
                                TODOList
                                    .at(pos)
                                    .end)}"),
                          ),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                  "${TODOList.at(pos).deal}",
                                  style: TextStyle(color: Colors.red[500])
                              )
                          ),
                        ],
                      ),
                    ),
                    onDoubleTap: () {
                      setState(() {
                        AllDeals.deleteNote(TODOList.at(pos));
                        TODOList.updateList();
                        ClockFace.updateDealPoints();
                      });
                    },
                  ),
            ),
          ),
        ]
    );
  }
}
