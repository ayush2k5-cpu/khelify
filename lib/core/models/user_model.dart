import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a Khelify user's profile data.
/// Shared across Profile, Feed, Stats, and Settings features.
class UserModel {
  final String uid;
  final String displayName;
  final String email;
  final String? avatarUrl;
  final String sport; // 'football', 'badminton', 'cricket'
  final String tier; // 'elite', 'pro', 'advanced', 'beginner'
  final int totalDrills;
  final double bestScore;
  final double averageScore;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.uid,
    required this.displayName,
    required this.email,
    this.avatarUrl,
    this.sport = 'football',
    this.tier = 'beginner',
    this.totalDrills = 0,
    this.bestScore = 0.0,
    this.averageScore = 0.0,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create a new user with default values (call on first signup)
  factory UserModel.newUser({
    required String uid,
    required String displayName,
    required String email,
    String sport = 'football',
  }) {
    final now = DateTime.now();
    return UserModel(
      uid: uid,
      displayName: displayName,
      email: email,
      sport: sport,
      tier: 'beginner',
      totalDrills: 0,
      bestScore: 0.0,
      averageScore: 0.0,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Firestore deserialization
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      displayName: data['displayName'] ?? '',
      email: data['email'] ?? '',
      avatarUrl: data['avatarUrl'],
      sport: data['sport'] ?? 'football',
      tier: data['tier'] ?? 'beginner',
      totalDrills: data['totalDrills'] ?? 0,
      bestScore: (data['bestScore'] ?? 0).toDouble(),
      averageScore: (data['averageScore'] ?? 0).toDouble(),
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  /// Firestore serialization
  Map<String, dynamic> toFirestore() {
    return {
      'displayName': displayName,
      'email': email,
      'avatarUrl': avatarUrl,
      'sport': sport,
      'tier': tier,
      'totalDrills': totalDrills,
      'bestScore': bestScore,
      'averageScore': averageScore,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Create a copy with updated fields
  UserModel copyWith({
    String? displayName,
    String? email,
    String? avatarUrl,
    String? sport,
    String? tier,
    int? totalDrills,
    double? bestScore,
    double? averageScore,
    DateTime? updatedAt,
  }) {
    return UserModel(
      uid: uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      sport: sport ?? this.sport,
      tier: tier ?? this.tier,
      totalDrills: totalDrills ?? this.totalDrills,
      bestScore: bestScore ?? this.bestScore,
      averageScore: averageScore ?? this.averageScore,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
