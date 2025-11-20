import 'package:flutter/material.dart';

class PersonalBestsCard extends StatelessWidget {
  final int maxScore;
  final double topSpeed;
  final int longestStreak;

  const PersonalBestsCard({
    super.key,
    required this.maxScore,
    required this.topSpeed,
    required this.longestStreak,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF23252B),
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.cyanAccent.shade700, width: 1.2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Personal Bests 🏆',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.cyanAccent[400])),
            const SizedBox(height: 10),
            _bestRow('Max Score', '$maxScore'),
            _bestRow('Top Speed', '${topSpeed.toStringAsFixed(1)} km/h'),
            _bestRow('Longest Streak', '$longestStreak days'),
          ],
        ),
      ),
    );
  }

  Widget _bestRow(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.white70)),
            Text(value,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w700)),
          ],
        ),
      );
}
