import 'dart:ui';

import 'package:case_planner/WorkWithData/ClockFace.dart';
import 'package:case_planner/WorkWithData/Deal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../PageNumber.dart';
import '../Painters.dart';

class PaintClockFacePage extends StatefulWidget implements PageNumber {
  @override
  _PaintClockFacePageState createState() => _PaintClockFacePageState();
}

class _PaintClockFacePageState extends State<PaintClockFacePage> {
  @override
  Widget build(BuildContext context) {
    Deal deal = ClockFace.selectedDeal;
    List<Widget> children = List();
    if (deal != null) {
      children.add(Container(
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
                  deal
                      .start)}"),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("End: ${Deal.dateTimeToString(
                  deal
                      .end)}"),
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    "${deal.deal}",
                    style: TextStyle(color: Colors.red[500])
                )
            ),
          ],
        ),
      ));
    }
    else {
      children.add(Container());
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
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }
}
