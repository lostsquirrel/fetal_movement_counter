import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'counter_view.dart';
import 'database_helper.dart';
import 'home_view.dart';
import 'info_helper.dart';
import 'init_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await InfoHelper().init();
  await DatabaseHelper().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '数胎动',
      initialRoute: CounterView.routeName,
      routes: {
        CounterView.routeName: (context) => const CounterView(),
        ExpectedDate.routeName: (context) => const ExpectedDate(),
        HomeView.routeName: (context) => const HomeView(),
      },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("en"),
        Locale("zh"),
      ],
    );
  }
}
