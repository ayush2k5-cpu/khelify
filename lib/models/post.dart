 // ══════════════════════════════════════════════════════════
// POST MODEL
// Represents a social media post in the feed
// ══════════════════════════════════════════════════════════

class Post {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final String userTier;
  final String content;
  final String? mediaUrl;
  final String? mediaThumbnail;
  final String mediaType;
  final int mediaDuration;
  final String drillName;
  final String drillIcon;
  final int score;
  final String tier;
  final int likes;
  final int comments;
  final int reposts;
  final int shares;
  final List<String> likedBy;
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
    required this.mediaType,
    required this.mediaDuration,
    required this.drillName,
    required this.drillIcon,
    required this.score,
    required this.tier,
    required this.likes,
    required this.comments,
    required this.reposts,
    required this.shares,
    required this.likedBy,
    required this.timestamp,
    required this.isVerified,
  });

  // Helper method to format duration (e.g., "0:15")
  String formatDuration() {
    int minutes = mediaDuration ~/ 60;
    int seconds = mediaDuration % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  // Helper method to format engagement numbers (e.g., "1.2K", "89")
  String formatEngagement(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  // Helper method to get time ago string
  String getTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }
}

// ══════════════════════════════════════════════════════════
// DRILL MODEL
// Represents a training drill
// ══════════════════════════════════════════════════════════

class Drill {
  final String id;
  final String name;
  final String icon;
  final String sport;
  final String category;
  final String description;
  final List<String> instructions;
  final int estimatedDuration;
  final String difficulty;

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
// APP USER MODEL
// Represents a user of the app
// ══════════════════════════════════════════════════════════

class AppUser {
  final String id;
  final String name;
  final String email;
  final String avatar;
  final String role;
  final String tier;
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
    required this.tier,
    required this.totalScore,
    required this.totalPosts,
    required this.followers,
    required this.following,
    required this.joinedAt,
  });
}