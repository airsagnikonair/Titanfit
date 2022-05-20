import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../DataStorage/PedometerCount.dart';

class StepCalorieCalculation extends ChangeNotifier {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?', _steps = '?';
  double calorie = 0;
  double distanceCovered = 0;
  double distanceLeft = -1;
  double shortDistanceTarget = -1;
  bool neuCoinFlag = false;

  late int weekDayIndex;

  static bool loadingData = false;

  static List<PedometerCount> pedoTrackArray = [];
  static Future<void> initialiseArray() async {
    loadingData = true;
    final prefs = await SharedPreferences.getInstance();
    final List<String>? items = prefs.getStringList('pedoData');

    if (items != null) {
      pedoTrackArray = items.map((ele) {
        print("retrived data");
        double totalSteps = jsonDecode(ele)['totalSteps'];
        double currSteps = jsonDecode(ele)['currSteps'];
        double calorie = jsonDecode(ele)['calorie'];
        DateTime date = DateTime.parse(jsonDecode(ele)['date']);
        double neucoin = jsonDecode(ele)['neucoin'];
        double distance = jsonDecode(ele)['distance'];
        print("retrived data");
        return PedometerCount(
          neucoin: neucoin,
          distance: distance,
          calorie: calorie,
          currSteps: currSteps,
          totalSteps: totalSteps,
          date: date,
        );
      }).toList();

      loadingData = false;
      print("retrived array");
      for (int i = 0; i < 8; i++) {
        print(
            '${pedoTrackArray[i].currSteps}  ${pedoTrackArray[i].totalSteps}');
      }
    } else {
      for (int i = 0; i < 8; i++) {
        pedoTrackArray.add(
          PedometerCount(
            distance: 0,
            neucoin: 0,
            calorie: 0,
            currSteps: -1,
            totalSteps: -1,
            date: DateTime(1990, 1, 1),
          ),
        );
      }
    }
    loadingData = false;
  }

