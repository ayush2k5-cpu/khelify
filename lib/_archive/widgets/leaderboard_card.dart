import 'package:flutter/material.dart';

class LeaderboardCard extends StatelessWidget {
  final List<Map<String, dynamic>> leaders;

  const LeaderboardCard({super.key, required this.leaders});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF23252B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
            color: const Color.fromARGB(255, 64, 215, 251), width: 1.1),
      ),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Top Performers",
                style: TextStyle(
                    color: Colors.purpleAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...leaders.take(5).map((entry) => _buildRow(entry)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(Map<String, dynamic> entry) {
    int rank = entry['rank'];
    String user = entry['user'];
    int score = entry['score'];
    Color color = rank == 1 ? Colors.cyanAccent : Colors.white70;
    FontWeight weight = rank == 1 ? FontWeight.bold : FontWeight.normal;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Text(
            '$rank.',
            style: TextStyle(fontWeight: weight, color: color, fontSize: 15),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              user,
              style: TextStyle(color: color, fontWeight: weight, fontSize: 15),
            ),
          ),
          Text(
            '$score',
            style: TextStyle(color: color, fontWeight: weight, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
