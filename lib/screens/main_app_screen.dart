import 'package:flutter/material.dart';
import '../themes/khelify_theme.dart';
import '../widgets/bottom_nav_bar.dart';
import '../screens/home_screen.dart';
import '../screens/record_modal_sheet.dart';
import '../screens/stats_screen.dart';
import '../screens/record_full_modal.dart'; // import this!
import '../screens/connect_screen.dart';

class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int _currentIndex = 0;
  bool _isNavBarVisible = true;
  bool _isRecordOverlayVisible = false;
  final ScrollController _scrollController = ScrollController();
  double _lastScrollPosition = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final currentScroll = _scrollController.position.pixels;
    final scrollDelta = currentScroll - _lastScrollPosition;

    if (scrollDelta > 5 && _isNavBarVisible) {
      setState(() => _isNavBarVisible = false);
    } else if (scrollDelta < -5 && !_isNavBarVisible) {
      setState(() => _isNavBarVisible = true);
    }
    if (currentScroll <= 0 && !_isNavBarVisible) {
      setState(() => _isNavBarVisible = true);
    }
    _lastScrollPosition = currentScroll;
  }

  @override
  Widget build(BuildContext context) {
    final recordOverlayHeight = MediaQuery.of(context).size.height * 0.85;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 135, 98, 98),
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Positioned.fill(
              child: IndexedStack(
                index: _currentIndex,
                children: [
                  HomeScreen(scrollController: _scrollController),
                  _buildKhojjooScreen(),
                  _buildRecordScreen(),
                  _buildConnectScreen(),
                  StatsScreen(), // ← Changed: use real stats UI here!
                ],
              ),
            ),

            // ========== Overlay Record Section ========== 
            AnimatedPositioned(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOut,
              left: 0,
              right: 0,
              bottom: _isRecordOverlayVisible ? 0 : -recordOverlayHeight - 32,
              height: recordOverlayHeight + 32, // for shadow/margin
              child: IgnorePointer(
                ignoring: !_isRecordOverlayVisible,
                child: GestureDetector(
                  onVerticalDragUpdate: (details) {
                    if (details.delta.dy > 8) {
                      setState(() => _isRecordOverlayVisible = false);
                    }
                  },
                  child: Material(
                    color: Colors.transparent,
                    elevation: 0,
                    child: Stack(
                      children: [
                        Container(
                          height: recordOverlayHeight,
                          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 24,
                                offset: const Offset(0, -8),
                              ),
                            ],
                          ),
                          child: RecordFullModal(
                            onClose: () => setState(() => _isRecordOverlayVisible = false),
                          ),
                        ),
                        // Close button (optional: top right)
                        Positioned(
                          right: 16,
                          top: 24,
                          child: IconButton(
                            icon: const Icon(Icons.close_rounded, size: 28),
                            onPressed: () => setState(() => _isRecordOverlayVisible = false),
                          ),
                        ),
                        // Drag handle
                        Positioned(
                          top: 10,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              width: 44,
                              height: 5,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Floating record button
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              bottom: _isNavBarVisible ? 30 : 15,
              left: MediaQuery.of(context).size.width / 2 - 30,
              child: _buildFloatingRecordButton(),
            ),

            // Bottom nav bar with auto-hide
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: BottomNavBar(
                currentIndex: _currentIndex,
                onTap: _onNavTap,
                isVisible: _isNavBarVisible,
              ),
            ),
          ],
        ),
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
    if (_isRecordOverlayVisible) {
      setState(() => _isRecordOverlayVisible = false);
    }
    setState(() {
      _currentIndex = index;
      _isNavBarVisible = true;
    });
  }

  void _onRecordTap() => _onRecordSwipeUp();

  void _onRecordSwipeUp() {
    setState(() => _isRecordOverlayVisible = true);
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

  // You can remove or ignore _buildStatsScreen if unused from now.

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
            Text(icon, style: const TextStyle(fontSize: 80)),
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

// PulsingButton class unchanged from before!
class _PulsingButton extends StatefulWidget {
  @override
  State<_PulsingButton> createState() => _PulsingButtonState();
}

class _PulsingButtonState extends State<_PulsingButton> with SingleTickerProviderStateMixin {
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
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _glowAnimation = Tween<double>(begin: 18, end: 40).animate(
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
                colors: [Color(0xFFFF6B35), Color(0xFFFF4500)],
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
