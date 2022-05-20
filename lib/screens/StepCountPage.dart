// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:titanfit/widgets/WeekDays.dart';

import '../CalculationLogic/StepCalorieCalculation.dart';
import '../widgets/BottomNavigation.dart';
import '../widgets/NeuCoinCounter.dart';
import '../widgets/WalkParameter.dart';

class StepCountPage extends StatefulWidget {
  const StepCountPage({Key? key}) : super(key: key);

  @override
  State<StepCountPage> createState() => _StepCountPageState();
}

class _StepCountPageState extends State<StepCountPage> {
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<StepCalorieCalculation>(context, listen: false)
        .initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    double dynamicHeight = MediaQuery.of(context).size.height;
    double dynamicWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0x505b0098),
        body: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.purple, Color(0x505b0098)],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              stops: [0.1, 0.8],
              tileMode: TileMode.repeated,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Today",
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                  ),
                ],
              ),
              Container(
                height: dynamicHeight * 0.4,
                width: dynamicHeight * 0.4,
                margin: EdgeInsets.only(bottom: 15),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xFFF9CEEE), //Color(0xFFFF4949),
                  borderRadius: BorderRadius.circular(dynamicHeight * 0.4),
                ),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 30, top: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Consumer<StepCalorieCalculation>(
                        builder: (ctx, snapshot, child) {
                          String _status = snapshot.getStatus();
                          return Image.asset(
                            _status == "walking"
                                ? 'images/running.png'
                                : 'images/stop.png',
                            height: dynamicHeight * 0.2,
                            width: dynamicHeight * 0.2,
                          );
                        },
                      ),
                      Consumer<StepCalorieCalculation>(
                        builder: (ctx, snapshot, child) {
                          String _steps;

                          _steps = snapshot.getSteps();
                          if (_steps == '-1') {
                            _steps = "Loading Steps!";
                          }

                          return Text(
                            _steps,
                            style: TextStyle(
                                fontSize: 28,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold),
                          );
                        },
                      ),
                      Text(
                        "Steps",
                        style: TextStyle(fontSize: 18, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text("Calorie"),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Image.asset(
                              'images/calories.png',
                              height: 28,
                              width: 28,
                            ),
                            Consumer<StepCalorieCalculation>(
                              builder: (ctx, snapshot, child) {
                                double calorie = snapshot.getCalorie();
                                return Text(calorie.toStringAsFixed(1),
                                    style: TextStyle(
                                        textBaseline: TextBaseline.alphabetic,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold));
                              },
                            ),
                            Text(
                              "Kcal",
                              style: TextStyle(
                                  textBaseline: TextBaseline.alphabetic),
                            )
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text("Target"),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Image.asset(
                              'images/goal.png',
                              height: 28,
                              width: 28,
                            ),
                            Text(
                              "10 k",
                              style: TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text("Distance"),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Image.asset(
                              'images/distance.png',
                              height: 28,
                              width: 28,
                              color: Colors.white,
                            ),
                            Consumer<StepCalorieCalculation>(
                              builder: (ctx, snapshot, child) {
                                double dis =
                                    snapshot.getDistanceForCurrrntDay();
                                return Text(
                                  (dis / 1000.0).toStringAsFixed(1),
                                  style: TextStyle(
                                      textBaseline: TextBaseline.alphabetic,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold),
                                );
                              },
                            ),
                            Text(
                              "Km",
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Consumer<StepCalorieCalculation>(
                builder: (ctx, snapshot, child) {
                  double distanceLeft = snapshot.getDistanceForNeuCoin();
                  return NewCoinCounter(distanceLeft: distanceLeft);
                },
              ),
              WeekDays(),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigation(
          currIndex: 0,
        ),
      ),
    );
  }
}

// Expanded(
// flex: 1,
// child: Row(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// Consumer<StepCalorieCalculation>(
// builder: (ctx, snapshot, child) {
// double calorie = snapshot.getCalorie();
// return WalkParameter(
// parameterText: "Calories", parameterValue: calorie);
// },
// ),
// SizedBox(
// width: 10,
// ),
// WalkParameter(
// parameterText: "Target", parameterValue: 10000)
// ],
// ),
// ),
