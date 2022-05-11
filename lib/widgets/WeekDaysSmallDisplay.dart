import 'dart:ui';

import 'package:flutter/material.dart';

class WeekDaysSmallDisplay extends StatelessWidget {
  String disp = "";
  WeekDaysSmallDisplay({required this.disp});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 50,
      width: 50,
      child: Text(
        disp,
        style: TextStyle(color: Color(0xFFEEB0B0), fontSize: 20),
      ),
    );
  }
}
