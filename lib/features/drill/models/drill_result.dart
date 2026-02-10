import 'package:cloud_firestore/cloud_firestore.dart';

/// Result of a completed drill session with scoring breakdown.
class DrillResult {
  final String id;
  final String drillId;
  final String drillName;
  final String userId;
  final int score;           // 0-100
  final String tier;         // 'elite', 'pro', 'advanced', 'beginner'
  final Duration duration;
  final Map<String, double> techniqueBreakdown; // e.g. {"Knee Drive": 85.0, "Arm Swing": 72.0}
  final String? videoPath;   // Local path for video (before upload)
  final String? videoUrl;    // Cloud URL after upload
  final DateTime timestamp;

  DrillResult({
    required this.id,
    required this.drillId,
    required this.drillName,
    required this.userId,
    required this.score,
    required this.tier,
    required this.duration,
    required this.techniqueBreakdown,
    this.videoPath,
    this.videoUrl,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Calculate tier from score
  static String tierFromScore(int score) {
    if (score >= 90) return 'elite';
    if (score >= 75) return 'pro';
    if (score >= 60) return 'advanced';
    return 'beginner';
  }

  /// Firestore serialization
  Map<String, dynamic> toFirestore() {
    return {
      'drillId': drillId,
      'drillName': drillName,
      'userId': userId,
      'score': score,
      'tier': tier,
      'duration': duration.inSeconds,
      'techniqueBreakdown': techniqueBreakdown,
      'videoUrl': videoUrl,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  factory DrillResult.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DrillResult(
      id: doc.id,
      drillId: data['drillId'] ?? '',
      drillName: data['drillName'] ?? '',
      userId: data['userId'] ?? '',
      score: data['score'] ?? 0,
      tier: data['tier'] ?? 'beginner',
      duration: Duration(seconds: data['duration'] ?? 0),
      techniqueBreakdown: Map<String, double>.from(data['techniqueBreakdown'] ?? {}),
      videoUrl: data['videoUrl'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}
