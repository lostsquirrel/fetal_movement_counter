import 'dart:async';

import 'package:flutter/material.dart';

import 'counter_service.dart';
import 'models/counter_model.dart';

class CounterView extends StatefulWidget {
  const CounterView({super.key});
  static const routeName = "/counter";
  @override
  State<CounterView> createState() => _CounterViewState();
}

class _CounterViewState extends State<CounterView> {
  CounterModel counterModel = CounterModel([]);

  late int jobInSeconds = 0;

  int get jobShowMinute {
    return jobInSeconds ~/ 60;
  }

  int get jobShowSecond {
    return jobInSeconds % 60;
  }

  late Timer countDown;

  @override
  void initState() {
    super.initState();
    countDown = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        if (jobInSeconds <= 0) {
          countDown.cancel();
        }
        jobInSeconds -= 1;
      });
    });
    getCounter().then((value) {
      setState(() {
        counterModel = value;
        jobInSeconds = value.startTime
            .add(const Duration(hours: 1))
            .difference(DateTime.now())
            .inSeconds;
        countDown;
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
          Text("点击次数: ${counterModel.total}"),
          Expanded(
            child: Container(
              child: _buildButtons(),
            ),
          ),
        ],
      ),
    );
  }

  Row _buildButtons() {
    var btStart = ElevatedButton(
      child: const Text("开始数"),
      onPressed: () {
        start().then((_) {
          getCounter().then((value) {
            setState(() {
              counterModel = value;
            });
          });
        });
      },
    );
    var btCount = ElevatedButton(
        onPressed: () {
          count().then((_) {
            getCounter().then((value) {
              setState(() {
                counterModel = value;
              });
            });
          });
        },
        child: const Text("动了"));
    return Row(
      children: [
        if (counterModel.hasJob) btCount else btStart,
      ],
    );
  }

  Row _buildHeadRow() {
    var start = counterModel.startTime;
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
              "${counterModel.count}",
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
