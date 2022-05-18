// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../CalculationLogic/StepCalorieCalculation.dart';

class WeekDaysSmallDisplay extends StatelessWidget {
  String disp = "";
  int weekDay = 1;
  WeekDaysSmallDisplay({required this.disp, required this.weekDay});

  @override
  Widget build(BuildContext context) {
    return Consumer<StepCalorieCalculation>(builder: (ctx, snapshot, child) {
      int steps = snapshot.getStepsForRoundedBox(weekDay);
      double gradientValue;
      if (steps == 0 || steps == -1) {
        gradientValue = 0.0;
      }
      gradientValue = steps / 10000.0;
      if (gradientValue > 1) {
        gradientValue = 1;
      }

      return Container(
        alignment: Alignment.center,
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFCDBE78), Color(0xFFF9CEEE)],
            begin: Alignment(-1, 1),
            end: Alignment(-1, -1),
            stops: [gradientValue, gradientValue],
            tileMode: TileMode.repeated,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(
          disp,
          style: TextStyle(color: Color(0xFF5b0098), fontSize: 20),
        ),
      );
    });
  }
}

// Stack(
// alignment: Alignment.center,
// children: [
// Consumer<StepCalorieCalculation>(builder: (ctx, snapshot, child) {
// int val = snapshot.getStepsForRoundedBox(weekDay);
// if (val == 0 || val == -1) {
// return Container();
// }
//
// return FractionallySizedBox(
// widthFactor: 1,
// heightFactor: val / 10000.0 > 1 ? 1 : (val / 10000.0),
// alignment: FractionalOffset.center,
// child: DecoratedBox(
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(50),
// color: Colors.redAccent),
// ),
// );
// }),
// Text(
// disp,
// style: TextStyle(color: Color(0xFF5b0098), fontSize: 20),
// ),
// ],
// ),
