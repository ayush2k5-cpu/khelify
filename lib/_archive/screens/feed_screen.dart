import 'dart:ui';
import 'package:flutter/material.dart';
import '../widgets/khelify_feed_card.dart';
import '../themes/khelify_theme.dart';

class FeedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KhelifyColors.scaffoldBackground, // Updated from Color(0xFF0A0A0A)
      body: Stack(
        children: [
          // Animated gradient background
          AnimatedGradientBackground(),
          SafeArea(
            child: Column(
              children: [
                SexyGlassHeader(),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 8, bottom: 80),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return KhelifyFeedCard(
                        userName: 'User ${index + 1}',
                        userAvatar: 'https://i.pravatar.cc/150?img=${index + 1}',
                        drillName: 'Sprint #${index + 1}',
                        content: 'Finished a spicy drill today! Check my stats 💪',
                        mediaUrl: (index % 3 == 0) ? 'https://picsum.photos/400/300?random=$index' : null,
                        tier: (index % 3) + 1,
                        score: 1900 + (index * 72),
                        userTier: ['Elite Pro', 'Advanced', 'Beginner'][index % 3],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedGradientBackground extends StatefulWidget {
  @override
  _AnimatedGradientBackgroundState createState() => _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 8),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [KhelifyColors.scaffoldBackground, KhelifyColors.cardDark, KhelifyColors.scaffoldBackground],
              begin: Alignment(_controller.value * 2 - 1, -1),
              end: Alignment(_controller.value * -2 + 1, 1),
            ),
          ),
        );
      },
    );
  }
}

class SexyGlassHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: KhelifyColors.championGold.withOpacity(0.1), // Updated
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [KhelifyColors.championGold, KhelifyColors.accentOrange],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: KhelifyColors.scaffoldBackground,
                    child: Icon(Icons.person, color: KhelifyColors.textTertiary, size: 20),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [KhelifyColors.championGold, KhelifyColors.accentOrange, KhelifyColors.darkOrange],
                  ).createShader(bounds),
                  child: Text(
                    'Khelify',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              ),
              _GlassIconButton(icon: Icons.search_outlined, onTap: () {}),
              SizedBox(width: 12),
              _GlassIconButton(icon: Icons.chat_bubble_outline, onTap: () {}, hasBadge: true),
              SizedBox(width: 12),
              _GlassIconButton(icon: Icons.notifications_none_outlined, onTap: () {}, hasBadge: true),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool hasBadge;

  const _GlassIconButton({required this.icon, required this.onTap, this.hasBadge = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: KhelifyColors.lightWhite.withOpacity(0.1), // Updated
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: KhelifyColors.lightWhite.withOpacity(0.2)), // Updated
        ),
        child: Stack(
          children: [
            Icon(icon, color: KhelifyColors.lightWhite.withOpacity(0.7), size: 22), // Updated color
            if (hasBadge)
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: KhelifyColors.redAccent, // Updated
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
