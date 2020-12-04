import 'package:case_planner/WorkWithData/Deal.dart';
import 'package:case_planner/WorkWithData/TODOList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class TODOListContainer extends StatefulWidget {
  @override
  _TODOListContainerState createState() => _TODOListContainerState();
}

class _TODOListContainerState extends State<TODOListContainer> {
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: TODOList.count,
              itemBuilder: (context, pos) =>
                  Container(
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
                          child: Text("Start: ${Deal.dateTimeToString(
                              TODOList
                                  .at(pos)
                                  .start)}"),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("End: ${Deal.dateTimeToString(
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
            ),
          ),
        ]
    );
  }
}
