import 'package:flutter/material.dart';
import '../themes/khelify_theme.dart';
import '../models/post.dart';
import '../services/mock_data_service.dart';
import '../widgets/glass_header.dart';
import '../widgets/feed_post_card.dart';

// ══════════════════════════════════════════════════════════
// HOME SCREEN
// Activity Feed (Strava + Instagram hybrid)
// ══════════════════════════════════════════════════════════

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Post> posts;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 500));
    
    setState(() {
      posts = MockDataService.getMockPosts();
      isLoading = false;
    });
  }

  Future<void> _refreshPosts() async {
    setState(() {
      isLoading = true;
    });
    await _loadPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KhelifyColors.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Glass Header
            GlassHeader(
              onProfileTap: () {
                // TODO: Navigate to profile
                print('Profile tapped');
              },
              onDMTap: () {
                // TODO: Navigate to DM
                print('DM tapped');
              },
              onNotificationTap: () {
                // TODO: Navigate to notifications
                print('Notifications tapped');
              },
              hasNewNotifications: true,
              hasNewMessages: false,
            ),
            
            // Gold Divider
            GoldDivider(),
            
            // Feed
            Expanded(
              child: isLoading
                  ? _buildLoadingState()
                  : _buildFeed(),
            ),
          ],
        ),
      ),
    );
  }

  // ========== FEED ==========
  
  Widget _buildFeed() {
    return RefreshIndicator(
      onRefresh: _refreshPosts,
      color: KhelifyColors.championGold,
      backgroundColor: KhelifyColors.cardDark,
      child: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(
          top: 16,
          bottom: 140, // Space for bottom nav + floating button
        ),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return FeedPostCard(
            post: posts[index],
            onLike: () {
              print('Liked post: ${posts[index].id}');
              // TODO: Update like status in Firestore
            },
            onComment: () {
              print('Comment on post: ${posts[index].id}');
              // TODO: Navigate to comments
            },
            onRepost: () {
              print('Repost: ${posts[index].id}');
              // TODO: Handle repost
            },
            onShare: () {
              print('Share post: ${posts[index].id}');
              // TODO: Share functionality
            },
            onProfileTap: () {
              print('View profile: ${posts[index].userId}');
              // TODO: Navigate to user profile
            },
            onMediaTap: () {
              print('Play media: ${posts[index].mediaUrl}');
              // TODO: Open media viewer/player
            },
          );
        },
      ),
    );
  }

  // ========== LOADING STATE ==========
  
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: KhelifyColors.goldGradient,
            ),
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.black,
                strokeWidth: 3,
              ),
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Loading feed...',
            style: KhelifyTypography.bodyMedium.copyWith(
              color: KhelifyColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}