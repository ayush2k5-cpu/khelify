import 'package:flutter/material.dart';
import '../themes/khelify_theme.dart';
import '../widgets/bottom_nav_bar.dart';
import '../screens/home_screen.dart';
import '../screens/record_modal_sheet.dart';
import '../screens/stats_screen.dart';

// ══════════════════════════════════════════════════════════
// MAIN APP SCREEN
// Tab navigation + Floating Record Button
// Home | Khojjoo | Record | Reel | Stats
// ══════════════════════════════════════════════════════════

class MainAppScreen extends StatefulWidget {
  const MainAppScreen({Key? key}) : super(key: key);

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KhelifyColors.scaffoldBackground,
      body: Stack(
        children: [
          // Main Content (Tab Views)
          IndexedStack(
            index: _currentIndex,
            children: [
              HomeScreen(), // Tab 0 - FIXED: no userRole here!
              _buildKhojjooScreen(), // Tab 1
              _buildRecordScreen(), // Tab 2 (handled by floating button)
              _buildReelScreen(), // Tab 3
              StatsScreen(), // Tab 4
            ],
          ),

          // Floating Record Button
          Positioned(
            bottom: 55,
            left: MediaQuery.of(context).size.width / 2 - 28,
            child: _buildFloatingRecordButton(),
          ),

          // Bottom Navigation Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BottomNavBar(
              currentIndex: _currentIndex,
              onTap: _onNavTap,
            ),
          ),
        ],
      ),
    );
  }

  // ========== FLOATING RECORD BUTTON ==========

  Widget _buildFloatingRecordButton() {
    return GestureDetector(
      onTap: _onRecordTap,
      onVerticalDragUpdate: (details) {
        if (details.delta.dy < -5) {
          _onRecordSwipeUp();
        }
      },
      child: _PulsingButton(),
    );
  }

  // ========== NAV HANDLING ==========

  void _onNavTap(int index) {
    if (index == 2) {
      // Record tab - show modal instead
      _onRecordSwipeUp();
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  void _onRecordTap() {
    _onRecordSwipeUp();
  }

  void _onRecordSwipeUp() {
    showRecordModal(
      context,
      onDrillSelected: (drill) {
        print('Selected drill: ${drill.name}');
        // TODO: Navigate to camera screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Starting ${drill.name}... 🔥'),
            backgroundColor: KhelifyColors.championGold,
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
    );
  }

  // ========== PLACEHOLDER SCREENS ==========

  Widget _buildKhojjooScreen() {
    return _buildPlaceholder(
      icon: '📍',
      title: 'KHOJJOO',
      subtitle: 'Discover sports academies near you',
      description:
          'Find Khelo India centers, private academies, and training facilities in your area.',
    );
  }

  Widget _buildRecordScreen() {
    return _buildPlaceholder(
      icon: '📹',
      title: 'RECORD',
      subtitle: 'Video assessment',
      description: 'Use the floating button to start recording your drill!',
    );
  }

  Widget _buildReelScreen() {
    return _buildPlaceholder(
      icon: '📱',
      title: 'REELS',
      subtitle: 'Vertical video feed',
      description: 'Swipe through athlete performances in TikTok-style format.',
    );
  }

  Widget _buildStatsScreen() {
    return _buildPlaceholder(
      icon: '📊',
      title: 'STATS',
      subtitle: 'Your performance dashboard',
      description:
          'Track your progress with Apple Fitness-style rings and Whoop-inspired metrics.',
    );
  }

  Widget _buildPlaceholder({
    required String icon,
    required String title,
    required String subtitle,
    required String description,
  }) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              icon,
              style: TextStyle(fontSize: 80),
            ),
            SizedBox(height: 24),
            ShaderMask(
              shaderCallback: (bounds) {
                return KhelifyColors.goldGradient.createShader(bounds);
              },
              child: Text(
                title,
                style: KhelifyTypography.displayLarge.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              subtitle,
              style: KhelifyTypography.bodyLarge.copyWith(
                color: KhelifyColors.textSecondary,
              ),
            ),
            SizedBox(height: 16),
            Text(
              description,
              style: KhelifyTypography.bodyMedium.copyWith(
                color: KhelifyColors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: KhelifyColors.cardDark,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: KhelifyColors.championGold,
                  width: 1,
                ),
              ),
              child: Text(
                'Coming in next build!',
                style: KhelifyTypography.bodySmall.copyWith(
                  color: KhelifyColors.championGold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
// PULSING BUTTON ANIMATION
// ══════════════════════════════════════════════════════════

class _PulsingButton extends StatefulWidget {
  @override
  State<_PulsingButton> createState() => _PulsingButtonState();
}

class _PulsingButtonState extends State<_PulsingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: KhelifyColors.blueGradient,
              boxShadow: [
                BoxShadow(
                  color: KhelifyColors.championGold.withOpacity(0.4),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
                BoxShadow(
                  color: KhelifyColors.sapphireBlue.withOpacity(0.6),
                  blurRadius: 20,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: Icon(
              Icons.videocam_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        );
      },
    );
  }
}
