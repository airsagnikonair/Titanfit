import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:titanfit/CalculationLogic/GoogleFitDataFetch.dart';

class GraphDisplayWeekly extends StatelessWidget {
  const GraphDisplayWeekly({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<int, String> weekDayMap = {
      1: 'Mon',
      2: 'Tue',
      3: 'Wed',
      4: 'Thu',
      5: 'Fri',
      6: 'Sat',
      7: 'Sun',
    };
    final dataObject = Provider.of<GoogleFitDataFetch>(context, listen: false);
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.3,
          child: Padding(
            padding: EdgeInsets.all(30),
            child: BarChart(
              BarChartData(
                borderData: FlBorderData(
                  border: Border(
                    left: BorderSide(
                      color: Color(0x50FFFFFF),
                    ),
                    bottom: BorderSide(
                      color: Color(0x50FFFFFF),
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  verticalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Color(0x50FFFFFF),
                      strokeWidth: 1,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: Color(0x50FFFFFF),
                      strokeWidth: 1,
                    );
                  },
                ),
                alignment: BarChartAlignment.spaceBetween,
                groupsSpace: 12,
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: dataObject.bottomTitleWidgetsForWeek,
                      reservedSize: 42,
                    ),
                  ),
                ),
                barGroups: dataObject.plotArrayForWeek.map((plot) {
                  return BarChartGroupData(
                    barsSpace: 5,
                    x: (plot.weekday),
                    barRods: [
                      BarChartRodData(
                        borderRadius: BorderRadius.circular(1),
                        toY: plot.steps * 1.0,
                        color: Colors.greenAccent,
                        width: 10,
                        fromY: 0,
                      )
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            child: ListView.builder(
              itemCount: dataObject.plotArrayForWeek.length,
              itemBuilder: (ctx, i) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: ListTile(
                    leading: Image.asset(
                      'images/running.png',
                      height: 35,
                      width: 35,
                      color: Colors.white,
                    ),
                    title: Text(
                      dataObject.plotArrayForWeek[i].steps.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    subtitle: Text(
                      "Steps",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    trailing: Text(
                      weekDayMap[dataObject.plotArrayForWeek[i].weekday]!,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
