import 'package:flutter/material.dart';

class LevelXPProgress extends StatelessWidget {
  final int currentXP;
  final int xpGoal;
  final int currentLevel;
  final String? label;

  const LevelXPProgress({
    super.key,
    required this.currentXP,
    required this.xpGoal,
    required this.currentLevel,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = (currentXP / xpGoal).clamp(0, 1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 6),
        ],
        Row(
          children: [
            // Level badge circle
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF19E6FF),
                    Color(0xFF9D6BFF)
                  ], // Cyan to purple
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyanAccent.withOpacity(0.2),
                    blurRadius: 12,
                    spreadRadius: 2,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                '$currentLevel',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Progress bar and XP text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      LayoutBuilder(builder: (context, constraints) {
                        return Container(
                          height: 16,
                          width: constraints.maxWidth * progress,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF19E6FF),
                                Color(0xFF9D6BFF)
                              ], // Cyan to purple
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$currentXP / $xpGoal XP',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
