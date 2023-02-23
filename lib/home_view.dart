import 'package:fetal_movement_counter/init_view.dart';
import 'package:flutter/material.dart';

import 'common.dart';
import 'counter_service.dart';
import 'counter_view.dart';
import 'gestation_week_view.dart';
import 'info_service.dart';
import 'models/info_model.dart';

// the main view
class HomeView extends StatelessWidget {
  const HomeView({super.key});
  static const routeName = "/";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("数胎动")),
      body: Center(
        child: FutureBuilder(
            future: getInfoModel(),
            builder: (BuildContext context, AsyncSnapshot<InfoModel> snapshot) {
              List<Widget> children;
              if (snapshot.hasData) {
                InfoModel? data = snapshot.data;
                // Future.delayed(Duration.zero, () {
                //   // if (data == null || data.expectedDate == null) {
                //   //   Navigator.pushNamed(context, ExpectedDate.routeName);
                //   // } else {
                //     // start().then((_) {
                //     //   Navigator.pushNamed(context, CounterView.routeName);
                //     // });
                //   }
                // });
                children = <Widget>[
                  buildGestationWeek(data!.expectedDate),
                  // _buildButtonOrCounter(context),
                ];
              } else if (snapshot.hasError) {
                children = showError(snapshot.error);
              } else {
                children = shwoLoading;
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: children,
              );
            }),
      ),
    );
  }

  Future<bool> _hasCounterJob() async {
    var c = await getCounter();
    return c.hasJob;
  }

  Widget _buildButtonOrCounter(BuildContext context) {
    return FutureBuilder(
      future: _hasCounterJob(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        List<Widget> children = [];
        if (snapshot.hasData) {
          var hasJob = snapshot.data;
          if (hasJob == null || !hasJob) {
            return ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, CounterView.routeName);
              },
              child: const Text("开始数"),
            );
          } else {
            Future.delayed(Duration.zero, () {
              // print("push");
              Navigator.pushNamed(context, CounterView.routeName);
            });
          }
        } else if (snapshot.hasError) {
          children = showError(snapshot.error);
        } else {
          children = shwoLoading;
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children,
        );
      },
    );
  }
}
