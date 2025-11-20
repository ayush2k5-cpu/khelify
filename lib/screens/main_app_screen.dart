import 'package:flutter/material.dart';
import '../themes/khelify_theme.dart';
import '../widgets/bottom_nav_bar.dart';
import '../screens/home_screen.dart';
import 'record_modal_sheet.dart';
import 'record_screen.dart';

class MainAppScreen extends StatefulWidget {
  const MainAppScreen({Key? key}) : super(key: key);

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int _currentIndex = 0;
  Drill? _selectedDrill; // Store selected drill at state level

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KhelifyColors.scaffoldBackground,
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: [
              HomeScreen(),
              _buildKhojjooScreen(),
              _buildRecordScreen(),
              _buildReelScreen(),
              _buildStatsScreen(),
            ],
          ),

          Positioned(
            bottom: 55,
            left: MediaQuery.of(context).size.width / 2 - 28,
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
        if (details.delta.dy < -5) {
          _onRecordSwipeUp();
        }
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
        print('🎬 DEBUG: Drill selected in MainApp: ${drill.name}');
        
        // Store the selected drill and navigate
        setState(() {
          _selectedDrill = drill;
        });
        
        // Close modal and navigate to RecordScreen
        Navigator.pop(context);
        
        // Navigate to RecordScreen with the selected drill
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecordScreen(selectedDrill: drill),
          ),
        ).then((_) {
          // Clear selection when returning from RecordScreen
          setState(() {
            _selectedDrill = null;
          });
        });
      },
    );
  }

  // ========== PLACEHOLDER SCREENS ==========
  Widget _buildKhojjooScreen() {
    return _buildPlaceholder(
      icon: '📍',
      title: 'KHOJJOO',
      subtitle: 'Discover sports academies near you',
      description: 'Find Khelo India centers, private academies, and training facilities in your area.',
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
      description: 'Track your progress with Apple Fitness-style rings and Whoop-inspired metrics.',
    );
  }

  Widget _buildPlaceholder({
    required String icon,
    required String title,
    required String subtitle,
    required String description,
  }) {
    return Container(
      color: KhelifyColors.scaffoldBackground,
      child: Center(
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
              Text(
                title,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 16),
              Text(
                description,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white54,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: KhelifyColors.championGold,
                    width: 1,
                  ),
                ),
                child: Text(
                  'Coming in next build!',
                  style: TextStyle(
                    fontSize: 14,
                    color: KhelifyColors.championGold,
                  ),
                ),
              ),
            ],
          ),
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