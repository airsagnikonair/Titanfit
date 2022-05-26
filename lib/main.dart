// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:titanfit/screens/FitDisplayPage.dart';
import 'package:titanfit/screens/SplashScreen.dart';
import './CalculationLogic/StepCalorieCalculation.dart';
import 'package:titanfit/screens/StepCountPage.dart';
import 'package:titanfit/screens/NeuCoinsSummaryScreen.dart';
import 'package:provider/provider.dart';

import 'CalculationLogic/GoogleFitDataFetch.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    //initialise the function for tracking app life cycle
    WidgetsBinding.instance?.addObserver(this);

    //initialises the array that stores the pedometer sensor data
    StepCalorieCalculation.initialiseArray();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      //saves the state of the array in permanent memory
      await StepCalorieCalculation.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ListenableProvider(
          create: (ctx) => StepCalorieCalculation(),
        ),
        ListenableProvider(
          create: (ctx) => GoogleFitDataFetch(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Color(0x505b0098),
          textTheme: TextTheme(
            bodyText2: TextStyle(color: Colors.white, fontFamily: "Montserrat"),
          ),
        ),
        home: SplashScreen(),
        routes: {
          '/coinSummary': (context) => NeuCoinsSummaryScreen(),
          '/stepCount': (context) => StepCountPage(),
          '/fitData': (context) => HealthApp(),
        },
      ),
    );
  }
}
