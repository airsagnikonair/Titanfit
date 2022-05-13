// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class NewCoinCounter extends StatelessWidget {
  const NewCoinCounter({Key? key}) : super(key: key);

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
        height: 75,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "1 new-coin",
              style: TextStyle(fontSize: 25, color: Colors.black87),
            ),
            Text(
              "500 mts left",
              style: TextStyle(fontSize: 25, color: Colors.black87),
            )
          ],
        ),
      ),
    );
  }
}
