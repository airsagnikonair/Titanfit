import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:titanfit/DataStorage/DataPointsBarGraph.dart';
import 'package:titanfit/DataStorage/DataPointsForWeekDays.dart';

class GoogleFitDataFetch extends ChangeNotifier {
  List<HealthDataPoint> _healthDataList = [];
  List<HealthDataPoint> _healthDataList2 = [];
  List<DataPointsForBarGraph> plotArray = [];
  List<DataPointsForWeekDays> plotArrayForWeek = [];
  late HealthFactory health;

  Future<void> initialiseHourlyWeeklyDataArray() async {
    health = HealthFactory();
    _healthDataList.clear();
    _healthDataList2.clear();
    plotArray.clear();
    plotArrayForWeek.clear();

    final types = [
      HealthDataType.STEPS,
      HealthDataType.WEIGHT,
      HealthDataType.HEIGHT,
      HealthDataType.BLOOD_GLUCOSE,
      // Uncomment this line on iOS - only available on iOS
      // HealthDataType.DISTANCE_WALKING_RUNNING,
    ];

    final permissions = [
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
    ];

    DateTime now = DateTime.now();
    DateTime yesterday = DateTime(now.year, now.month, now.day, 0, 0, 0, 0, 0);

    bool requested =
        await health.requestAuthorization(types, permissions: permissions);

    if (requested) {
      try {
        // fetch health data
        List<HealthDataPoint> healthData =
            await health.getHealthDataFromTypes(yesterday, now, types);
        print("inside requested making healthData array");
        // save all the new data points (only the first 100)
        _healthDataList.addAll(healthData);
      } catch (error) {
        print("Exception in getHealthDataFromTypes: $error");
      }

      // filter out duplicates
      _healthDataList = HealthFactory.removeDuplicates(_healthDataList);
    }

    print('length of array made (_healthdatalist)${_healthDataList.length}');
    for (int i = 0; i <= 24; i++) {
      plotArray.add(new DataPointsForBarGraph(x_time: i * 1.0, y_steps: 0));
    }

    for (int i = 0; i < _healthDataList.length; i++) {
      HealthDataPoint healthData = _healthDataList[i];

      print(healthData.value);
      int hr = healthData.dateFrom.hour;
      int minute = healthData.dateFrom.minute;
      double fraction = (minute / 60.0) + hr;
      fraction = double.parse(fraction.toStringAsFixed(2));
      int steps = healthData.value.toInt();
      print("making array inside map ${fraction}");
      plotArray[fraction.truncate()].x_time = fraction.truncate() * 1.0;
      plotArray[fraction.truncate()].y_steps =
          plotArray[fraction.truncate()].y_steps + steps;
    }

    print("The length of the array we made ${plotArray.length}");

    final lastWeekDay = now.subtract(Duration(days: now.weekday - 1));
    requested =
        await health.requestAuthorization(types, permissions: permissions);

    if (requested) {
      try {
        // fetch health data
        List<HealthDataPoint> healthData =
            await health.getHealthDataFromTypes(lastWeekDay, now, types);
        print("inside requested making healthData array");
        // save all the new data points (only the first 100)
        _healthDataList2.addAll(healthData);
      } catch (error) {
        print("Exception in getHealthDataFromTypes: $error");
      }

      // filter out duplicates
      _healthDataList2 = HealthFactory.removeDuplicates(_healthDataList2);
    }

    print('length of array made (_healthdatalist)${_healthDataList2.length}');
    for (int i = 1; i <= 7; i++) {
      plotArrayForWeek.add(
        new DataPointsForWeekDays(weekday: i, steps: 0),
      );
    }

    for (int i = 0; i < _healthDataList2.length; i++) {
      HealthDataPoint healthData = _healthDataList2[i];

      print(healthData.value);
      int weekDay = healthData.dateFrom.weekday;
      plotArrayForWeek[weekDay - 1].weekday = weekDay;
      plotArrayForWeek[weekDay - 1].steps =
          plotArrayForWeek[weekDay - 1].steps + healthData.value.toInt();
    }
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff68737d),
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    if (value == 0.0) {
      text = Text(
        '12\nam',
        style: style,
        textAlign: TextAlign.center,
      );
    } else if (value == 4.0) {
      text = Text(
        '4\nam',
        style: style,
        textAlign: TextAlign.center,
      );
    } else if (value == 8.0) {
      text = Text(
        '8\nam',
        style: style,
        textAlign: TextAlign.center,
      );
    } else if (value == 12.0) {
      text = Text(
        '12\npm',
        style: style,
        textAlign: TextAlign.center,
      );
    } else if (value == 16.0) {
      text = Text(
        '4\npm',
        style: style,
        textAlign: TextAlign.center,
      );
    } else if (value == 20.0) {
      text = Text(
        '8\npm',
        style: style,
        textAlign: TextAlign.center,
      );
    } else if (value == 24.0) {
      text = Text(
        '12\npm',
        style: style,
        textAlign: TextAlign.center,
      );
    } else {
      text = Text(
        '',
        style: style,
        textAlign: TextAlign.center,
      );
    }

    return Column(
      children: [
        Container(
          color: Colors.black,
          height: 7,
          width: 2,
        ),
        Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(bottom: 2),
            child: text),
      ],
    );
  }

  Widget bottomTitleWidgetsForWeek(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff68737d),
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    if (value.toInt() == 1) {
      text = Text(
        'Mon',
        style: style,
        textAlign: TextAlign.center,
      );
    } else if (value.toInt() == 2) {
      text = Text(
        'Tue',
        style: style,
        textAlign: TextAlign.center,
      );
    } else if (value == 3.0) {
      text = Text(
        'Wed',
        style: style,
        textAlign: TextAlign.center,
      );
    } else if (value == 4.0) {
      text = Text(
        'Thu',
        style: style,
        textAlign: TextAlign.center,
      );
    } else if (value == 5.0) {
      text = Text(
        'Fri',
        style: style,
        textAlign: TextAlign.center,
      );
    } else if (value == 6.0) {
      text = Text(
        'Sat',
        style: style,
        textAlign: TextAlign.center,
      );
    } else if (value == 7.0) {
      text = Text(
        'Sun',
        style: style,
        textAlign: TextAlign.center,
      );
    } else {
      text = Text(
        '',
        style: style,
        textAlign: TextAlign.center,
      );
      return text;
    }
    return Column(
      children: [
        SizedBox(
          height: 5,
        ),
        Container(
          color: Color(0x50FFFFFF),
          height: 7,
          width: 2,
        ),
        Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(bottom: 2),
            child: text),
      ],
    );
  }
}
