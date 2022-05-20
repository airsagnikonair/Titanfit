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
      if (weekDay > DateTime.now().weekday) {
        gradientValue = 0.0;
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
          border: DateTime.now().weekday == weekDay
              ? Border.all(color: Colors.black87, width: 2.5)
              : null,
        ),
        child: Text(
          disp,
          style: TextStyle(color: Color(0xFF5b0098), fontSize: 20),
        ),
      );
    });
  }
}
