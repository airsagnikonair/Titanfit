import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:titanfit/CalculationLogic/GoogleFitDataFetch.dart';

class GraphDisplayHourly extends StatelessWidget {
  const GraphDisplayHourly({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dataObject = Provider.of<GoogleFitDataFetch>(context, listen: false);

    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.3,
          child: Padding(
            padding: EdgeInsets.all(30),
            child: BarChart(
              BarChartData(
                minY: 0,
                alignment: BarChartAlignment.spaceBetween,
                groupsSpace: 12,
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
                  drawHorizontalLine: true,
                  verticalInterval: 4,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: const Color(0x50FFFFFF),
                      strokeWidth: 1,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: const Color(0x50FFFFFF),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      interval: 4,
                      getTitlesWidget: dataObject.bottomTitleWidgets,
                    ),
                  ),
                ),
                barGroups: dataObject.plotArray.map((plot) {
                  return BarChartGroupData(
                    barsSpace: 5,
                    x: (plot.x_time.toInt()),
                    barRods: [
                      BarChartRodData(
                        borderRadius: BorderRadius.circular(1),
                        toY: plot.y_steps * 1.0,
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
              itemCount: dataObject.plotArray.length,
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
                      dataObject.plotArray[i].y_steps.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    subtitle: Text(
                      "Steps",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    trailing: Text(
                      '${dataObject.plotArray[i].x_time.truncate().toString()}:00',
                      style: TextStyle(color: Colors.white, fontSize: 20),
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
