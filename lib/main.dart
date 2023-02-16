import 'package:fetal_movement_counter/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'database_helper.dart';
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
      initialRoute: "/init",
      routes: {
        // "/": (context) => const MyHomePage(),
        InitView.routeName: (context) => const InitView(),
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
