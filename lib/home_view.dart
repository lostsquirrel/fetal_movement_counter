import 'package:fetal_movement_counter/models/counter_model.dart';
import 'package:flutter/material.dart';

import 'common.dart';
import 'counter_service.dart';
import 'gestation_week_view.dart';
import 'info_service.dart';
import 'models/info_model.dart';

// the main view
class HomeView extends StatefulWidget {
  const HomeView({super.key});
  static const routeName = "/";

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<CounterDay> data = [];

  @override
  void initState() {
    super.initState();
    getCounterResults().then((value) {
      setState(() {
        data = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("数胎动")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: data.isNotEmpty ? _buildTable() : const Text("暂无数据"),
          ),
        ),
      ),
      bottomNavigationBar: buildNavBar(0, context),
    );
  }

  Table _buildTable() {
    return Table(
      children: [
        _buildHeader(),
        ...data.map((e) => _buildBodyRow(e)).toList(),
      ],
    );
  }

  TableRow _buildBodyRow(CounterDay d) {
    return TableRow(
      children: [
        _smallText(d.day.toString()),
        ...Iterable.generate(24).map<Widget>((e) {
          if (d.countInHour.containsKey(e)) {
            return _smallText(d.countInHour[e].toString().padLeft(2, " "));
          } else {
            return _smallText("");
          }
        }).toList(),
        _smallText(d.prediction.toString()),
      ],
    );
  }

  TableRow _buildHeader() {
    return TableRow(
      children: [
        _smallText("日期"),
        ...Iterable.generate(24)
            .map<Widget>((e) => _smallText(e % 2 == 0 ? e.toString() : ""))
            .toList(),
        _smallText("推算"),
      ],
    );
  }

  Text _smallText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 12),
    );
  }
}
