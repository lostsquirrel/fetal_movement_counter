import 'package:flutter/material.dart';

import 'common.dart';
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
      bottomNavigationBar: buildNavBar(0, context),
    );
  }
}
