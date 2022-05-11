// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class WalkParameter extends StatelessWidget {
  String parameterText = "";
  int parameterValue = 0;

  WalkParameter({required this.parameterText, required this.parameterValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color(0xFFF9F3EE),
      ),
      height: 100,
      width: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            parameterText,
            style: TextStyle(fontSize: 25),
          ),
          Text(
            parameterValue.toString(),
            style: TextStyle(fontSize: 22),
          ),
        ],
      ),
    );
  }
}
