import 'package:flutter/material.dart';

class FitnessMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final Widget? trailing;
  final Color? color;

  const FitnessMetricCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.trailing,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color ?? Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.all(7),
      elevation: 0.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.white70, fontSize: 15),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text(
                  value,
                  style: TextStyle(
                      color: Colors.amberAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 22),
                ),
                if (trailing != null) ...[
                  SizedBox(width: 8),
                  trailing!,
                ]
              ],
            ),
            if (subtitle != null)
              Text(
                subtitle!,
                style: TextStyle(color: Colors.white38, fontSize: 13),
              ),
          ],
        ),
      ),
    );
  }
}
