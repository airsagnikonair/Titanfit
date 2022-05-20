// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:titanfit/CalculationLogic/StepCalorieCalculation.dart';
import 'package:provider/provider.dart';
import 'package:titanfit/DataStorage/PedometerCount.dart';

class WeeklyEarnedCoins extends StatelessWidget {
  int weekDay = 1;
  List<String> weekDayaname = [
    'Suncopy',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];
  WeeklyEarnedCoins({required this.weekDay});
  @override
  Widget build(BuildContext context) {
    PedometerCount pedometerCount =
        Provider.of<StepCalorieCalculation>(context, listen: false)
            .getWeekDayDetails(weekDay);
    DateTime date = pedometerCount.date;
    DateFormat formatter = DateFormat.MMMEd('en_US');
    String formattedDate = formatter.format(date);
    print(weekDay);
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
      child: pedometerCount.currSteps < 0
          ? Container(
              // padding: EdgeInsets.all(10),
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(10),
              //   color: Color(0xFFF9F3EE),
              // ),
              // alignment: Alignment.center,
              // width: double.infinity,
              // child: Text(
              //   "No data found",
              //   style: TextStyle(
              //       color: Colors.black87, fontWeight: FontWeight.bold),
              // ),
              )
          : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFFF9F3EE),
              ),
              alignment: Alignment.center,
              width: double.infinity,
              child: Column(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Text(
                              formattedDate,
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF15133C),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 10),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        'images/steps.png',
                                        height: 25,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'Steps',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Color(0xFF15133C),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    pedometerCount.currSteps <= 0
                                        ? '0'
                                        : pedometerCount.currSteps
                                            .truncate()
                                            .toString(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Color(0xFF15133C),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        'images/distance.png',
                                        height: 25,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'Distance',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Color(0xFF15133C),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    (pedometerCount.distance / 1000.0)
                                            .toStringAsFixed(1) +
                                        " km",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Color(0xFF15133C),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        'images/calories.png',
                                        height: 25,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'Calories',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Color(0xFF15133C),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    pedometerCount.calorie.toStringAsFixed(1) +
                                        " kcal",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Color(0xFF15133C),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        'images/coinstar.png',
                                        height: 25,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'Coins',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Color(0xFF15133C),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    (pedometerCount.distance / 1000.0)
                                        .truncate()
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Color(0xFF15133C),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
