import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../widgets/goal_card.dart';
import '../widgets/leaderboard_card.dart';
import '../widgets/performance_graph.dart';
import '../widgets/streak_tracker.dart';
import '../widgets/drill_history_card.dart';
import '../widgets/personal_bests_card.dart';
import '../widgets/section_header.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  int xpGoal = 5000;
  int currentXP = 3500;

  final drills = [
    {
      'drillName': '5K Sprint Challenge',
      'score': 2200,
      'type': 'Sprint',
      'duration': '12 min',
      'date': DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      'drillName': 'Agility Ladder',
      'score': 1850,
      'type': 'Agility',
      'duration': '8 min',
      'date': DateTime.now().subtract(const Duration(days: 2)),
    },
  ];

  // Example mock performance data (use double values)
  final List<double> weeklyPerformance = [60, 75, 64, 88, 72, 95, 81];
  final List<String> dayLabels = [
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 2, 39, 48),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(14),
          children: [
            // Activity Rings and stats summary
            Card(
              color: const Color(0xFF262B32),
              elevation: 1.5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(21)),
              margin: const EdgeInsets.only(bottom: 18),
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Row(
                  children: [
                    CircularPercentIndicator(
                      radius: 46,
                      lineWidth: 14,
                      percent: 0.87,
                      progressColor: Colors.cyanAccent[400],
                      backgroundColor: Colors.blueGrey[900]!,
                      circularStrokeCap: CircularStrokeCap.round,
                      center: CircularPercentIndicator(
                        radius: 31,
                        lineWidth: 10,
                        percent: 0.62,
                        progressColor: Colors.purpleAccent[100],
                        backgroundColor: Colors.blueGrey[800]!,
                        circularStrokeCap: CircularStrokeCap.round,
                        center: CircularPercentIndicator(
                          radius: 16,
                          lineWidth: 7,
                          percent: 0.32,
                          progressColor: Colors.tealAccent[400],
                          backgroundColor: Colors.blueGrey[900]!,
                          circularStrokeCap: CircularStrokeCap.round,
                        ),
                      ),
                    ),
                    const SizedBox(width: 22),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _summaryLine(
                              'Drills', '17/20', Colors.cyanAccent[400]),
                          const SizedBox(height: 14),
                          _summaryLine('Streak', '6/7d', Colors.purpleAccent),
                          const SizedBox(height: 14),
                          _summaryLine(
                            'XP',
                            '$currentXP/$xpGoal',
                            Colors.tealAccent[400],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Weekly XP Goal Card
            GoalCard(
              goalName: "Weekly XP Goal",
              progressPercent: currentXP / xpGoal,
              progressLabel: "$currentXP / $xpGoal XP",
              onGoalSet: (newGoal) {
                setState(() {
                  xpGoal = newGoal;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Goal set to $newGoal XP!")),
                );
              },
            ),
            // Performance Graph (NEW)
            PerformanceGraph(
              data: weeklyPerformance,
              labels: dayLabels,
            ),
            // Leaderboard
            LeaderboardCard(
              leaders: [
                {'rank': 1, 'user': 'Ayush', 'score': 1945},
                {'rank': 2, 'user': 'Yash', 'score': 1821},
                {'rank': 3, 'user': 'Sam', 'score': 1750},
              ],
            ),
            // Streak section
            StreakTracker(
              currentStreak: 6,
              activeDays: [true, true, true, false, true, true, true],
            ),
            // Personal Bests
            PersonalBestsCard(
              maxScore: 1945,
              topSpeed: 27.4,
              longestStreak: 8,
            ),
            // Recent Drills Card
            Card(
              color: const Color(0xFF23252B),
              elevation: 0.3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17)),
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(
                      title: 'Recent Drills',
                      icon: Icons.fitness_center_rounded,
                      gradient: [
                        Colors.cyanAccent,
                        Colors.blueAccent
                      ], // <-- REQUIRED!
                      active: true,
                    ),
                    const SizedBox(height: 10),
                    ...drills
                        .map((drill) => DrillHistoryCard(
                              drillName: drill['drillName'] as String,
                              score: drill['score'] as int,
                              type: drill['type'] as String,
                              duration: drill['duration'] as String,
                              date: drill['date'] as DateTime,
                            ))
                        .toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper for Apple-style summary stat
  Widget _summaryLine(String label, String value, Color? accent) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            color: accent,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
