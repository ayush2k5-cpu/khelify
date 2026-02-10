import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ModernRingSet extends StatelessWidget {
  final int moveNow, moveGoal, exerciseNow, exerciseGoal, standNow, standGoal;

  const ModernRingSet({
    super.key,
    required this.moveNow,
    required this.moveGoal,
    required this.exerciseNow,
    required this.exerciseGoal,
    required this.standNow,
    required this.standGoal,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularPercentIndicator(
            radius: 75,
            lineWidth: 18,
            percent: (moveNow / moveGoal).clamp(0.0, 1.0),
            backgroundColor: Colors.white12,
            progressColor: Colors.pinkAccent,
            circularStrokeCap: CircularStrokeCap.round,
          ),
          CircularPercentIndicator(
            radius: 60,
            lineWidth: 12,
            percent: (exerciseNow / exerciseGoal).clamp(0.0, 1.0),
            backgroundColor: Colors.white12,
            progressColor: Colors.lightGreenAccent[400]!,
            circularStrokeCap: CircularStrokeCap.round,
          ),
          CircularPercentIndicator(
            radius: 45,
            lineWidth: 8,
            percent: (standNow / standGoal).clamp(0.0, 1.0),
            backgroundColor: Colors.white12,
            progressColor: Colors.cyanAccent,
            circularStrokeCap: CircularStrokeCap.round,
            center: Container(),
          ),
        ],
      ),
    );
  }
}
