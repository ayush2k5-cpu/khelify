import 'package:flutter/material.dart';
import '../widgets/glass_header.dart';
import '../widgets/feed_post_card.dart';
import '../widgets/follow_suggestion_card.dart';
import '../widgets/trending_card.dart';
import '../services/mock_data_service.dart';
import '../models/post.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final posts = MockDataService.getPosts(); // Returns List<Post>
    final suggestions = [
      // Hardcode here or (recommended) implement getFollowSuggestions() in MockDataService:
      {'name': 'Mike Ross', 'emoji': '⚡'},
      {'name': 'Alan Walker', 'emoji': '⚽'},
      {'name': 'Lisa Wong', 'emoji': '🏃'},
      {'name': 'Jesse Pink', 'emoji': '🏆'},
      {'name': 'Olivia Clark', 'emoji': '🥅'},
      {'name': 'Nathan Reed', 'emoji': '🏀'},
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: null,
        child: Column(
          children: [
            const GlassHeader(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 16),
                itemCount: posts.length + 2, // +2 for Trending and Suggestions
                itemBuilder: (context, index) {
                  if (index == 2) return const TrendingCard();
                  if (index == 4) {
                    return FollowSuggestionCard(
                      suggestions: suggestions,
                    );
                  }
                  // Adjust post index so inserted cards don't break the list
                  int postIndex = index;
                  if (index > 4) postIndex -= 2;
                  else if (index > 2) postIndex -= 1;

                  // Prevent out-of-range errors:
                  if (postIndex < 0 || postIndex >= posts.length) return const SizedBox.shrink();

                  return FeedPostCard(
                    post: posts[postIndex],
                    index: postIndex,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
