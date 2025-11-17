import 'dart:ui';
import 'package:flutter/material.dart';
import '../themes/khelify_theme.dart';
import '../widgets/bottom_nav_bar.dart';
import '../screens/home_screen.dart';
import '../screens/record_modal_sheet.dart';
import '../screens/connect_screen.dart';

class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

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
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 38, sigmaY: 38),
              child: Container(
                color: Colors.white.withOpacity(0.53),
              ),
            ),
          ),
          IndexedStack(
            index: _currentIndex,
            children: [
              const HomeScreen(),
              _buildKhojjooScreen(),
              _buildRecordScreen(),
              _buildConnectScreen(),
              _buildStatsScreen(),
            ],
          ),
          Positioned(
            bottom: 50,
            left: MediaQuery.of(context).size.width / 2 - 30,
            child: _buildFloatingRecordButton(),
          ),
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

  Widget _buildFloatingRecordButton() {
    return GestureDetector(
      onTap: _onRecordTap,
      onVerticalDragUpdate: (details) {
        if (details.delta.dy < -5) _onRecordSwipeUp();
      },
      child: _PulsingButton(),
    );
  }

  void _onNavTap(int index) {
    if (index == 2) {
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

  Widget _buildConnectScreen() {
    return const ConnectScreen();
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
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              icon,
              style: const TextStyle(fontSize: 80),
            ),
            const SizedBox(height: 24),
            ShaderMask(
              shaderCallback: (bounds) {
                return KhelifyColors.goldGradient.createShader(bounds);
              },
              child: Text(
                title,
                style: KhelifyTypography.displayLarge.copyWith(
                  color: KhelifyColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: KhelifyTypography.bodyLarge.copyWith(
                color: KhelifyColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: KhelifyTypography.bodyMedium.copyWith(
                color: KhelifyColors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: KhelifyColors.cardLight,
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

class _PulsingButton extends StatefulWidget {
  @override
  State<_PulsingButton> createState() => _PulsingButtonState();
}

class _PulsingButtonState extends State<_PulsingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.08).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _glowAnimation = Tween<double>(begin: 18, end: 40).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
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
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFF6B35),
                  Color(0xFFFF4500),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF6B35).withOpacity(0.7),
                  blurRadius: _glowAnimation.value,
                  spreadRadius: _glowAnimation.value / 3,
                ),
                BoxShadow(
                  color: const Color(0xFFFF4500).withOpacity(0.4),
                  blurRadius: _glowAnimation.value * 0.8,
                  spreadRadius: _glowAnimation.value / 4,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(
              Icons.videocam_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
        );
      },
    );
  }
}
