import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:case_planner/Settings/Settings.dart';
import 'package:case_planner/WorkWithData/ClockFace.dart';

class PaintBackground extends CustomPainter {
  final Paint _clockfaceLinePaint = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.5;
  final Paint _hatchesPaint = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.5;
  final Paint _dealLinePaint = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.stroke
    ..strokeWidth = 4.0;
  final Paint _selectedDealLinePaint = Paint()
    ..color = Colors.pink
    ..style = PaintingStyle.stroke
    ..strokeWidth = 5.0;
  final TextStyle style = TextStyle(
    color: Colors.black,
    decorationStyle: TextDecorationStyle.solid,
    decorationThickness: 0.1,
  );

  @override
  void paint(Canvas canvas, Size size) {

    int hour = Settings.startDayHour;
    for (Offset point in ClockFace.hourLabels) {
      final TextPainter textPainter = TextPainter(
          text: TextSpan(text: hour < 10 ? ' $hour' : '$hour', style: style),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr
      )
        ..layout(maxWidth: size.width - 12.0 - 12.0);
      textPainter.paint(canvas, point);
      hour = (hour + 1) % 24;
    }

    canvas.drawPoints(PointMode.points, ClockFace.allPoints, _clockfaceLinePaint);
    canvas.drawPoints(PointMode.points, ClockFace.dealPoints, _dealLinePaint);
    for (OffsetPair pair in ClockFace.hatches) {
      canvas.drawLine(pair.local, pair.global, _hatchesPaint);
    }
    canvas.drawPoints(PointMode.points, ClockFace.selectedPoints, _selectedDealLinePaint);
  }
  bool shouldRepaint(PaintBackground old) => true;
}

class PaintForeground extends CustomPainter {
  void paint(Canvas canvas, Size size) {
  }

  bool shouldRepaint(PaintForeground old) => false;
}