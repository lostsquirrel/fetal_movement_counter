import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'info_service.dart';
import 'info_view_model.dart';
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
    var infoVM = context.read<InfoViewModel>();
    var info = infoVM.getInfo();

    
      if (info.expectedDate != null) {
        expectedDate = info.expectedDate.toString();
      }
      if (!info.hasExpectedDate()) {
        _showDate(context);
      }
      return Scaffold(
        appBar: AppBar(title: const Text("数胎动")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(expectedDate),
              Text("123"),
            ],
          ),
        ),
      );
    }
    return const CircularProgressIndicator();
  }

  Future<void> _showDate(BuildContext context) async {
    var current = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: current,
      lastDate: current.add(const Duration(days: 7 * 80)),
      helpText: "设置预产期",
    );

    if (picked != null && picked != current) {
      infoService
          .addExpectedDate(picked)
          .then((value) => Navigator.pushNamed(context, HomeView.routeName));
    }
  }
}
