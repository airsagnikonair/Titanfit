// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:titanfit/CalculationLogic/StepCalorieCalculation.dart';
import 'package:provider/provider.dart';

class WeeklyEarnedCoins extends StatelessWidget {
  String day = '';
  int weekday = 1;
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
  WeeklyEarnedCoins({required this.day, required this.weekday});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Color(0xFFF9F3EE)),
        alignment: Alignment.center,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 80),
                    child: Text(
                      weekDayaname[weekday],
                      style: TextStyle(fontSize: 35, color: Color(0xFF15133C)),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: Row(
                    children: [
                      Consumer<StepCalorieCalculation>(
                          builder: (ctx, snapshot, child) {
                        int coinsEarned =
                            (snapshot.getDistance(weekday) / 1000).truncate();
                        return Text(
                          '$coinsEarned',
                          style:
                              TextStyle(fontSize: 35, color: Color(0xFF15133C)),
                        );
                      }),
                      SizedBox(
                        width: 20,
                      ),
                      Icon(
                        Icons.paid,
                        color: Color(0xFFF9D923),
                        size: 40,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
