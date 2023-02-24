import 'dart:async';

import 'package:flutter/material.dart';

import 'common.dart';
import 'counter_service.dart' as counter_service;
import 'models/counter_model.dart';

class CounterView extends StatefulWidget {
  const CounterView({super.key});
  static const routeName = "/counter";
  @override
  State<CounterView> createState() => _CounterViewState();
}

int calCountDownSeconds(DateTime start) {
  return start
      .add(const Duration(hours: 1))
      .difference(DateTime.now())
      .inSeconds;
}

class _CounterViewState extends State<CounterView> {
  // CounterModel counterModel = CounterModel([]);

  late int jobInSeconds = 0;

  late int count = 0;
  late int total = 0;
  late bool hasJob = false;
  late DateTime startTime = markerDate;

  int get jobShowMinute {
    return jobInSeconds ~/ 60;
  }

  int get jobShowSecond {
    return jobInSeconds % 60;
  }

  late int buttonIndex = 0;

  bool get finishedJob =>
      startTime != markerDate &&
      DateTime.now().difference(startTime).inHours > 1;
  late Timer countDown;

  @override
  void initState() {
    super.initState();
    countDown = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        if (jobInSeconds <= 0) {
          countDown.cancel();
          // buttonIndex = 2;
        }
        jobInSeconds = jobInSeconds > 0 ? jobInSeconds - 1 : 0;
      });
    });
    counter_service.getCounter().then((CounterModel value) {
      setState(() {
        // counterModel = value;
        count = value.count;
        total = value.total;
        hasJob = value.hasJob;
        startTime = value.startTime;
        if (startTime == markerDate) {
          jobInSeconds = 0;
          buttonIndex = 0;
        } else {
          jobInSeconds = calCountDownSeconds(value.startTime);
          buttonIndex = 1;
        }
      });
    });
  }

  @override
  void dispose() {
    countDown.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("数一数")),
      body: Column(
        children: [
          _buildHeadRow(),
          _buildCountdown(),
          Text("点击次数: $total"),
          const Spacer(
            flex: 8,
          ),
          _buildButtons(),
          const Spacer(),
        ],
      ),
      bottomNavigationBar: buildNavBar(1, context),
    );
  }

  Widget _buildButtons() {
    var messages = ["开始数", "动了", "完成"];
    var handlers = [
      () {
        counter_service.startJob().then((_) {
          counter_service.getCounter().then((value) {
            setState(() {
              total = value.total;
              hasJob = value.hasJob;
              startTime = value.startTime;
              jobInSeconds = calCountDownSeconds(value.startTime);
              buttonIndex = 1;
            });
          });
        });
      },
      () {
        counter_service.addCount().then((_) {
          counter_service.getCounter().then((value) {
            setState(() {
              count = value.count;
              total = value.total;
            });
          });
        });
      },
      () {}
    ];

    return OutlinedButton(
      onPressed: handlers[buttonIndex],
      style: OutlinedButton.styleFrom(
          backgroundColor: Colors.black12,
          // maximumSize: Size.fromWidth(64),
          // minimumSize: Size(64, 32),
          textStyle: const TextStyle(fontSize: 32)),
      child: Container(
        padding: const EdgeInsets.fromLTRB(72, 48, 72, 48),
        // margin: EdgeInsets.fromLTRB(32, 0, 32, 64),
        child: Text(messages[buttonIndex]),
      ),
    );
  }

  Row _buildHeadRow() {
    var start = this.startTime;
    var styleKey = const TextStyle(fontSize: 22);
    var styleVal = const TextStyle(fontSize: 26);
    var startTime =
        "${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}";
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Spacer(),
        Column(
          children: [
            Text(
              "开始时间",
              style: styleKey,
            ),
            // const Spacer(),
            Text(
              startTime,
              style: styleVal,
            ),
          ],
        ),
        const Spacer(
          flex: 8,
        ),
        Column(
          children: [
            Text(
              "有效胎动",
              style: styleKey,
            ),
            Text(
              "$count",
              style: styleVal,
            ),
          ],
        ),
        const Spacer(),
      ],
    );
  }

  Row _buildCountdown() {
    var s = const TextStyle(fontSize: 60);
    var d = BoxDecoration(
        color: Colors.white70, borderRadius: BorderRadius.circular(20));
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: d,
          child: Text(
            jobShowMinute.toString().padLeft(2, "0"),
            style: s,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: d,
          child: Text(
            jobShowSecond.toString().padLeft(2, "0"),
            style: s,
          ),
        ),
      ],
    );
  }
}
