import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/post.dart';

class FeedPostCard extends StatelessWidget {
  final Post post;
  final int index;

  const FeedPostCard({super.key, required this.post, this.index = 0});

  Map<String, dynamic> _getColorScheme() {
    final schemes = [
      {
        'gradient': [const Color(0xFFBB330E), const Color(0xFFDD7631)],
        'accent': const Color(0xFFBB330E),
        'stats': const Color(0xFFDD7631),
      },
      {
        'gradient': [const Color(0xFFDD7631), const Color(0xFF708160)],
        'accent': const Color(0xFFDD7631),
        'stats': const Color(0xFF708160),
      },
      {
        'gradient': [const Color(0xFF708160), const Color(0xFFD9CF93)],
        'accent': const Color(0xFF708160),
        'stats': const Color(0xFFDD7631),
      },
      {
        'gradient': [const Color(0xFFD9CF93), const Color(0xFFBB330E)],
        'accent': const Color(0xFFD9CF93),
        'stats': const Color(0xFFBB330E),
      },
    ];
    return schemes[index % schemes.length];
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 2).toUpperCase();
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = _getColorScheme();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colors['gradient'][0].withOpacity(0.1),
                      colors['gradient'][1].withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: colors['accent'].withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: colors['gradient'],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: colors['accent'].withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                _getInitials(post.userName),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        post.userName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          color: Color(0xFF1A1A1A),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (post.isVerified) ...[
                                      const SizedBox(width: 4),
                                      Icon(
                                        Icons.verified,
                                        size: 16,
                                        color: colors['accent'],
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _getTimeAgo(post.timestamp),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: colors['accent'].withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: colors['accent'].withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Icon(
                                  Icons.more_horiz,
                                  color: colors['accent'],
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Caption
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                      child: Text(
                        post.content,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF1A1A1A),
                          height: 1.4,
                          letterSpacing: -0.2,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Image/Video Section
                    if (post.mediaType == 'video' || post.mediaType == 'image')
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Container(
                                height: 380,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xFFE0E0E0),
                                      const Color(0xFFF5F5F5),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    post.mediaType == 'video'
                                        ? Icons.play_circle_outline
                                        : Icons.image,
                                    size: 70,
                                    color: const Color(0xFFBDBDBD),
                                  ),
                                ),
                              ),
                            ),
                            // Sport badge
                            Positioned(
                              top: 12,
                              left: 12,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.black.withOpacity(0.6),
                                          Colors.black.withOpacity(0.4),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.2),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(post.drillIcon ?? '🏃',
                                            style: const TextStyle(fontSize: 14)),
                                        const SizedBox(width: 6),
                                        Text(
                                          post.drillName ?? 'Activity',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 12),
                    // Actions
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Row(
                        children: [
                          _buildGlassAction(
                              Icons.favorite, post.likes.toString(), colors['accent']),
                          const SizedBox(width: 20),
                          _buildGlassAction(Icons.chat_bubble, post.comments.toString(),
                              const Color(0xFF6B7280)),
                          const SizedBox(width: 20),
                          _buildGlassAction(Icons.repeat_rounded, post.shares.toString(),
                              const Color(0xFF6B7280)),
                          const Spacer(),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: colors['accent'].withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: colors['accent'].withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Icon(
                                  Icons.bookmark,
                                  size: 20,
                                  color: colors['accent'],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Stats Section (modify as needed)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF181B21),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6366F1).withOpacity(0.05),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatColumn(
                    label: "Score",
                    value: post.score.toString(),
                    unit: "",
                    icon: Icons.star,
                    gradient: const [Color(0xFFEC4899), Color(0xFF6366F1)],
                  ),
                  _StatColumn(
                    label: "Tier",
                    value: post.tier.substring(0, 3),
                    unit: "",
                    icon: Icons.emoji_events,
                    gradient: const [Color(0xFFFFD700), Color(0xFFFF8C00)],
                  ),
                  _StatColumn(
                    label: "Likes",
                    value: post.likes.toString(),
                    unit: "",
                    icon: Icons.favorite,
                    gradient: const [Color(0xFFFF6B6B), Color(0xFFFF4757)],
                  ),
                  _StatColumn(
                    label: "Comments",
                    value: post.comments.toString(),
                    unit: "",
                    icon: Icons.chat_bubble,
                    gradient: const [Color(0xFF4ECDC4), Color(0xFF44A08D)],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassAction(IconData icon, String count, Color color) {
    return Row(
      children: [
        Icon(icon, size: 22, color: color),
        const SizedBox(width: 6),
        Text(
          count,
          style: TextStyle(
            fontSize: 14,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label, value, unit;
  final IconData icon;
  final List<Color> gradient;
  const _StatColumn({
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: gradient.first.withOpacity(0.32),
                blurRadius: 10,
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 20,
                letterSpacing: -0.3,
              ),
            ),
            if (unit.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 2, left: 3),
                child: Text(
                  unit,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFCBD5E1),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
