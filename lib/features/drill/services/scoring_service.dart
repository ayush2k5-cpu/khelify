import 'dart:math';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../models/drill.dart';

/// Full scoring result returned by [ScoringService.evaluate].
class ScoringResult {
  final int overallScore;         // 0-100
  final String tier;              // 'elite', 'pro', 'advanced', 'beginner'
  final Map<String, double> techniqueBreakdown; // criterion name → score
  final double confidence;        // average landmark likelihood (0-1)

  ScoringResult({
    required this.overallScore,
    required this.tier,
    required this.techniqueBreakdown,
    required this.confidence,
  });
}

/// Minimum landmark confidence to include in scoring.
const double _kMinLikelihood = 0.65;

/// Maps landmark name strings to [PoseLandmarkType].
const Map<String, PoseLandmarkType> _landmarkMap = {
  'leftShoulder': PoseLandmarkType.leftShoulder,
  'rightShoulder': PoseLandmarkType.rightShoulder,
  'leftElbow': PoseLandmarkType.leftElbow,
  'rightElbow': PoseLandmarkType.rightElbow,
  'leftWrist': PoseLandmarkType.leftWrist,
  'rightWrist': PoseLandmarkType.rightWrist,
  'leftHip': PoseLandmarkType.leftHip,
  'rightHip': PoseLandmarkType.rightHip,
  'leftKnee': PoseLandmarkType.leftKnee,
  'rightKnee': PoseLandmarkType.rightKnee,
  'leftAnkle': PoseLandmarkType.leftAnkle,
  'rightAnkle': PoseLandmarkType.rightAnkle,
  'nose': PoseLandmarkType.nose,
  'leftEar': PoseLandmarkType.leftEar,
  'rightEar': PoseLandmarkType.rightEar,
  'leftEye': PoseLandmarkType.leftEye,
  'rightEye': PoseLandmarkType.rightEye,
  'leftPinky': PoseLandmarkType.leftPinky,
  'rightPinky': PoseLandmarkType.rightPinky,
  'leftIndex': PoseLandmarkType.leftIndex,
  'rightIndex': PoseLandmarkType.rightIndex,
  'leftThumb': PoseLandmarkType.leftThumb,
  'rightThumb': PoseLandmarkType.rightThumb,
  'leftHeel': PoseLandmarkType.leftHeel,
  'rightHeel': PoseLandmarkType.rightHeel,
  'leftFootIndex': PoseLandmarkType.leftFootIndex,
  'rightFootIndex': PoseLandmarkType.rightFootIndex,
  'leftMouth': PoseLandmarkType.leftMouth,
  'rightMouth': PoseLandmarkType.rightMouth,
};

/// Provides the mirrored (left↔right) version of a landmark name.
String _mirrorLandmark(String name) {
  if (name.startsWith('left')) {
    return 'right${name.substring(4)}';
  } else if (name.startsWith('right')) {
    return 'left${name.substring(5)}';
  }
  return name; // 'nose', etc. have no mirror
}

/// Adaptive scoring engine for Khelify's drill evaluation system.
///
/// Uses Gaussian falloff scoring with sport-specific biomechanical rubrics.
/// Supports bilateral landmark detection (left/right/auto) and adaptive
/// difficulty based on user tier.
class ScoringService {
  const ScoringService._();

  // ═══════════════════════════════════════════════════════════════════
  //  PUBLIC API
  // ═══════════════════════════════════════════════════════════════════

