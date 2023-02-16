import 'package:fetal_movement_counter/utils.dart';
import 'package:flutter/material.dart';

class GestationWeekView extends StatelessWidget {
  const GestationWeekView({super.key, required this.expectedDate});

  final DateTime expectedDate;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("孕$_gestationWeek周"),
        if (_gestationWeekPlusDays > 0) Text("+$_gestationWeekPlusDays天"),
        // const Spacer(),
        Text(" 离预产期$_toExpectedDate天"),
      ],
    );
  }

  int get _toExpectedDate {
    return expectedDate.difference(DateTime.now()).inDays;
  }

  int get _gestationDays {
    int gestationTotal = daysInWeek * gestionWeeks;

    int gestationDays = gestationTotal - _toExpectedDate;
    return gestationDays;
  }

  int get _gestationWeek {
    return _gestationDays ~/ 7;
  }

  int get _gestationWeekPlusDays {
    return _gestationDays % 7;
  }
}
