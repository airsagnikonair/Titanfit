// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:titanfit/widgets/NueCoinTotalTodayCount.dart';

import '../widgets/BottomNavigation.dart';
import '../widgets/WeeklyEarnedCoins.dart';

class NeuCoinsSummaryScreen extends StatelessWidget {
  const NeuCoinsSummaryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    int weekDay = date.weekday;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(
            '7 Days History',
            style: TextStyle(fontSize: 42),
          ),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 6,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      WeeklyEarnedCoins(day: 'Fri', weekday: weekDay),
                      WeeklyEarnedCoins(
                          day: 'Thu',
                          weekday: weekDay - 1 <= 0
                              ? 7 + (weekDay - 1)
                              : weekDay - 1),
                      WeeklyEarnedCoins(
                          day: 'Wed',
                          weekday: weekDay - 2 <= 0
                              ? 7 + (weekDay - 2)
                              : weekDay - 2),
                      WeeklyEarnedCoins(
                          day: 'Tue',
                          weekday: weekDay - 3 <= 0
                              ? 7 + (weekDay - 3)
                              : weekDay - 3),
                      WeeklyEarnedCoins(
                          day: 'Mon',
                          weekday: weekDay - 4 <= 0
                              ? 7 + (weekDay - 4)
                              : weekDay - 4),
                      WeeklyEarnedCoins(
                          day: 'Sun',
                          weekday: weekDay - 5 <= 0
                              ? 7 + (weekDay - 5)
                              : weekDay - 5),
                      WeeklyEarnedCoins(
                          day: 'Sat',
                          weekday: weekDay - 6 <= 0
                              ? 7 + (weekDay - 6)
                              : weekDay - 6),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      NeuCoinTotalTodayCount(headingText: 'Total', value: 47),
                      NeuCoinTotalTodayCount(headingText: 'Today', value: 3),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigation(
          currIndex: 1,
        ),
      ),
    );
  }
}
