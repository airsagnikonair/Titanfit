import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showUnselectedLabels: false,
      showSelectedLabels: false,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "home"),
        BottomNavigationBarItem(icon: Icon(Icons.paid), label: "Neu-coins"),
        BottomNavigationBarItem(icon: Icon(Icons.school), label: "Profile"),
      ],
      selectedItemColor: Colors.amber[800],
      //onTap: _onItemTapped,
    );
  }
}
