import 'package:flutter/material.dart';

// set the expected date of childbirth as first
class InitView extends StatelessWidget {
  const InitView({super.key});
  static const routeName = "/";
  @override
  Widget build(BuildContext context) {
    if (_hasExpectedDate()) {
      Navigator.pop(context);
    }
    return Scaffold(
      appBar: AppBar(title: const Text("预产期设置")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              iconSize: 120,
              icon: const Icon(
                Icons.date_range,
                color: Colors.blue,
              ),
              onPressed: () => _showDate(context),
            ),
            const Text("点击图标设置预产期"),
          ],
        ),
      ),
    );
  }

  bool _hasExpectedDate() {
    return false;
  }

  Future<void> _showDate(BuildContext context) async {
    var current = DateTime.now();
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: current,
        firstDate: current,
        lastDate: current.add(const Duration(days: 7 * 80)));
    if (picked != null && picked != current) {
      print(picked);
    }
  }
}
