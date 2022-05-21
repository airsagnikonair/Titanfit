//class used to store the data for the history section
//in NeuCoinSummaryScreen

class PedometerCount {
  double currSteps, totalSteps;
  DateTime date;
  double calorie;
  double neucoin;
  double distance;

  PedometerCount(
      {required this.currSteps,
      required this.totalSteps,
      required this.date,
      required this.calorie,
      required this.neucoin,
      required this.distance});
}
