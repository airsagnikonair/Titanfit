import 'dart:async';
import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:titanfit/widgets/BottomNavigation.dart';

import '../CalculationLogic/GoogleFitDataFetch.dart';
import '../DataStorage/DataPointsBarGraph.dart';
import '../DataStorage/DataPointsForWeekDays.dart';
import '../widgets/GraphDisplayHourly.dart';
import '../widgets/GraphDisplayWeekly.dart';

class HealthApp extends StatefulWidget {
  @override
  _HealthAppState createState() => _HealthAppState();
}

class _HealthAppState extends State<HealthApp> {
  bool loading = false;
  late GoogleFitDataFetch dataObject;
  didChangeDependencies() {
    super.didChangeDependencies();
    loading = true;
    dataObject = Provider.of<GoogleFitDataFetch>(context, listen: false);
    Provider.of<GoogleFitDataFetch>(context, listen: false)
        .initialiseHourlyWeeklyDataArray()
        .then((value) {
      setState(() {
        loading = false;
      });
    });
  }

  Widget _contentFetchingData() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(
            strokeWidth: 10,
          ),
        ),
        Text('Fetching data...')
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        bottomNavigationBar: BottomNavigation(currIndex: 2),
        appBar: AppBar(
          // leading: Image.asset(
          //   'images/google.png',
          //   height: 10,
          //   width: 10,
          // ),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/google.png',
                height: 30,
                width: 30,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Fit',
                style: TextStyle(fontSize: 25),
              ),
            ],
          ),
          bottom: loading == false
              ? TabBar(
                  tabs: <Widget>[
                    Tab(
                      child: Text(
                        "Hourly",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Weekly",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                )
              : null,
        ),
        body: loading == false
            ? TabBarView(
                children: [
                  GraphDisplayHourly(),
                  GraphDisplayWeekly(),
                ],
              )
            : Center(
                child: _contentFetchingData(),
              ),
      ),
    );
  }
}

// BarChart(
// BarChartData(
// alignment: BarChartAlignment.spaceAround,
// groupsSpace: 12,
// barTouchData: BarTouchData(enabled: true),
// titlesData: FlTitlesData(
// show: true,
// rightTitles: AxisTitles(
// sideTitles: SideTitles(showTitles: false),
// ),
// topTitles: AxisTitles(
// sideTitles: SideTitles(showTitles: false),
// ),
// bottomTitles: AxisTitles(
// sideTitles: SideTitles(
// showTitles: true,
// getTitlesWidget: bottomTitles,
// reservedSize: 42,
// ),
// ),
// ),
// barGroups: plotArray.map((plot) {
// return BarChartGroupData(
// barsSpace: 20,
// x: (plot.x_time).toInt(),
// barRods: [
// BarChartRodData(
// toY: plot.y_steps * 1.0,
// color: Colors.red,
// width: 10,
// fromY: 0,
// )
// ],
// );
// }).toList(),
// ),
// ),

// LineChart(
// LineChartData(
// minX: 0.0,
// maxX: 7.0,
// minY: 0,
// borderData: FlBorderData(
// border: Border(
// left: BorderSide(color: Color(0x50FFFFFF)),
// bottom: BorderSide(
// color: Color(0x50FFFFFF),
// ),
// ),
// ),
// gridData: FlGridData(
// show: true,
// drawVerticalLine: true,
// verticalInterval: 1,
// getDrawingHorizontalLine: (value) {
// return FlLine(
// color: Color(0x50FFFFFF),
// strokeWidth: 1,
// );
// },
// getDrawingVerticalLine: (value) {
// return FlLine(
// color: Color(0x50FFFFFF),
// strokeWidth: 1,
// );
// },
// ),
// titlesData: FlTitlesData(
// rightTitles: AxisTitles(
// sideTitles: SideTitles(showTitles: false),
// ),
// topTitles: AxisTitles(
// sideTitles: SideTitles(showTitles: false),
// ),
// bottomTitles: AxisTitles(
// sideTitles: SideTitles(
// showTitles: true,
// reservedSize: 50,
// interval: 1,
// getTitlesWidget: bottomTitleWidgetsForWeek,
// ),
// ),
// ),
// lineBarsData: [
// LineChartBarData(
// isStrokeCapRound: true,
// spots: plotableDataWeekArray.map((e) {
// return FlSpot(e.weekday * 1.0, e.steps * 1.0);
// }).toList(),
// ),
// ],
// ),
// ),
