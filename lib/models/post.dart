import 'package:cloud_firestore/cloud_firestore.dart';

// ══════════════════════════════════════════════════════════
// POST MODEL - Feed Activity Posts
// Strava + Instagram Hybrid Structure
// ══════════════════════════════════════════════════════════

class Post {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final String userTier; // Elite, Pro, Advanced, Beginner
  final String content;
  final String? mediaUrl;
  final String? mediaThumbnail;
  final String mediaType; // video, image, none
  final int mediaDuration; // seconds (for videos)
  
  // Drill Info
  final String drillName;
  final String drillIcon;
  final int score;
  final String tier; // ELITE, PRO, ADVANCED, BEGINNER
  
  // Engagement
  final int likes;
  final int comments;
  final int reposts;
  final int shares;
  final List<String> likedBy;
  
  // Metadata
  final DateTime timestamp;
  final bool isVerified;
  
  Post({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.userTier,
    required this.content,
    this.mediaUrl,
    this.mediaThumbnail,
    this.mediaType = 'none',
    this.mediaDuration = 0,
    required this.drillName,
    required this.drillIcon,
    required this.score,
    required this.tier,
    this.likes = 0,
    this.comments = 0,
    this.reposts = 0,
    this.shares = 0,
    this.likedBy = const [],
    required this.timestamp,
    this.isVerified = false,
  });
  
  // ========== FIRESTORE CONVERSION ==========
  
  factory Post.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return Post(
      id: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userAvatar: data['userAvatar'] ?? '',
      userTier: data['userTier'] ?? 'Beginner',
      content: data['content'] ?? '',
      mediaUrl: data['mediaUrl'],
      mediaThumbnail: data['mediaThumbnail'],
      mediaType: data['mediaType'] ?? 'none',
      mediaDuration: data['mediaDuration'] ?? 0,
      drillName: data['drillName'] ?? '',
      drillIcon: data['drillIcon'] ?? '⚡',
      score: data['score'] ?? 0,
      tier: data['tier'] ?? 'BEGINNER',
      likes: data['likes'] ?? 0,
      comments: data['comments'] ?? 0,
      reposts: data['reposts'] ?? 0,
      shares: data['shares'] ?? 0,
      likedBy: List<String>.from(data['likedBy'] ?? []),
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      isVerified: data['isVerified'] ?? false,
    );
  }
  
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'userTier': userTier,
      'content': content,
      'mediaUrl': mediaUrl,
      'mediaThumbnail': mediaThumbnail,
      'mediaType': mediaType,
      'mediaDuration': mediaDuration,
      'drillName': drillName,
      'drillIcon': drillIcon,
      'score': score,
      'tier': tier,
      'likes': likes,
      'comments': comments,
      'reposts': reposts,
      'shares': shares,
      'likedBy': likedBy,
      'timestamp': Timestamp.fromDate(timestamp),
      'isVerified': isVerified,
    };
  }
  
  // ========== HELPERS ==========
  
  String getTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }
  
  String formatDuration() {
    final minutes = mediaDuration ~/ 60;
    final seconds = mediaDuration % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
  
  String formatEngagement(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
  
  // ========== COMPATIBILITY GETTERS FOR FEED CARD ==========
  
  String get userRole => userTier;
  String? get videoUrl => mediaType == 'video' ? mediaUrl : null;
  
  String getTimeAgoSimple() {
    return getTimeAgo();
  }
}

// ══════════════════════════════════════════════════════════
// DRILL MODEL
// ══════════════════════════════════════════════════════════

class Drill {
  final String id;
  final String name;
  final String icon;
  final String sport;
  final String category; // Sports, Esports
  final String description;
  final List<String> instructions;
  final int estimatedDuration; // seconds
  final String difficulty; // Easy, Medium, Hard
  
  Drill({
    required this.id,
    required this.name,
    required this.icon,
    required this.sport,
    required this.category,
    required this.description,
    required this.instructions,
    required this.estimatedDuration,
    required this.difficulty,
  });
}

// ══════════════════════════════════════════════════════════
// USER MODEL (Simple)
// ══════════════════════════════════════════════════════════

class AppUser {
  final String id;
  final String name;
  final String email;
  final String avatar;
  final String role; // Athlete, Recruiter
  final String tier; // Elite, Pro, Advanced, Beginner
  final int totalScore;
  final int totalPosts;
  final int followers;
  final int following;
  final DateTime joinedAt;
  
  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.role,
    this.tier = 'Beginner',
    this.totalScore = 0,
    this.totalPosts = 0,
    this.followers = 0,
    this.following = 0,
    required this.joinedAt,
  });
  
  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return AppUser(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      avatar: data['avatar'] ?? '',
      role: data['role'] ?? 'Athlete',
      tier: data['tier'] ?? 'Beginner',
      totalScore: data['totalScore'] ?? 0,
      totalPosts: data['totalPosts'] ?? 0,
      followers: data['followers'] ?? 0,
      following: data['following'] ?? 0,
      joinedAt: (data['joinedAt'] as Timestamp).toDate(),
    );
  }
  
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'avatar': avatar,
      'role': role,
      'tier': tier,
      'totalScore': totalScore,
      'totalPosts': totalPosts,
      'followers': followers,
      'following': following,
      'joinedAt': Timestamp.fromDate(joinedAt),
    };
  }
}
