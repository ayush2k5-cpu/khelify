import 'package:flutter/material.dart';
import 'package:khelify_app/core/theme/app_colors.dart';

class FeedShimmer extends StatefulWidget {
  const FeedShimmer({super.key});

  @override
  State<FeedShimmer> createState() => _FeedShimmerState();
}

class _FeedShimmerState extends State<FeedShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _shimmerBox({double height = 16, double? width, double radius = 8}) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) => Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: AppColors.textSecondary.withOpacity(_animation.value),
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }

  Widget _shimmerCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              _shimmerBox(height: 44, width: 44, radius: 22),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _shimmerBox(height: 14, width: 120),
                  const SizedBox(height: 6),
                  _shimmerBox(height: 10, width: 80),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Drill name
          _shimmerBox(height: 16, width: 160),
          const SizedBox(height: 16),
          // Score row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _shimmerBox(height: 12, width: 50),
              _shimmerBox(height: 12, width: 60),
            ],
          ),
          const SizedBox(height: 8),
          // Score bar
          _shimmerBox(height: 8, width: double.infinity),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(5, (_) => _shimmerCard()),
    );
  }
}
