import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'section_header.dart';

class StreakTracker extends StatelessWidget {
  final int currentStreak;
  final List<bool> activeDays;

  const StreakTracker({
    super.key,
    required this.currentStreak,
    required this.activeDays,
  }) : assert(activeDays.length == 7);

  @override
  Widget build(BuildContext context) {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: "Current Streak: $currentStreak days",
          icon: Icons.local_fire_department_rounded,
          gradient: [Colors.purpleAccent, Colors.cyanAccent],
          active: true,
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (index) {
            final bool active = activeDays[index];
            return Column(
              children: [
                CircularPercentIndicator(
                  radius: 18,
                  lineWidth: 5,
                  percent: active ? 1.0 : 0.0,
                  backgroundColor: Colors.blueGrey[800]!,
                  progressColor: const Color.fromARGB(255, 24, 255, 147),
                  circularStrokeCap: CircularStrokeCap.round,
                  center: Container(),
                ),
                const SizedBox(height: 6),
                Text(
                  weekdays[index],
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}
