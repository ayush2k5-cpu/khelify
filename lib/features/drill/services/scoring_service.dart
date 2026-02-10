import 'dart:math';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../models/drill.dart';

/// On-device scoring engine that evaluates pose data against drill criteria.
/// 
/// Takes raw ML Kit pose landmarks and produces a score (0-100) with
/// per-criterion technique breakdown.
class ScoringService {
  /// Evaluate a list of pose snapshots against a drill's scoring criteria.
  /// Returns a map of { criterionName: score } and overall weighted score.
  static ScoringResult evaluate(List<List<Pose>> poseFrames, Drill drill) {
    if (poseFrames.isEmpty || drill.scoringCriteria.isEmpty) {
      return ScoringResult.empty(drill);
    }

    final Map<String, double> breakdown = {};
    double weightedTotal = 0.0;

    for (final criterion in drill.scoringCriteria) {
      final double criterionScore = _scoreCriterion(criterion, poseFrames);
      breakdown[criterion.name] = criterionScore;
      weightedTotal += criterionScore * criterion.weight;
    }

    final int overallScore = weightedTotal.round().clamp(0, 100);
    final String tier = _tierFromScore(overallScore);

    return ScoringResult(
      overallScore: overallScore,
      tier: tier,
      techniqueBreakdown: breakdown,
    );
  }

  /// Score a single criterion based on the metric type.
  static double _scoreCriterion(ScoringCriterion criterion, List<List<Pose>> frames) {
    switch (criterion.metricType) {
      case 'angle':
        return _scoreAngleMetric(criterion, frames);
      case 'form':
        return _scoreFormMetric(criterion, frames);
      case 'speed':
        return _scoreSpeedMetric(criterion, frames);
      case 'consistency':
        return _scoreConsistencyMetric(criterion, frames);
      default:
        return 50.0; // Unknown metric, give average
    }
  }

  /// Angle-based scoring: evaluates joint angles against ideal ranges.
  static double _scoreAngleMetric(ScoringCriterion criterion, List<List<Pose>> frames) {
    final List<double> angles = [];

    for (final frameGroup in frames) {
      for (final pose in frameGroup) {
        final landmarks = pose.landmarks;

        double? angle;
        switch (criterion.name.toLowerCase()) {
          case 'knee drive':
          case 'knee lift':
            // Measure hip-knee angle (higher knee = better score for sprints)
            angle = _getAngle(
              landmarks[PoseLandmarkType.leftHip],
              landmarks[PoseLandmarkType.leftKnee],
              landmarks[PoseLandmarkType.leftAnkle],
            );
            break;
          case 'forward lean':
          case 'drive phase':
            // Measure shoulder-hip vertical angle (forward lean)
            angle = _getTorsoAngle(
              landmarks[PoseLandmarkType.leftShoulder],
              landmarks[PoseLandmarkType.leftHip],
            );
            break;
          case 'arm extension':
            // Measure shoulder-elbow-wrist extension
            angle = _getAngle(
              landmarks[PoseLandmarkType.rightShoulder],
              landmarks[PoseLandmarkType.rightElbow],
              landmarks[PoseLandmarkType.rightWrist],
            );
            break;
          case 'torso rotation':
            // Measure shoulder rotation relative to hips
            angle = _getRotationAngle(
              landmarks[PoseLandmarkType.leftShoulder],
              landmarks[PoseLandmarkType.rightShoulder],
              landmarks[PoseLandmarkType.leftHip],
              landmarks[PoseLandmarkType.rightHip],
            );
            break;
          case 'lunge depth':
          case 'knee position':
            // Measure knee bend angle
            angle = _getAngle(
              landmarks[PoseLandmarkType.rightHip],
              landmarks[PoseLandmarkType.rightKnee],
              landmarks[PoseLandmarkType.rightAnkle],
            );
            break;
        }

        if (angle != null) angles.add(angle);
      }
    }

    if (angles.isEmpty) return 60.0; // No data, give basic score

    // Score based on how many frames show good angles
    // Good angles for most drills: avoiding fully straight (180) or collapsed (< 90)
    double goodFrames = 0;
    for (final a in angles) {
      if (a >= 80 && a <= 160) { // "Good form" range
        goodFrames++;
      }
    }

    final ratio = goodFrames / angles.length;
    return (ratio * 100).clamp(0.0, 100.0);
  }

  /// Form-based scoring: evaluates overall body position and symmetry.
  static double _scoreFormMetric(ScoringCriterion criterion, List<List<Pose>> frames) {
    double totalScore = 0;
    int count = 0;

    for (final frameGroup in frames) {
      for (final pose in frameGroup) {
        final landmarks = pose.landmarks;

        // Check key "form" indicators: body symmetry, upright posture
        double frameScore = 50.0;

        // Shoulder alignment (should be roughly level horizontal)
        final leftShoulder = landmarks[PoseLandmarkType.leftShoulder];
        final rightShoulder = landmarks[PoseLandmarkType.rightShoulder];
        if (leftShoulder != null && rightShoulder != null) {
          final shoulderDiff = (leftShoulder.y - rightShoulder.y).abs();
          // Smaller diff = more level = better form
          final levelScore = (1.0 - (shoulderDiff / 100).clamp(0, 1)) * 100;
          frameScore = (frameScore + levelScore) / 2;
        }

        // Hip alignment
        final leftHip = landmarks[PoseLandmarkType.leftHip];
        final rightHip = landmarks[PoseLandmarkType.rightHip];
        if (leftHip != null && rightHip != null) {
          final hipDiff = (leftHip.y - rightHip.y).abs();
          final hipScore = (1.0 - (hipDiff / 100).clamp(0, 1)) * 100;
          frameScore = (frameScore + hipScore) / 2;
        }

        totalScore += frameScore;
        count++;
      }
    }

    return count > 0 ? (totalScore / count).clamp(0.0, 100.0) : 60.0;
  }

