import 'package:flutter/material.dart';
import 'WeekDaysSmallDisplay.dart';

class WeekDays extends StatelessWidget {
  const WeekDays({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        WeekDaysSmallDisplay(disp: "1"),
        WeekDaysSmallDisplay(disp: "2"),
        WeekDaysSmallDisplay(disp: "3"),
        WeekDaysSmallDisplay(disp: "4"),
        WeekDaysSmallDisplay(disp: "5"),
        WeekDaysSmallDisplay(disp: "6"),
        WeekDaysSmallDisplay(disp: "7")
      ],
    );
  }
}
