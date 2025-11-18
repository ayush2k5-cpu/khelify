import 'package:flutter/material.dart';
import '../widgets/glass_header.dart';
import '../widgets/feed_post_card.dart';
import '../widgets/follow_suggestion_card.dart';
import '../widgets/trending_card.dart';
import '../services/mock_data_service.dart';
import '../models/post.dart';

class HomeScreen extends StatelessWidget {
  final ScrollController? scrollController;
  
  const HomeScreen({super.key, this.scrollController});

  @override
  Widget build(BuildContext context) {
    final posts = MockDataService.getPosts();
    final suggestions = MockDataService.getFollowSuggestions();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          const GlassHeader(),
          Expanded(
            child: ListView.builder(
              controller: scrollController, // Add this line
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: posts.length + 2,
              itemBuilder: (context, index) {
                if (index == 2) return const TrendingCard();
                if (index == 4) {
                  return FollowSuggestionCard(suggestions: suggestions);
                }
                int postIndex = index;
                if (index > 4) postIndex -= 2;
                else if (index > 2) postIndex -= 1;
                if (postIndex < 0 || postIndex >= posts.length) {
                  return const SizedBox.shrink();
                }
                return FeedPostCard(post: posts[postIndex], index: postIndex);
              },
            ),
          ),
        ],
      ),
    );
  }
}
