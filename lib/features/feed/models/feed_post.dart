// 1. Dart/Flutter SDK
// 2. External packages
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedPost {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatar;
  final String drillName;
  final double score;
  final DateTime timestamp;
  final String sportType;

  const FeedPost({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.drillName,
    required this.score,
    required this.timestamp,
    required this.sportType,
  });

  factory FeedPost.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FeedPost(
      id: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? 'Unknown',
      userAvatar: data['userAvatar'],
      drillName: data['drillName'] ?? '',
      score: (data['score'] ?? 0).toDouble(),
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      sportType: data['sportType'] ?? 'football',
    );
  }
}