  /// Evaluate a drill session and return a detailed [ScoringResult].
  ///
  /// [drill] — The drill definition with scoring criteria.
  /// [frames] — All detected poses from the recording session.
  /// [userTier] — Current user tier for adaptive difficulty ('beginner', etc.).
  /// [scoringFrameInterval] — Only score every Nth frame (default 6 for 10fps scoring from 60fps camera).
  static ScoringResult evaluate({
    required Drill drill,
    required List<List<Pose>> frames,
    String userTier = 'beginner',
    int scoringFrameInterval = 6,
  }) {
    if (frames.isEmpty || drill.scoringCriteria.isEmpty) {
      return ScoringResult(
        overallScore: 0,
        tier: 'beginner',
        techniqueBreakdown: {},
        confidence: 0.0,
      );
    }

    // Sample frames for scoring
    final scoringFrames = <List<Pose>>[];
    for (int i = 0; i < frames.length; i += scoringFrameInterval) {
      scoringFrames.add(frames[i]);
    }
    if (scoringFrames.isEmpty) scoringFrames.add(frames.last);

    final tierMul = _tierMultiplier(userTier);
    final breakdown = <String, double>{};
    double weightedSum = 0;
    double totalWeight = 0;
    double totalLikelihood = 0;
    int likelihoodCount = 0;

    for (final criterion in drill.scoringCriteria) {
      final double score;

      switch (criterion.metricType) {
        case 'angle':
          score = _scoreAngle(criterion, scoringFrames, tierMul);
          break;
        case 'speed':
          score = _scoreSpeed(criterion, scoringFrames);
          break;
        case 'consistency':
          score = _scoreConsistency(criterion, scoringFrames);
          break;
        case 'form':
          score = _scoreForm(criterion, scoringFrames, tierMul);
          break;
        default:
          score = 50.0;
      }

      breakdown[criterion.name] = score.clamp(0, 100);
      weightedSum += score.clamp(0, 100) * criterion.weight;
      totalWeight += criterion.weight;
    }

    // Compute average confidence from all scoring frames
    for (final frame in scoringFrames) {
      if (frame.isNotEmpty) {
        for (final landmark in frame.first.landmarks.values) {
          totalLikelihood += landmark.likelihood;
          likelihoodCount++;
        }
      }
    }

    final avgConfidence = likelihoodCount > 0
        ? totalLikelihood / likelihoodCount
        : 0.0;

    final overall = totalWeight > 0
        ? (weightedSum / totalWeight).round()
        : 0;

    return ScoringResult(
      overallScore: overall.clamp(0, 100),
      tier: _tierFromScore(overall.clamp(0, 100)),
      techniqueBreakdown: breakdown,
      confidence: avgConfidence,
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  GAUSSIAN SCORING CORE
  // ═══════════════════════════════════════════════════════════════════

  /// Gaussian falloff score.
  ///
  /// Returns 100 if [observed] is within [idealMin]..[idealMax].
  /// Outside that range, score decays as a Gaussian curve controlled by [sigma].
  static double gaussianScore(
    double observed,
    double idealMin,
    double idealMax,
    double sigma,
  ) {
    if (observed >= idealMin && observed <= idealMax) return 100.0;
    final deviation = observed < idealMin
        ? idealMin - observed
        : observed - idealMax;
    return 100.0 * exp(-(deviation * deviation) / (2 * sigma * sigma));
  }

  // ═══════════════════════════════════════════════════════════════════
  //  METRIC SCORERS
  // ═══════════════════════════════════════════════════════════════════

  /// Score an angle-based criterion across all sampled frames.
  static double _scoreAngle(
    ScoringCriterion criterion,
    List<List<Pose>> frames,
    double tierMultiplier,
  ) {
    if (criterion.idealMin == null ||
        criterion.idealMax == null ||
        criterion.landmarkA == null ||
        criterion.landmarkB == null ||
        criterion.landmarkC == null) {
      return 50.0; // Fallback for under-specified criteria
    }

    final sigma = (criterion.sigma ?? 12.0) * tierMultiplier;
    double totalScore = 0;
    int validFrames = 0;

    for (final frame in frames) {
      if (frame.isEmpty) continue;
      final pose = frame.first;

      // Get angle for the best side
      final angle = _getAngleForSide(
        pose,
        criterion.landmarkA!,
        criterion.landmarkB!,
        criterion.landmarkC!,
        criterion.side,
      );

      if (angle != null) {
        totalScore += gaussianScore(
          angle,
          criterion.idealMin!,
          criterion.idealMax!,
          sigma,
        );
        validFrames++;
      }
    }

    return validFrames > 0 ? totalScore / validFrames : 0.0;
  }

  /// Score speed-based criterion using normalized pixel velocity.
  ///
  /// Normalizes movement by torso length (shoulder→hip) so scores
  /// are resolution-independent.
  static double _scoreSpeed(
    ScoringCriterion criterion,
    List<List<Pose>> frames,
  ) {
    if (frames.length < 2) return 50.0;

    final speeds = <double>[];
    double? prevX, prevY;

    for (final frame in frames) {
      if (frame.isEmpty) continue;
      final pose = frame.first;

      // Track the landmark specified, or default to ankle
      final landmarkType = criterion.landmarkB != null
          ? _landmarkMap[criterion.landmarkB!]
          : PoseLandmarkType.leftAnkle;

      final lm = pose.landmarks[landmarkType];
      if (lm == null || lm.likelihood < _kMinLikelihood) continue;

      final torsoLength = _getTorsoLength(pose);
      if (torsoLength < 10) continue; // Guard against division issues

      if (prevX != null && prevY != null) {
        final dx = lm.x - prevX;
        final dy = lm.y - prevY;
        final rawSpeed = sqrt(dx * dx + dy * dy);
        speeds.add(rawSpeed / torsoLength); // Normalized
      }

      prevX = lm.x;
      prevY = lm.y;
    }

    if (speeds.isEmpty) return 50.0;

    // Higher normalized speed → better score (capped at 100)
    final avgSpeed = speeds.reduce((a, b) => a + b) / speeds.length;
    // Typical good normalized speed is ~0.3-0.6 torso-lengths per frame
    return (avgSpeed * 200).clamp(0, 100);
  }

  /// Score consistency by measuring angle stability across frames.
  static double _scoreConsistency(
    ScoringCriterion criterion,
    List<List<Pose>> frames,
  ) {
    if (frames.length < 3) return 50.0;

    // Collect the relevant angle over time
    final angles = <double>[];
    for (final frame in frames) {
      if (frame.isEmpty) continue;
      final pose = frame.first;

      final angle = _getAngleForSide(
        pose,
        criterion.landmarkA ?? 'leftHip',
        criterion.landmarkB ?? 'leftKnee',
        criterion.landmarkC ?? 'leftAnkle',
        criterion.side,
      );

      if (angle != null) angles.add(angle);
    }

    if (angles.length < 3) return 50.0;

    // Compute coefficient of variation (lower = more consistent)
    final mean = angles.reduce((a, b) => a + b) / angles.length;
    if (mean < 1.0) return 50.0;

    final variance = angles.map((a) => (a - mean) * (a - mean))
        .reduce((a, b) => a + b) / angles.length;
    final cv = sqrt(variance) / mean; // Coefficient of variation

    // CV of 0 → perfect consistency (100), CV of 0.3+ → poor (0)
    return ((1.0 - cv / 0.3) * 100).clamp(0, 100);
  }

  /// Score form-based criterion.
  ///
  /// "Form" criteria evaluate whether landmarks maintain proper relative
  /// positions (e.g., "arms horizontal" means shoulder-elbow-wrist ≈ 180°).
  /// Uses the same Gaussian logic as angle metrics when rubric data is present.
  static double _scoreForm(
    ScoringCriterion criterion,
    List<List<Pose>> frames,
    double tierMultiplier,
  ) {
    // If biomechanical data is provided, use angle scoring
    if (criterion.idealMin != null &&
        criterion.idealMax != null &&
        criterion.landmarkA != null &&
        criterion.landmarkB != null &&
        criterion.landmarkC != null) {
      return _scoreAngle(criterion, frames, tierMultiplier);
    }

    // Fallback: heuristic body symmetry + stability check
    double totalScore = 0;
    int validFrames = 0;

    for (final frame in frames) {
      if (frame.isEmpty) continue;
      final pose = frame.first;

      double frameScore = 70.0; // Neutral baseline

      // Check shoulder symmetry
      final ls = pose.landmarks[PoseLandmarkType.leftShoulder];
      final rs = pose.landmarks[PoseLandmarkType.rightShoulder];
      if (ls != null && rs != null &&
          ls.likelihood >= _kMinLikelihood &&
          rs.likelihood >= _kMinLikelihood) {
        final yDiff = (ls.y - rs.y).abs();
        final torso = _getTorsoLength(pose);
        if (torso > 10) {
          final normalizedDiff = yDiff / torso;
          // Small diff = good form
          frameScore += (1.0 - (normalizedDiff * 5).clamp(0, 1)) * 20;
        }
      }

      // Check hip symmetry
      final lh = pose.landmarks[PoseLandmarkType.leftHip];
      final rh = pose.landmarks[PoseLandmarkType.rightHip];
      if (lh != null && rh != null &&
          lh.likelihood >= _kMinLikelihood &&
          rh.likelihood >= _kMinLikelihood) {
        final yDiff = (lh.y - rh.y).abs();
        final torso = _getTorsoLength(pose);
        if (torso > 10) {
          final normalizedDiff = yDiff / torso;
          frameScore += (1.0 - (normalizedDiff * 5).clamp(0, 1)) * 10;
        }
      }

      totalScore += frameScore.clamp(0, 100);
      validFrames++;
    }

    return validFrames > 0 ? totalScore / validFrames : 50.0;
  }

  // ═══════════════════════════════════════════════════════════════════
  //  BILATERAL LANDMARK DETECTION
  // ═══════════════════════════════════════════════════════════════════

  /// Get the angle at the vertex [b], formed by points [a]-[b]-[c],
  /// choosing the best side based on the [side] parameter.
  ///
  /// For 'auto': computes both left and right angles, returns the one
  /// whose vertex landmark (b) has higher [InFrameLikelihood].
  static double? _getAngleForSide(
    Pose pose,
    String a,
    String b,
    String c,
    String side,
  ) {
    switch (side) {
      case 'left':
        return _computeAngle(pose, a, b, c);
      case 'right':
        return _computeAngle(
          pose,
          _mirrorLandmark(a),
          _mirrorLandmark(b),
          _mirrorLandmark(c),
        );
      case 'both':
        // Average of both sides
        final left = _computeAngle(pose, a, b, c);
        final right = _computeAngle(
          pose,
          _mirrorLandmark(a),
          _mirrorLandmark(b),
          _mirrorLandmark(c),
        );
        if (left != null && right != null) return (left + right) / 2;
        return left ?? right;
      case 'auto':
      default:
        // Pick the side with higher vertex confidence
        final leftB = _getLandmark(pose, b);
        final rightB = _getLandmark(pose, _mirrorLandmark(b));

        final leftConf = leftB?.likelihood ?? 0;
        final rightConf = rightB?.likelihood ?? 0;

        if (leftConf >= rightConf && leftConf >= _kMinLikelihood) {
          return _computeAngle(pose, a, b, c);
        } else if (rightConf >= _kMinLikelihood) {
          return _computeAngle(
            pose,
            _mirrorLandmark(a),
            _mirrorLandmark(b),
            _mirrorLandmark(c),
          );
        }

        // Try left as fallback
        return _computeAngle(pose, a, b, c);
    }
  }

  // ═══════════════════════════════════════════════════════════════════
  //  GEOMETRY HELPERS
  // ═══════════════════════════════════════════════════════════════════

  /// Compute angle at vertex [b] formed by [a]-[b]-[c] in degrees.
  /// Returns null if any landmark is missing or below confidence threshold.
  static double? _computeAngle(Pose pose, String a, String b, String c) {
    final lmA = _getLandmark(pose, a);
    final lmB = _getLandmark(pose, b);
    final lmC = _getLandmark(pose, c);

    if (lmA == null || lmB == null || lmC == null) return null;
    if (lmA.likelihood < _kMinLikelihood ||
        lmB.likelihood < _kMinLikelihood ||
        lmC.likelihood < _kMinLikelihood) {
      return null;
    }

    return _angleDegrees(lmA, lmB, lmC);
  }

  /// Calculate angle at vertex [b] in degrees using 2D coordinates.
  static double _angleDegrees(
    PoseLandmark a,
    PoseLandmark b,
    PoseLandmark c,
  ) {
    final vecBAx = a.x - b.x;
    final vecBAy = a.y - b.y;
    final vecBCx = c.x - b.x;
    final vecBCy = c.y - b.y;

    final dot = vecBAx * vecBCx + vecBAy * vecBCy;
    final magBA = sqrt(vecBAx * vecBAx + vecBAy * vecBAy);
    final magBC = sqrt(vecBCx * vecBCx + vecBCy * vecBCy);

    if (magBA < 1e-6 || magBC < 1e-6) return 0;

    final cosAngle = (dot / (magBA * magBC)).clamp(-1.0, 1.0);
    return acos(cosAngle) * 180.0 / pi;
  }

  /// Get a landmark by name string, or null if not found.
  static PoseLandmark? _getLandmark(Pose pose, String name) {
    final type = _landmarkMap[name];
    if (type == null) return null;
    return pose.landmarks[type];
  }

  /// Compute torso length (shoulder midpoint → hip midpoint) for normalization.
  static double _getTorsoLength(Pose pose) {
    final ls = pose.landmarks[PoseLandmarkType.leftShoulder];
    final rs = pose.landmarks[PoseLandmarkType.rightShoulder];
    final lh = pose.landmarks[PoseLandmarkType.leftHip];
    final rh = pose.landmarks[PoseLandmarkType.rightHip];

    if (ls == null || rs == null || lh == null || rh == null) return 100.0;

    final shoulderMidX = (ls.x + rs.x) / 2;
    final shoulderMidY = (ls.y + rs.y) / 2;
    final hipMidX = (lh.x + rh.x) / 2;
    final hipMidY = (lh.y + rh.y) / 2;

    final dx = shoulderMidX - hipMidX;
    final dy = shoulderMidY - hipMidY;
    return sqrt(dx * dx + dy * dy);
  }

  // ═══════════════════════════════════════════════════════════════════
  //  TIER LOGIC
  // ═══════════════════════════════════════════════════════════════════

  /// σ multiplier for adaptive difficulty.
  ///
  /// Beginners get a larger σ (more forgiving), elite get a smaller σ (stricter).
  static double _tierMultiplier(String tier) {
    switch (tier) {
      case 'beginner':
        return 1.8;
      case 'advanced':
        return 1.3;
      case 'pro':
        return 1.0;
      case 'elite':
        return 0.7;
      default:
        return 1.0;
    }
  }

  /// Map overall score (0-100) to tier name.
  static String _tierFromScore(int score) {
    if (score >= 90) return 'elite';
    if (score >= 75) return 'pro';
    if (score >= 60) return 'advanced';
    return 'beginner';
  }
}
