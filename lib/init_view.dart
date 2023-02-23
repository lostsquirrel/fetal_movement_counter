import 'package:fetal_movement_counter/info_service.dart';
import 'package:flutter/material.dart';

import 'common.dart';
import 'utils.dart';

// set the expected date of childbirth as first start
class ExpectedDate extends StatefulWidget {
  const ExpectedDate({super.key});
  static const routeName = "/expected_date";

  @override
  State<ExpectedDate> createState() => _ExpectedDateState();
}

class _ExpectedDateState extends State<ExpectedDate> {
  final _formKey = GlobalKey<FormState>();
  final monthes = 12;
  late int year;
  late int month;
  late int day;
  late DateTime start;
  late DateTime end;
  late bool yearGap;

  @override
  void initState() {
    super.initState();
    var current = DateTime.now();
    year = current.year;
    month = current.month;
    day = current.day;
    getInfoModel().then((value) {
      var expectedDate = value.expectedDate;
      if (expectedDate != null) {
        setState(() {
          year = expectedDate.year;
          month = expectedDate.month;
          day = expectedDate.day;
        });
      }
    });

    yearGap = month != 1;
    start = DateTime(current.year, current.month, current.day);
    end = DateTime(current.year, current.month + monthes, current.day);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("预产期设置")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [_buildForm(context)],
        ),
      ),
      bottomNavigationBar: buildNavBar(2, context),
    );
  }

  Form _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ["年", "月", "日"].map((e) => _label(e)).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildYear(),
            _buildMonth(),
            _buildDay(),
          ],
        ),
        Row(
          children: [
            Expanded(
                child: ElevatedButton(
              child: const Text("确定"),
              onPressed: () {
                addExpectedDate(DateTime(year, month, day)).then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("设置成功"),
                    ),
                  );
                });
              },
            ))
          ],
        ),
      ]),
    );
  }

  DropdownButton<int> _buildYear() {
    List<int> years() {
      return [start.year, if (end.year != start.year) end.year];
    }

    return _builder(start.year, years(), start.year, (e) {
      setState(() {
        year = e!;
      });
    });
  }

  Widget _buildMonth() {
    var m = Iterable<int>.generate(monthes, (i) => i + 1).toList();
    int startItem = 1;
    if (yearGap && year == start.year) {
      startItem = start.month;
    }
    // print(m);
    return _builder(month, m, startItem, (e) {
      setState(() {
        month = e!;
      });
    });
  }

  Widget _buildDay() {
    var days =
        Iterable<int>.generate(daysInMonth(year, month), (i) => i + 1).toList();
    int startItem = 1;
    if (start.month == month && start.year == year) {
      startItem = start.day;
    }

    return _builder(day, days, startItem, (e) {
      setState(() {
        day = e!;
      });
    });
  }

  DropdownButton<int> _builder(
      int initValue, List<int> items, int start, Function(int?) handler) {
    return DropdownButton<int>(
      value: initValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      onChanged: handler,
      items: items.map<DropdownMenuItem<int>>((e) {
        var enabled2 = e >= start;
        return DropdownMenuItem<int>(
          value: e,
          enabled: enabled2,
          child: Text(
            e.toString(),
            style: TextStyle(
              color: enabled2 ? null : Colors.grey,
              fontSize: enabled2 ? 35 : 16,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _label(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 35,
      ),
    );
  }
}
