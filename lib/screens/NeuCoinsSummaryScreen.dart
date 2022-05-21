// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../CalculationLogic/StepCalorieCalculation.dart';
import '../widgets/BottomNavigation.dart';
import '../widgets/WeeklyEarnedCoins.dart';

class NeuCoinsSummaryScreen extends StatelessWidget {
  const NeuCoinsSummaryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //getting the current weekday value (monday=1...sunday=7)
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    int weekDay = date.weekday;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            'History',
            style: TextStyle(fontSize: 20),
          ),
          actions: [
            Row(
              children: [
                Text("Total"),
                SizedBox(
                  width: 5,
                ),
                Consumer<StepCalorieCalculation>(
                    builder: (ctx, snapshot, child) {
                  return Text(
                    snapshot.getTotalCoins().toString(),
                    style: TextStyle(fontSize: 20),
                  );
                }),
                SizedBox(
                  width: 5,
                ),
                Image.asset(
                  'images/coinstar.png',
                  height: 20,
                  width: 20,
                ),
                SizedBox(
                  width: 5,
                ),
                Text("Weekly"),
                SizedBox(
                  width: 5,
                ),
                Consumer<StepCalorieCalculation>(
                    builder: (ctx, snapshot, child) {
                  int totalCoinsThisWeek = snapshot.getNeuCoinsEarnedInAWeek();
                  return Text(
                    totalCoinsThisWeek.toString(),
                    style: TextStyle(fontSize: 20),
                  );
                }),
                SizedBox(
                  width: 5,
                ),
                Image.asset(
                  'images/coinstar.png',
                  height: 20,
                  width: 20,
                ),
              ],
            )
          ],
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 6,
                child: Container(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //logic for rotating the index of pedoTrackArray
                        WeeklyEarnedCoins(weekDay: weekDay),
                        WeeklyEarnedCoins(
                            weekDay: weekDay - 1 <= 0
                                ? 7 + (weekDay - 1)
                                : weekDay - 1),
                        WeeklyEarnedCoins(
                            weekDay: weekDay - 2 <= 0
                                ? 7 + (weekDay - 2)
                                : weekDay - 2),
                        WeeklyEarnedCoins(
                            weekDay: weekDay - 3 <= 0
                                ? 7 + (weekDay - 3)
                                : weekDay - 3),
                        WeeklyEarnedCoins(
                            weekDay: weekDay - 4 <= 0
                                ? 7 + (weekDay - 4)
                                : weekDay - 4),
                        WeeklyEarnedCoins(
                            weekDay: weekDay - 5 <= 0
                                ? 7 + (weekDay - 5)
                                : weekDay - 5),
                        WeeklyEarnedCoins(
                            weekDay: weekDay - 6 <= 0
                                ? 7 + (weekDay - 6)
                                : weekDay - 6),
                      ],
                    ),
                  ),
                ),
              ),
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
