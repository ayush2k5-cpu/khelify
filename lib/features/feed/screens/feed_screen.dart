import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khelify_app/core/theme/app_colors.dart';
import 'package:khelify_app/core/theme/app_typography.dart';
import '../providers/feed_provider.dart';
import '../widgets/feed_card.dart';
import '../widgets/feed_shimmer.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(feedStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Social Feed',
          style: AppTypography.h1.copyWith(
            // ← was headlineMedium
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: feedAsync.when(
        loading: () => const FeedShimmer(),
        error: (err, stack) => Center(
          child: Text(
            'Error: $err',
            style: AppTypography.bodyLarge.copyWith(color: AppColors.error),
          ),
        ),
        data: (posts) {
          if (posts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.sports_score,
                    size: 64,
                    color: AppColors.textSecondary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No activity yet',
                    style: AppTypography.h2.copyWith(
                      // ← was titleLarge
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Complete a drill to appear in the feed.',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: posts.length,
            itemBuilder: (context, index) => FeedCard(post: posts[index]),
          );
        },
      ),
    );
  }
}
