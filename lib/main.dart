// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:titanfit/screens/StepCountPage.dart';
import 'package:titanfit/screens/NeuCoinsSummaryScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0x505b0098),
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.white),
        ),
      ),
      home: StepCountPage(),
      routes: {
        '/coinSummary': (context) => NeuCoinsSummaryScreen(),
      },
    );
  }
}