  /// Speed-based scoring: evaluates movement velocity between frames.
  static double _scoreSpeedMetric(ScoringCriterion criterion, List<List<Pose>> frames) {
    if (frames.length < 2) return 60.0;

    final List<double> movements = [];

    for (int i = 1; i < frames.length; i++) {
      if (frames[i].isEmpty || frames[i - 1].isEmpty) continue;

      final prev = frames[i - 1].first.landmarks;
      final curr = frames[i].first.landmarks;

      // Track ankle movement speed (key for footwork/sprint)
      final prevAnkle = prev[PoseLandmarkType.leftAnkle];
      final currAnkle = curr[PoseLandmarkType.leftAnkle];

      if (prevAnkle != null && currAnkle != null) {
        final dist = sqrt(
          pow(currAnkle.x - prevAnkle.x, 2) + pow(currAnkle.y - prevAnkle.y, 2),
        );
        movements.add(dist);
      }
    }

    if (movements.isEmpty) return 60.0;

    // Higher average movement = higher speed score
    final avgMovement = movements.reduce((a, b) => a + b) / movements.length;
    // Normalize: assume 50px movement per frame is excellent speed
    final score = (avgMovement / 50.0 * 100).clamp(0.0, 100.0);
    return score;
  }

  /// Consistency scoring: evaluates how uniform the movements are.
  static double _scoreConsistencyMetric(ScoringCriterion criterion, List<List<Pose>> frames) {
    if (frames.length < 3) return 60.0;

    final List<double> strideLengths = [];

    for (int i = 1; i < frames.length; i++) {
      if (frames[i].isEmpty || frames[i - 1].isEmpty) continue;

      final prev = frames[i - 1].first.landmarks;
      final curr = frames[i].first.landmarks;

      final prevAnkle = prev[PoseLandmarkType.leftAnkle];
      final currAnkle = curr[PoseLandmarkType.leftAnkle];

      if (prevAnkle != null && currAnkle != null) {
        final dist = sqrt(
          pow(currAnkle.x - prevAnkle.x, 2) + pow(currAnkle.y - prevAnkle.y, 2),
        );
        strideLengths.add(dist);
      }
    }

    if (strideLengths.length < 2) return 60.0;

    // Lower standard deviation = more consistent
    final mean = strideLengths.reduce((a, b) => a + b) / strideLengths.length;
    final variance = strideLengths.map((s) => pow(s - mean, 2)).reduce((a, b) => a + b) / strideLengths.length;
    final stdDev = sqrt(variance);

    // Normalize: stdDev of 0 = perfect consistency (100), stdDev > 30 = poor (0)
    final score = (1.0 - (stdDev / 30.0).clamp(0.0, 1.0)) * 100;
    return score.clamp(0.0, 100.0);
  }

  // ─── Geometry Helpers ───

  /// Calculate angle at point B given three landmarks A, B, C.
  static double? _getAngle(PoseLandmark? a, PoseLandmark? b, PoseLandmark? c) {
    if (a == null || b == null || c == null) return null;

    final ba = Point(a.x - b.x, a.y - b.y);
    final bc = Point(c.x - b.x, c.y - b.y);

    final dot = ba.x * bc.x + ba.y * bc.y;
    final magBA = sqrt(ba.x * ba.x + ba.y * ba.y);
    final magBC = sqrt(bc.x * bc.x + bc.y * bc.y);

    if (magBA == 0 || magBC == 0) return null;

    final cosAngle = (dot / (magBA * magBC)).clamp(-1.0, 1.0);
    return acos(cosAngle) * 180 / pi;
  }

  /// Calculate torso forward lean angle (from vertical).
  static double? _getTorsoAngle(PoseLandmark? shoulder, PoseLandmark? hip) {
    if (shoulder == null || hip == null) return null;

    final dx = shoulder.x - hip.x;
    final dy = shoulder.y - hip.y;

    return atan2(dx.abs(), dy.abs()) * 180 / pi;
  }

  /// Calculate rotation between shoulder line and hip line.
  static double? _getRotationAngle(
    PoseLandmark? leftShoulder,
    PoseLandmark? rightShoulder,
    PoseLandmark? leftHip,
    PoseLandmark? rightHip,
  ) {
    if (leftShoulder == null || rightShoulder == null ||
        leftHip == null || rightHip == null) return null;

    final shoulderAngle = atan2(
      rightShoulder.y - leftShoulder.y,
      rightShoulder.x - leftShoulder.x,
    );
    final hipAngle = atan2(
      rightHip.y - leftHip.y,
      rightHip.x - leftHip.x,
    );

    return ((shoulderAngle - hipAngle) * 180 / pi).abs();
  }

  static String _tierFromScore(int score) {
    if (score >= 90) return 'elite';
    if (score >= 75) return 'pro';
    if (score >= 60) return 'advanced';
    return 'beginner';
  }
}

/// The result of scoring a drill session.
class ScoringResult {
  final int overallScore;
  final String tier;
  final Map<String, double> techniqueBreakdown;

  const ScoringResult({
    required this.overallScore,
    required this.tier,
    required this.techniqueBreakdown,
  });

  factory ScoringResult.empty(Drill drill) {
    return ScoringResult(
      overallScore: 0,
      tier: 'beginner',
      techniqueBreakdown: {
        for (final c in drill.scoringCriteria) c.name: 0.0,
      },
    );
  }
}
