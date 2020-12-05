import 'package:flutter/material.dart';

class WorkWithDateAndTime {
  static bool isTimeLessOrEqual(TimeOfDay tod1, TimeOfDay tod2) {
    return tod1.hour < tod2.hour ||
        (tod1.hour == tod2.hour && tod1.minute <= tod2.minute);
  }

  static bool isTimeBetween(TimeOfDay checkedTod, TimeOfDay tod1,
      TimeOfDay tod2) {
    return (
        isTimeLessOrEqual(tod1, tod2) &&
            isTimeLessOrEqual(tod1, checkedTod) &&
            isTimeLessOrEqual(checkedTod, tod2)
    ) || (!isTimeLessOrEqual(tod1, tod2) && (
        isTimeLessOrEqual(tod1, checkedTod) ||
            isTimeLessOrEqual(checkedTod, tod2))
    );
  }

  static bool isLess(DateTime dt1, DateTime dt2) {
    return dt1.compareTo(dt2) < 0;
  }
}