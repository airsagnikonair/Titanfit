// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:ui';

import 'package:flutter/material.dart';

class NewCoinCounter extends StatelessWidget {
  double distanceLeft;
  NewCoinCounter({required this.distanceLeft});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 30, right: 30, top: 5),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color(0xFFF9F3EE),
        ),
        height: MediaQuery.of(context).size.height * 0.1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                Text(
                  "1",
                  style: TextStyle(
                      fontSize: 40,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold),
                ),
                Image.asset(
                  'images/coinstar.png',
                  height: 50,
                  width: 50,
                ),
              ],
            ),
            Row(
              textBaseline: TextBaseline.alphabetic,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                Text(
                  distanceLeft == -1.0
                      ? "Loading..."
                      : "${(distanceLeft * 1000).round()}",
                  style: TextStyle(
                      textBaseline: TextBaseline.alphabetic,
                      fontSize: 30,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "meters left",
                  style: TextStyle(
                      color: Colors.black,
                      textBaseline: TextBaseline.alphabetic),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
