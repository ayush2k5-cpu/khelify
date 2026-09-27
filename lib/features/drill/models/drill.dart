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
  final String cameraPosition; // 'side', 'front', 'rear-angled'
  final String status; // 'active', 'coming_soon'

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
    this.cameraPosition = 'side',
    this.status = 'active',
  });
}

/// Defines what aspect of a drill gets scored and its weight.
///
/// For angle-based metrics, [idealMin]/[idealMax] define the "perfect" range
/// in degrees. Scores use Gaussian falloff controlled by [sigma].
///
/// Landmarks are specified as PoseLandmarkType names (e.g. 'leftHip').
/// The angle is measured at [landmarkB] (vertex), formed by points
/// [landmarkA]-[landmarkB]-[landmarkC].
class ScoringCriterion {
  final String name;        // e.g. "Knee Drive", "Arm Swing"
  final String description; // What we're measuring
  final double weight;      // 0.0 - 1.0, all weights in a drill sum to 1.0
  final String metricType;  // 'angle', 'speed', 'consistency', 'form'

  // ─── Biomechanical rubric (for angle metrics) ───
  final double? idealMin;   // Lower bound of ideal range (degrees)
  final double? idealMax;   // Upper bound of ideal range (degrees)
  final double? sigma;      // Gaussian tolerance (degrees), default ~12

  // ─── Landmark specification ───
  final String? landmarkA;  // First point (e.g. 'leftHip')
  final String? landmarkB;  // Vertex of the angle (e.g. 'leftKnee')
  final String? landmarkC;  // Third point (e.g. 'leftAnkle')
  final String side;        // 'left', 'right', 'both', 'auto'

  const ScoringCriterion({
    required this.name,
    required this.description,
    required this.weight,
    required this.metricType,
    this.idealMin,
    this.idealMax,
    this.sigma,
    this.landmarkA,
    this.landmarkB,
    this.landmarkC,
    this.side = 'auto',
  });
}
