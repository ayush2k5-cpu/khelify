import 'package:flutter/material.dart';
import '../models/post.dart';

class FeedPostCard extends StatelessWidget {
  final Post post;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onRepost;
  final VoidCallback? onShare;
  final VoidCallback? onProfileTap;
  final VoidCallback? onMediaTap;

  const FeedPostCard({
    Key? key,
    required this.post,
    this.onLike,
    this.onComment,
    this.onRepost,
    this.onShare,
    this.onProfileTap,
    this.onMediaTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: Color(0xFFD4A574),
          width: 2,
        ),
      ),
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF7D6A55),
              Color(0xFF9B8468),
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: onProfileTap,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.grey[800],
                      backgroundImage: post.userAvatar.isNotEmpty
                          ? NetworkImage(post.userAvatar)
                          : null,
                      child: post.userAvatar.isEmpty
                          ? Icon(Icons.person, color: Colors.white)
                          : null,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                post.userName,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 6),
                              if (post.isVerified)
                                Icon(Icons.verified, color: Colors.blue, size: 18),
                            ],
                          ),
                          Text(
                            '${post.userTier} • ${post.getTimeAgo()}',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.more_vert, color: Colors.white70),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text(
                post.content,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 16),
              if (post.mediaUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: GestureDetector(
                    onTap: onMediaTap,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 200,
                          width: double.infinity,
                          color: Colors.grey[800],
                          child: Image.network(
                            post.mediaUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(color: Colors.grey[800]);
                            },
                          ),
                        ),
                        if (post.mediaType == 'video')
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: Colors.blue,
                            child: Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        if (post.mediaDuration > 0)
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                post.formatDuration(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 12),
              if (post.tier.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFD4A574), width: 1.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.flash_on, color: Color(0xFFD4A574), size: 18),
                      SizedBox(width: 6),
                      Text(
                        post.tier,
                        style: TextStyle(
                          color: Color(0xFFD4A574),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 16),
              Row(
                children: [
                  GestureDetector(
                    onTap: onLike,
                    child: Icon(Icons.favorite_border, color: Colors.white, size: 24),
                  ),
                  SizedBox(width: 6),
                  Text(post.formatEngagement(post.likes), style: TextStyle(color: Colors.white, fontSize: 14)),
                  SizedBox(width: 24),
                  GestureDetector(
                    onTap: onComment,
                    child: Icon(Icons.chat_bubble_outline, color: Colors.blue, size: 24),
                  ),
                  SizedBox(width: 6),
                  Text(post.formatEngagement(post.comments), style: TextStyle(color: Colors.blue, fontSize: 14)),
                  SizedBox(width: 24),
                  GestureDetector(
                    onTap: onShare,
                    child: Icon(Icons.share_outlined, color: Colors.blue, size: 24),
                  ),
                  SizedBox(width: 6),
                  Text(post.formatEngagement(post.shares), style: TextStyle(color: Colors.blue, fontSize: 14)),
                  Spacer(),
                  GestureDetector(
                    onTap: onRepost,
                    child: Icon(Icons.auto_awesome, color: Colors.white70, size: 28),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}