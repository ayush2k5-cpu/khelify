/// Represents a drill that athletes can perform and be scored on.
class Drill {
  final String id;
  final String name;
  final String sport;
  final String category;
  final String description;
  final List<String> instructions;
  final Duration estimatedDuration;
  final String difficulty; // 'beginner', 'intermediate', 'advanced'
  final String icon;
  final List<ScoringCriterion> scoringCriteria;

  const Drill({
    required this.id,
    required this.name,
    required this.sport,
    required this.category,
    required this.description,
    required this.instructions,
    required this.estimatedDuration,
    required this.difficulty,
    required this.icon,
    required this.scoringCriteria,
  });
}

/// Defines what aspect of a drill gets scored and its weight.
class ScoringCriterion {
  final String name;        // e.g. "Knee Drive", "Arm Swing"
  final String description; // What we're measuring
  final double weight;      // 0.0 - 1.0, all weights in a drill sum to 1.0
  final String metricType;  // 'angle', 'speed', 'consistency', 'form'

  const ScoringCriterion({
    required this.name,
    required this.description,
    required this.weight,
    required this.metricType,
  });
}
