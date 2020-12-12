import 'package:case_planner/Pages/StartWorkPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('StartWorkPage testing', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
          theme: ThemeData(
        primarySwatch: Colors.cyan,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
        home: StartWorkPage(),
      )
    );
    final startDayField = find.widgetWithText(SizedBox, 'Начало дня');
    expect(startDayField, findsOneWidget);
    final endDayField = find.widgetWithText(SizedBox, 'Конец дня');
    expect(endDayField, findsOneWidget);
    final button = find.text('Начать\nработу');
    expect(button, findsOneWidget);
    final inputFields = find.byType(TextFormField);
    expect(inputFields.evaluate().length, 2);
    await tester.tap(inputFields.at(0));
    await tester.enterText(inputFields.at(0), '2');
    await tester.pump();
    expect(find.text('Неверное время'), findsNothing);
    await tester.tap(inputFields.at(1));
    await tester.enterText(inputFields.at(1), '28');
    await tester.pump();
    expect(find.text('Неверное время'), findsOneWidget);
  });
}