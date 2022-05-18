// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'WeekDaysSmallDisplay.dart';

class WeekDays extends StatelessWidget {
  const WeekDays({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          WeekDaysSmallDisplay(
            disp: "M",
            weekDay: 1,
          ),
          WeekDaysSmallDisplay(
            disp: "Tu",
            weekDay: 2,
          ),
          WeekDaysSmallDisplay(
            disp: "W",
            weekDay: 3,
          ),
          WeekDaysSmallDisplay(
            disp: "Th",
            weekDay: 4,
          ),
          WeekDaysSmallDisplay(
            disp: "F",
            weekDay: 5,
          ),
          WeekDaysSmallDisplay(
            disp: "S",
            weekDay: 6,
          ),
          WeekDaysSmallDisplay(
            disp: "Su",
            weekDay: 7,
          )
        ],
      ),
    );
  }
}
