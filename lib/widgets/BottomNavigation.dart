// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class BottomNavigation extends StatelessWidget {
  int currIndex = 0;
  BottomNavigation({required this.currIndex});

  void changePage(int i, BuildContext ctx) {
    if (i == 0) {
      currIndex = i;
      Navigator.of(ctx).pushReplacementNamed('/stepCount');
    }
    if (i == 1) {
      currIndex = i;
      Navigator.of(ctx).pushReplacementNamed('/coinSummary');
    }
    if (i == 2) {
      currIndex = i;
      Navigator.of(ctx).pushReplacementNamed('/fitData');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
        index: currIndex,
        height: 60.0,
        items: <Widget>[
          Image.asset(
            'images/pedometer.png',
            height: 30,
            width: 30,
          ),
          Image.asset(
            'images/coinstar.png',
            height: 30,
            width: 30,
          ),
          Image.asset(
            'images/account.png',
            height: 30,
            width: 30,
          ),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        onTap: (index) {
          changePage(index, context);
        },
        letIndexChange: (index) => true);
  }
}
