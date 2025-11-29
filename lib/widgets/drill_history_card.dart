import 'package:flutter/material.dart';

class DrillHistoryCard extends StatelessWidget {
  final String drillName;
  final int score;
  final String type; // e.g. "Sprint", "Agility"
  final String duration; // e.g. "12 min", "00:45"
  final DateTime date;

  const DrillHistoryCard({
    super.key,
    required this.drillName,
    required this.score,
    required this.type,
    required this.duration,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormatted = "${date.day}/${date.month}/${date.year}";
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon or colored circle showing drill type
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: type.toLowerCase() == "sprint"
                    ? Colors.orangeAccent
                    : Colors.blueAccent,
              ),
              child: Icon(
                type.toLowerCase() == "sprint"
                    ? Icons.directions_run
                    : Icons.sports_tennis,
                color: Colors.white,
                size: 28,
              ),
            ),

            SizedBox(width: 16),

            // Drill info text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    drillName,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    "$type • $duration",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    dateFormatted,
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // Score badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Score: $score',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
