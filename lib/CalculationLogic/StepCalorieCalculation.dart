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
  static int totalCoins = 0;
  late int weekDayIndex;

  static bool loadingData =
      false; //track the completion of loading the array from permanent memory

  static List<PedometerCount> pedoTrackArray = [];

  //static function that fetches the array from permanent memory and
  //initialises it for use in the app
  static Future<void> initialiseArray() async {
    totalCoins = 0;
    loadingData = true;
    final prefs = await SharedPreferences.getInstance();
    final List<String>? items = prefs.getStringList('pedoData');
    if (prefs.getInt('totalCoins') != null) {
      totalCoins = prefs.getInt('totalCoins')!;
      print("retrived total coins");
    }

    //if array is found in permanent memory i.e if the app is already installed
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
    }
    //if the app is installed for the first time
    //we initialise the pedoTrackArray
    else {
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

  //function invoked when steps are taken by the user
  void onStepCount(StepCount event) {
    print(event);
    print(event.timeStamp);

    _steps = event.steps.toString();

    //fetching the number of the current day(Monday=1..Sunday=7)
    int weekDayIndex = getCurrentWeekDayIndex();
    //function that updates the array after each step is taken
    pedoTrackArrayUpdate();
    print(pedoTrackArray[weekDayIndex].neucoin);
    notifyListeners();
  }

  //function updates the status of the user between walking and standing/stopped
  void onPedestrianStatusChanged(PedestrianStatus event) {
    print(event);
    _status = event.status;
    notifyListeners();
  }

  //Error handling function
  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    _status = 'Pedestrian Status not available';
    print(_status);
    notifyListeners();
  }

  //Error handling function
  void onStepCountError(error) {
    print('onStepCountError: $error');
    _steps = 'Step Count not available';
    notifyListeners();
  }

  //initialises the sensor for reading data from it continuously
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

  //return the data for the NeuCoinSummaryPage(History section)
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

  //returns steps for showing the streak in the rounded widgets
  int getStepsForRoundedBox(int i) {
    if (loadingData == true) {
      return 0;
    }
    return pedoTrackArray[i].currSteps.round();
  }

  //returns the current steps from the pedoTrackArray
  String getSteps() {
    int weekDayIndex = getCurrentWeekDayIndex();
    if (loadingData == true) {
      return "Loading steps!";
    }
    return pedoTrackArray[weekDayIndex].currSteps.round().toString();
  }

  //returns the user status
  String getStatus() {
    return _status;
  }

  //returns the total coins earned by user
  int getTotalCoins() {
    return totalCoins;
  }

  //returns the distance walked from the pedoTrackArray
  double getDistanceForCurrrntDay() {
    int weekDayIndex = getCurrentWeekDayIndex();
    if (loadingData == true) {
      return 0.0;
    }
    return pedoTrackArray[weekDayIndex].distance;
  }

  //returns the calorie count from the pedoTrackArray
  double getCalorie() {
    int weekDayIndex = getCurrentWeekDayIndex();
    if (loadingData == true) {
      return -1.0;
    }
    return pedoTrackArray[weekDayIndex].calorie;
  }

  //returns the distance walked by the user on a specific day
  double getDistance(int i) {
    if (loadingData == true) {
      return 0.0;
    }
    return pedoTrackArray[i].distance;
  }

  //returns distance left to cover target distance to get 1 NeuCoin
  double getDistanceForNeuCoin() {
    if (loadingData == true) {
      return -1.0;
    }
    return double.parse(distanceLeft.toStringAsFixed(3));
  }

  //logic for calculation of distance left to earn 1 neu coin
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

  //returns the day of the week in number(Monday=1..Sunday=7)
  int getCurrentWeekDayIndex() {
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    return date.weekday;
  }

  //adds up the total neu coins earned in the last 7 days
  int getNeuCoinsEarnedInAWeek() {
    int sum = 0, i;
    if (loadingData == false) {
      for (i = 1; i <= 7; i++) {
        sum = sum + (pedoTrackArray[i].distance / 1000.0).truncate();
      }
    }
    return sum;
  }

  //checks where the last update of the array is present
  //accordingly the steps and other parameters are calculated
  bool checkDataAtIndex(int weekDayIndex) {
    if (pedoTrackArray[weekDayIndex].totalSteps == -1) {
      return false;
    } else {
      return true;
    }
  }

  //logic for updating the array and tracking the steps, calorie, distance, coins
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

          int coins =
              (pedoTrackArray[weekDayIndex].distance / 1000.0).truncate();
          if (coins > totalCoins) {
            totalCoins = totalCoins + (coins - totalCoins);
            print("total coins $totalCoins");
          }

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

          int coins =
              (pedoTrackArray[weekDayIndex].distance / 1000.0).truncate();
          print('$coins  $totalCoins');
          if (coins > totalCoins) {
            totalCoins = totalCoins + (coins - totalCoins);
          }

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

          int coins =
              (pedoTrackArray[weekDayIndex].distance / 1000.0).truncate();
          if (coins > totalCoins) {
            totalCoins = totalCoins + (coins - totalCoins);
          }

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

          int coins =
              (pedoTrackArray[weekDayIndex].distance / 1000.0).truncate();
          if (coins > totalCoins) {
            totalCoins = totalCoins + (coins - totalCoins);
          }

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

        int coins = (pedoTrackArray[weekDayIndex].distance / 1000.0).truncate();
        if (coins > totalCoins) {
          totalCoins = totalCoins + (coins - totalCoins);
        }

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

        int coins = (pedoTrackArray[weekDayIndex].distance / 1000.0).truncate();
        if (coins > totalCoins) {
          totalCoins = totalCoins + (coins - totalCoins);
        }

        updateDistanceLeftForNeuCoin(pedoTrackArray[weekDayIndex].distance);

        if (weekDayIndex == 7) {
          pedoTrackArray[0] = pedoTrackArray[weekDayIndex];
        }
      }
    }
  }

  //saves the pedoTrackArray and totalCoins in permanent memory
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
    print("saving coins ${totalCoins}");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('pedoData', encodedArray);
    await prefs.setInt('totalCoins', totalCoins);
    print("saved");
  }
}
