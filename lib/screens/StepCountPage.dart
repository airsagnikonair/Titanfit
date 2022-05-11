// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:titanfit/widgets/WeekDays.dart';

import '../widgets/BottomNavigation.dart';
import '../widgets/WalkParameter.dart';
import '../widgets/WeekDaysSmallDisplay.dart';
import '../widgets/NeuCoinCounter.dart';

import 'package:flutter/material.dart';

class StepCountPage extends StatelessWidget {
  const StepCountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Color(0x505b0098),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Icon(
                        Icons.arrow_left,
                        size: 50,
                      ),
                    ),
                    Container(
                      child: Text(
                        "Today",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Icon(
                        Icons.arrow_right,
                        size: 50,
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.center,
                  height: 350,
                  width: 350,
                  decoration: BoxDecoration(
                    color: Color(0xFFFF4949),
                    borderRadius: BorderRadius.circular(350),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 30, top: 80),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.do_not_step,
                          size: 150,
                        ),
                        Text(
                          "5000 steps",
                          style: TextStyle(fontSize: 25),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    WalkParameter(
                        parameterText: "Calories", parameterValue: 300),
                    WalkParameter(
                        parameterText: "Target", parameterValue: 10000)
                  ],
                ),
                NewCoinCounter(),
                WeekDays(),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigation()),
    );
  }
}
