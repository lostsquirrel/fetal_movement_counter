import 'package:fetal_movement_counter/utils.dart';
import 'package:flutter/material.dart';

Widget buildGestationWeek(DateTime? expectedDate) {
  int toExpectedDate() {
    if (expectedDate == null) return 0;
    return expectedDate.difference(DateTime.now()).inDays;
  }

  int gestationDays() {
    int gestationTotal = daysInWeek * gestionWeeks;

    int gestationDays = gestationTotal - toExpectedDate();
    return gestationDays;
  }

  int gestationWeek() {
    return gestationDays() ~/ 7;
  }

  int gestationWeekPlusDays() {
    return gestationDays() % 7;
  }

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text("孕${gestationWeek()}周"),
      if (gestationWeekPlusDays() > 0) Text("+${gestationWeekPlusDays()}天"),
      // const Spacer(),
      Text(" 离预产期${toExpectedDate()}天"),
    ],
  );
}
