import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ProgressRing extends StatelessWidget {
  final String title;
  final double percent; // range: 0.0 - 1.0
  final Color color;
  final String centerText;
  final String? subtitle;

  const ProgressRing({
    super.key,
    required this.title,
    required this.percent,
    required this.color,
    required this.centerText,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircularPercentIndicator(
          radius: 54,
          lineWidth: 13,
          animation: true,
          percent: percent,
          backgroundColor: Colors.grey[850]!,
          progressColor: color,
          circularStrokeCap: CircularStrokeCap.round,
          center: Text(
            centerText,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: color,
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
        if (subtitle != null)
          Text(
            subtitle!,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
      ],
    );
  }
}
