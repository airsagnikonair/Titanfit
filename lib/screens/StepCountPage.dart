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
                      style: TextStyle(fontSize: 25, color: Colors.white),
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
                margin: EdgeInsets.only(bottom: 15),
                alignment: Alignment.center,
                height: 320,
                width: 320,
                decoration: BoxDecoration(
                  color: Color(0xFFF9CEEE), //Color(0xFFFF4949),
                  borderRadius: BorderRadius.circular(320),
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
                        style: TextStyle(fontSize: 25, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  WalkParameter(parameterText: "Calories", parameterValue: 300),
                  SizedBox(
                    width: 10,
                  ),
                  WalkParameter(parameterText: "Target", parameterValue: 10000)
                ],
              ),
              NewCoinCounter(),
              WeekDays(),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigation(),
      ),
    );
  }
}
