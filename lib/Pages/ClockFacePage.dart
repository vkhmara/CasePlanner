import 'dart:developer';
import 'dart:ui';

import 'package:case_planner/HelperComponents/DealContainer.dart';
import 'package:case_planner/WorkWithData/ClockFace.dart';
import 'package:case_planner/WorkWithData/Deal.dart';
import 'package:case_planner/WorkWithData/TODOList.dart';
import 'package:flutter/material.dart';

import 'package:case_planner/HelperComponents/Painters.dart';

class ClockFacePage extends StatefulWidget {

  @override
  _ClockFacePageState createState() => _ClockFacePageState();
}

class _ClockFacePageState extends State<ClockFacePage> {
  @override
  Widget build(BuildContext context) {
    Deal deal = ClockFace.selectedDeal;
    List<Widget> children = List();
    if (deal != null) {
      children.add(Expanded(
        child: Container(
          margin: EdgeInsets.all(1.0),
          padding: EdgeInsets.all(1.0),
          child: ListView.builder(
            itemCount: 1,
              itemBuilder: (context, pos) =>
                  DealContainer(
                    dealPos: TODOList.todoList.indexOf(deal),
                    isImmutable: true
                  ),
          ),
        ),
      ));
    }
    else {
      children.add(Padding(
        padding: const EdgeInsets.all(50.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(width: 0.05)
          ),
          child: SizedBox(
            width: 300,
            height: 120,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                'Нажмите на красные дуги,\n'
                    'чтобы посмотреть дела.\n'
                    'Если таких нет, то\n'
                    'добавьте дело на день',
                style: TextStyle(
                  color: Color(0x50000000),
                  fontSize: 16
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ));
    }
    PaintBackground painting = PaintBackground();
    children.add(Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        child: CustomPaint(
          size: Size(350.0, 350.0),
          painter: PaintBackground(),
          foregroundPainter: PaintForeground(),
        ),
        onTapDown: (details) {
          ClockFace.selectedPoint = details.localPosition;
          setState(() {
            ClockFace.handleTap(details.localPosition);
          });
          painting.shouldRepaint(null);
        },
      ),
    ));

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children,
    );
  }

  @override
  void dispose() {
    ClockFace.handleTap(Offset(0, 0));
    log('dispose ClockFacePage');
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    log('init ClockFacePage');
  }
}
