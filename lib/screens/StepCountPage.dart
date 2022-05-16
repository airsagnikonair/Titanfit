// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:titanfit/widgets/WeekDays.dart';

import '../widgets/BottomNavigation.dart';
import '../widgets/WalkParameter.dart';
import '../widgets/WeekDaysSmallDisplay.dart';
import '../widgets/NeuCoinCounter.dart';
import 'package:pedometer/pedometer.dart';

import 'package:flutter/material.dart';

class StepCountPage extends StatefulWidget {
  const StepCountPage({Key? key}) : super(key: key);

  @override
  State<StepCountPage> createState() => _StepCountPageState();
}

class _StepCountPageState extends State<StepCountPage> {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?', _steps = '?';
  double calorie = 0;
  double distanceCovered = 0;
  double distanceLeft = 1;
  bool distanceLeftStatus = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void onStepCount(StepCount event) {
    print(event);
    setState(() {
      _steps = event.steps.toString();
      calorie = (event.steps) * 0.04;
      distanceCovered = ((event.steps * 78) / 100000);
      distanceLeft = (distanceLeft - distanceCovered);
      if (distanceLeft <= 0) {
        distanceLeftStatus = true;
      }
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print(event);
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    setState(() {
      _status = 'Pedestrian Status not available';
    });
    print(_status);
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = 'Step Count not available';
    });
  }

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0x505b0098),
        body: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.purple, Color(0x505b0098)],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              stops: [0.1, 0.8],
              tileMode: TileMode.repeated,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Icon(
                      Icons.arrow_left,
                      size: 50,
                    ),
                  ),
                  Container(
                    child: Text(
                      "Today",
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Icon(
                      Icons.arrow_right,
                      size: 50,
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(bottom: 15),
                alignment: Alignment.center,
                height: 320,
                width: 320,
                decoration: BoxDecoration(
                  color: Color(0xFFF9CEEE), //Color(0xFFFF4949),
                  borderRadius: BorderRadius.circular(320),
                ),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 30, top: 80),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        _status == "walking"
                            ? Icons.nordic_walking
                            : Icons.do_not_step,
                        size: 150,
                      ),
                      Text(
                        _steps,
                        style: TextStyle(fontSize: 25, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  WalkParameter(
                      parameterText: "Calories", parameterValue: calorie),
                  SizedBox(
                    width: 10,
                  ),
                  WalkParameter(parameterText: "Target", parameterValue: 10000)
                ],
              ),
              NewCoinCounter(distanceLeft: distanceLeft),
              WeekDays(),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigation(
          currIndex: 0,
        ),
      ),
    );
  }
}
