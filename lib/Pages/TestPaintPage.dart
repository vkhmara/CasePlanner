import 'dart:ui';

import 'package:case_planner/WorkWithData/ClockFace.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaintPage extends StatefulWidget {
  @override
  _PaintPageState createState() => _PaintPageState();
}

class _PaintPageState extends State<PaintPage> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: CustomPaint(
          size: Size(200.0, 300.0),
          painter: PaintBackground(),
          foregroundPainter: PaintForeground()
      ),
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

class PaintBackground extends CustomPainter {
  Paint _blackPaint = Paint()
  ..color = Colors.black
  ..style = PaintingStyle.stroke
  ..strokeWidth = 2.5;
  Paint _redPaint = Paint()
  ..color = Colors.red
  ..style = PaintingStyle.stroke
  ..strokeWidth = 3.0;

  @override
  void paint(Canvas canvas, Size size) {
    _blackPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    _redPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;
    ClockFace.changeA(13.0);
    ClockFace.changeR0(52.0);
    ClockFace.initClockFace();
    canvas.drawPoints(PointMode.points, ClockFace.allPoints, _blackPaint);
    canvas.drawPoints(PointMode.points, ClockFace.dealPoints, _redPaint);
  }
  bool shouldRepaint(PaintBackground old) => false;
}/* MyPaintBottom */

class PaintForeground extends CustomPainter {
  void paint(Canvas canvas, Size size) {
    // print('size $size');
    // print('draw Circle red');
    //
    // canvas.drawCircle(new Offset(0, 0), 50.0, Paint()
    //   ..color = Colors.red
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 5.0);
  } // paint

  bool shouldRepaint(PaintForeground old) => false;
}