  void onStepCount(StepCount event) {
    print(event);
    print(event.timeStamp);

    _steps = event.steps.toString();
    int weekDayIndex = getCurrentWeekDayIndex();
    pedoTrackArrayUpdate();
    print(pedoTrackArray[weekDayIndex].neucoin);
    notifyListeners();
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print(event);
    _status = event.status;
    notifyListeners();
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    _status = 'Pedestrian Status not available';
    print(_status);
    notifyListeners();
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    _steps = 'Step Count not available';
    notifyListeners();
  }

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);
    if (_steps != '?' && loadingData == false) {
      pedoTrackArrayUpdate();
    }
  }

  PedometerCount getWeekDayDetails(int weekDay) {
    if (loadingData == true) {
      return PedometerCount(
        distance: 0,
        neucoin: 0,
        calorie: 0,
        currSteps: -1,
        totalSteps: -1,
        date: DateTime(1990, 1, 1),
      );
    }
    return pedoTrackArray[weekDay];
  }

  int getStepsForRoundedBox(int i) {
    if (loadingData == true) {
      return 0;
    }
    return pedoTrackArray[i].currSteps.round();
  }

  String getSteps() {
    int weekDayIndex = getCurrentWeekDayIndex();
    if (loadingData == true) {
      return "Loading steps!";
    }
    return pedoTrackArray[weekDayIndex].currSteps.round().toString();
  }

  String getStatus() {
    return _status;
  }

  double getDistanceForCurrrntDay() {
    int weekDayIndex = getCurrentWeekDayIndex();
    if (loadingData == true) {
      return 0.0;
    }
    return pedoTrackArray[weekDayIndex].distance;
  }

  double getCalorie() {
    int weekDayIndex = getCurrentWeekDayIndex();
    if (loadingData == true) {
      return -1.0;
    }
    return pedoTrackArray[weekDayIndex].calorie;
  }

  double getDistance(int i) {
    if (loadingData == true) {
      return 0.0;
    }
    return pedoTrackArray[i].distance;
  }

  double getDistanceForNeuCoin() {
    if (loadingData == true) {
      return -1.0;
    }
    return double.parse(distanceLeft.toStringAsFixed(3));
  }

  double getNeuCoin() {
    int weekDayIndex = getCurrentWeekDayIndex();
    if (loadingData == true) {
      return 0.0;
    }
    return pedoTrackArray[weekDayIndex].neucoin;
  }

  void updateDistanceLeftForNeuCoin(double distance) {
    print("Update neucoin function");
    int weekDayIndex = getCurrentWeekDayIndex();
    distanceCovered = (distance) / 1000;
    if (distanceCovered >= shortDistanceTarget && shortDistanceTarget != -1) {
      print("update neucoin+1");
      pedoTrackArray[weekDayIndex].neucoin =
          pedoTrackArray[weekDayIndex].neucoin + 1;
    }
    shortDistanceTarget = distanceCovered + 1;
    int temp = shortDistanceTarget.truncate();
    distanceLeft = temp - distanceCovered;
  }

  int getCurrentWeekDayIndex() {
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    return date.weekday;
  }

  int getNeuCoinsEarnedInAWeek() {
    int sum = 0, i;
    if (loadingData == false) {
      for (i = 1; i <= 7; i++) {
        sum = sum + (pedoTrackArray[i].distance / 1000.0).truncate();
      }
    }
    return sum;
  }

  bool checkDataAtIndex(int weekDayIndex) {
    if (pedoTrackArray[weekDayIndex].totalSteps == -1) {
      return false;
    } else {
      return true;
    }
  }

  void pedoTrackArrayUpdate() {
    //getting week day index
    int weekDayIndex = getCurrentWeekDayIndex();

    //checking if data is present in that index
    if (checkDataAtIndex(weekDayIndex)) {
      //if data is present
      DateTime now = DateTime.now();
      DateFormat formatter = DateFormat('yyyy-MM-dd');
      String formatted = formatter.format(now);

      double pedoSteps = double.parse(_steps);

      if (formatter.format(pedoTrackArray[weekDayIndex].date) == formatted) {
        //if data is present and is of the same day,
        // simply overwrite with the same day record
        print("in the same day data is present");

        print("the total steps: ${pedoSteps}");
        print(
            "the array value: ${pedoTrackArray[weekDayIndex].totalSteps}  ${pedoTrackArray[weekDayIndex].currSteps}");

        if (pedoSteps < pedoTrackArray[weekDayIndex].totalSteps) {
          print("Phone switched off");
          pedoTrackArray[weekDayIndex].currSteps =
              pedoSteps + pedoTrackArray[weekDayIndex].currSteps;
          pedoTrackArray[weekDayIndex].totalSteps = pedoSteps;

          pedoTrackArray[weekDayIndex].calorie =
              pedoTrackArray[weekDayIndex].currSteps * 0.04;

          pedoTrackArray[weekDayIndex].distance =
              pedoTrackArray[weekDayIndex].currSteps * 0.7112;

          updateDistanceLeftForNeuCoin(pedoTrackArray[weekDayIndex].distance);
        } else {
          print("updating data on same day");
          pedoTrackArray[weekDayIndex].currSteps =
              (pedoSteps - pedoTrackArray[weekDayIndex].totalSteps) +
                  pedoTrackArray[weekDayIndex].currSteps;
          pedoTrackArray[weekDayIndex].totalSteps = double.parse(_steps);

          pedoTrackArray[weekDayIndex].calorie =
              pedoTrackArray[weekDayIndex].currSteps * 0.04;
          pedoTrackArray[weekDayIndex].distance =
              pedoTrackArray[weekDayIndex].currSteps *
                  0.7112; //distance in meters

          updateDistanceLeftForNeuCoin(pedoTrackArray[weekDayIndex].distance);

          if (weekDayIndex == 7) {
            pedoTrackArray[0] = pedoTrackArray[weekDayIndex];
          }
        }
      } else {
        //data is not of the same day
        //update the data with the previous day record
        if (pedoSteps < pedoTrackArray[weekDayIndex - 1].totalSteps) {
          print("phone switched off 2");
          pedoTrackArray[weekDayIndex].currSteps = pedoSteps;
          pedoTrackArray[weekDayIndex].totalSteps = pedoSteps;
          pedoTrackArray[weekDayIndex].date = DateTime.now();
          pedoTrackArray[weekDayIndex].calorie =
              pedoTrackArray[weekDayIndex].currSteps * 0.04;
          pedoTrackArray[weekDayIndex].distance =
              pedoTrackArray[weekDayIndex].currSteps * 0.7112;

          updateDistanceLeftForNeuCoin(pedoTrackArray[weekDayIndex].distance);

          if (weekDayIndex == 7) {
            pedoTrackArray[0] = pedoTrackArray[weekDayIndex];
          }
        } else {
          print("Update from previous day");
          pedoTrackArray[weekDayIndex].currSteps =
              pedoSteps - pedoTrackArray[weekDayIndex - 1].totalSteps;
          pedoTrackArray[weekDayIndex].totalSteps = double.parse(_steps);
          pedoTrackArray[weekDayIndex].date = DateTime.now();
          pedoTrackArray[weekDayIndex].calorie =
              pedoTrackArray[weekDayIndex].currSteps * 0.04;
          pedoTrackArray[weekDayIndex].distance =
              pedoTrackArray[weekDayIndex].currSteps * 0.7112;

          updateDistanceLeftForNeuCoin(pedoTrackArray[weekDayIndex].distance);

          if (weekDayIndex == 7) {
            pedoTrackArray[0] = pedoTrackArray[weekDayIndex];
          }
        }
      }
    } else {
      //data is not present i.e. first time installation
      if (checkDataAtIndex(weekDayIndex - 1) == false) {
        print("First time install");
        //checking if data is not present on the previous day
        pedoTrackArray[weekDayIndex].totalSteps = double.parse(_steps);
        pedoTrackArray[weekDayIndex].currSteps = 0;
        pedoTrackArray[weekDayIndex].date = DateTime.now();
        pedoTrackArray[weekDayIndex].calorie =
            pedoTrackArray[weekDayIndex].currSteps * 0.04;
        pedoTrackArray[weekDayIndex].distance =
            pedoTrackArray[weekDayIndex].currSteps * 0.7112;

        updateDistanceLeftForNeuCoin(pedoTrackArray[weekDayIndex].distance);

        if (weekDayIndex == 7) {
          pedoTrackArray[0] = pedoTrackArray[weekDayIndex];
        }
      } else {
        //if data is present on the previous day
        print("if data not present today but preent previous day");
        pedoTrackArray[weekDayIndex].totalSteps = double.parse(_steps);
        double pedoSteps = double.parse(_steps);
        pedoTrackArray[weekDayIndex].currSteps =
            (pedoSteps - pedoTrackArray[weekDayIndex - 1].totalSteps);
        pedoTrackArray[weekDayIndex].date = DateTime.now();
        pedoTrackArray[weekDayIndex].calorie =
            pedoTrackArray[weekDayIndex].currSteps * 0.04;
        pedoTrackArray[weekDayIndex].distance =
            pedoTrackArray[weekDayIndex].currSteps * 0.7112;

        updateDistanceLeftForNeuCoin(pedoTrackArray[weekDayIndex].distance);

        if (weekDayIndex == 7) {
          pedoTrackArray[0] = pedoTrackArray[weekDayIndex];
        }
      }
    }
  }

  static Future<void> save() async {
    var encodedArray = pedoTrackArray
        .map(
          (weekdaydata) => jsonEncode(
            {
              'neucoin': weekdaydata.neucoin,
              'distance': weekdaydata.distance,
              'calorie': weekdaydata.calorie,
              'totalSteps': weekdaydata.totalSteps,
              'currSteps': weekdaydata.currSteps,
              'date': weekdaydata.date.toString(),
            },
          ),
        )
        .toList();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('pedoData', encodedArray);
    print("saved");
  }
}
