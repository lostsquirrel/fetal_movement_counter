import 'package:fetal_movement_counter/counter_view.dart';
import 'package:fetal_movement_counter/home_view.dart';
import 'package:fetal_movement_counter/init_view.dart';
import 'package:flutter/material.dart';

const minuteOfMilliseconds = 60 * 1000;

const shwoLoading = <Widget>[
  SizedBox(
    width: 60,
    height: 60,
    child: CircularProgressIndicator(),
  ),
  Padding(
    padding: EdgeInsets.only(top: 16),
    child: Text('Loading...'),
  ),
];

List<Widget> showError(Object? err) {
  return <Widget>[
    const Icon(
      Icons.error_outline,
      color: Colors.red,
      size: 60,
    ),
    Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Text('Error: $err'),
    ),
  ];
}

const routers = [
  HomeView.routeName,
  CounterView.routeName,
  ExpectedDate.routeName,
];
BottomNavigationBar buildNavBar(int selectedIndex, BuildContext context) {
  return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: '胎动数',
          backgroundColor: Color.fromARGB(255, 91, 149, 236),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.sports_martial_arts),
          label: '数胎动',
          backgroundColor: Colors.green,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: '设置',
          backgroundColor: Colors.pink,
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: const Color.fromARGB(255, 210, 210, 102),
      onTap: (int index) {
        if (index != selectedIndex) {
          Navigator.pushReplacementNamed(context, routers[index]);
        }
      });
}
