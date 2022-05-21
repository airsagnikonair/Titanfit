// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../CalculationLogic/StepCalorieCalculation.dart';

class WalkParameter extends StatelessWidget {
  String parameterText = "";

  Widget displayUnit;
  String unit;
  String imagePath;

  WalkParameter(
      {required this.parameterText,
      required this.imagePath,
      required this.displayUnit,
      required this.unit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(parameterText),
        SizedBox(
          height: 10,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Image.asset(
              imagePath,
              height: 28,
              width: 28,
            ),
            displayUnit,
            Text(
              unit,
              style: TextStyle(textBaseline: TextBaseline.alphabetic),
            )
          ],
        ),
      ],
    );
  }
}
