import 'package:flutter/material.dart';
import 'section_header.dart';

// This is your main GoalCard widget
class GoalCard extends StatelessWidget {
  final String goalName;
  final double progressPercent; // Between 0 and 1
  final String progressLabel; // e.g., "3500 / 5000 XP"
  final ValueChanged<int> onGoalSet; // <--- Changed

  const GoalCard({
    super.key,
    required this.goalName,
    required this.progressPercent,
    required this.progressLabel,
    required this.onGoalSet,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF23252B),
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.cyanAccent[400]!, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              title: goalName,
              icon: Icons.flag_rounded,
              gradient: [Colors.cyanAccent, Colors.blueAccent],
              active: true,
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 12,
              child: Stack(
                children: [
                  // Background bar
                  Container(
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[900],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  // Foreground gradient bar
                  FractionallySizedBox(
                    widthFactor: progressPercent.clamp(0.0, 1.0),
                    child: Container(
                      height: 12,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF19E6FF), Color(0xFF9D6BFF)],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              progressLabel,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purpleAccent[100],
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  elevation: 2,
                ),
                child: const Text(
                  'Set New Goal',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  // Show input dialog and call parent if value entered
                  int? newGoal = await showDialog<int>(
                    context: context,
                    builder: (ctx) => GoalInputDialog(),
                  );
                  if (newGoal != null && newGoal > 0) {
                    onGoalSet(newGoal);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// This is the dialog used to set a new goal
class GoalInputDialog extends StatefulWidget {
  @override
  State<GoalInputDialog> createState() => _GoalInputDialogState();
}

class _GoalInputDialogState extends State<GoalInputDialog> {
  final TextEditingController _controller = TextEditingController();
  String? _error;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF23252B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(21)),
      title: Row(
        children: [
          Icon(Icons.flag_rounded, color: Colors.cyanAccent[400]),
          const SizedBox(width: 10),
          Text(
            'Set Weekly XP Goal',
            style: TextStyle(
                color: Colors.cyanAccent[400], fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: 'XP Goal',
          labelStyle: const TextStyle(color: Colors.white70),
          errorText: _error,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.cyanAccent[400]!),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.cyanAccent[700]!),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text("Cancel", style: TextStyle(color: Colors.white70)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.cyanAccent[400],
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text("Set Goal"),
          onPressed: () {
            final text = _controller.text.trim();
            final value = int.tryParse(text);
            if (value == null || value <= 0) {
              setState(() => _error = "Please enter a valid XP amount");
            } else {
              Navigator.of(context).pop(value);
            }
          },
        )
      ],
    );
  }
}
