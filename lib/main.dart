import 'package:fetal_movement_counter/home_view.dart';
import 'package:fetal_movement_counter/info_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'counter.dart';
import 'test.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => InfoViewModel()),
        ChangeNotifierProvider(create: (_) => Counter()),
      ],
      child: MaterialApp(
        title: '数胎动',
        initialRoute: "/",
        routes: {
          "/": (context) => const MyHomePage(),
          // InitView.routeName: (context) => const InitView(),
          // HomeView.routeName: (context) => const HomeView(),
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
      ),
    );
  }
}