import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../themes/khelify_theme.dart';

// ══════════════════════════════════════════════════════════
// BOTTOM NAVIGATION BAR
// 5 Tabs: Home | Khojjoo | Record | Reel | Stats
// Icons Only (No Labels)
// ══════════════════════════════════════════════════════════

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.95),
        border: Border(
          top: BorderSide(
            width: 1,
            color: KhelifyColors.championGold,
          ),
        ),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: 0,
                icon: LucideIcons.home,
                label: 'Home',
              ),
              _buildNavItem(
                index: 1,
                icon: PhosphorIcons.mapPin(PhosphorIconsStyle.duotone),
                label: 'Khojjoo',
              ),
              _buildNavItem(
                index: 2,
                icon: PhosphorIcons.videoCamera(PhosphorIconsStyle.fill),
                label: 'Record',
              ),
              _buildNavItem(
                index: 3,
                icon: LucideIcons.playCircle,
                label: 'Reel',
              ),
              _buildNavItem(
                index: 4,
                icon: LucideIcons.activity,
                label: 'Stats',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isActive = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        width: 60,
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              child: Icon(
                icon,
                size: 24,
                color: isActive 
                    ? KhelifyColors.sapphireBlue 
                    : KhelifyColors.textSecondary,
              ),
            ),
            // No text labels - icons only!
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
// FLOATING RECORD BUTTON
// Positioned above bottom nav center
// Swipe-up gesture to open drill selector
// ══════════════════════════════════════════════════════════

class FloatingRecordButton extends StatefulWidget {
  final VoidCallback onTap;
  final VoidCallback onSwipeUp;

  const FloatingRecordButton({
    Key? key,
    required this.onTap,
    required this.onSwipeUp,
  }) : super(key: key);

  @override
  State<FloatingRecordButton> createState() => _FloatingRecordButtonState();
}

class _FloatingRecordButtonState extends State<FloatingRecordButton> 
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  double _dragDistance = 0;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 55, // Above bottom nav
      left: MediaQuery.of(context).size.width / 2 - 28, // Center
      child: GestureDetector(
        onTap: widget.onTap,
        onVerticalDragUpdate: (details) {
          setState(() {
            _dragDistance += details.delta.dy;
            if (_dragDistance < -50) {
              // Swipe up detected
              widget.onSwipeUp();
              _dragDistance = 0;
            }
          });
        },
        onVerticalDragEnd: (details) {
          setState(() {
            _dragDistance = 0;
          });
        },
        child: AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: KhelifyColors.blueGradient,
                boxShadow: [
                  BoxShadow(
                    color: KhelifyColors.championGold.withOpacity(
                      0.3 + (_pulseController.value * 0.3),
                    ),
                    blurRadius: 20 + (_pulseController.value * 15),
                    spreadRadius: 5 + (_pulseController.value * 5),
                  ),
                  BoxShadow(
                    color: KhelifyColors.sapphireBlue.withOpacity(0.5),
                    blurRadius: 15,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Icon(
                PhosphorIcons.videoCamera(PhosphorIconsStyle.fill),
                color: Colors.white,
                size: 28,
              ),
            );
          },
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
// NAV WRAPPER WITH FLOATING BUTTON
// Use this in your main screen
// ══════════════════════════════════════════════════════════

class NavWrapper extends StatelessWidget {
  final Widget child;
  final int currentIndex;
  final Function(int) onNavTap;
  final VoidCallback onRecordTap;
  final VoidCallback onRecordSwipeUp;

  const NavWrapper({
    Key? key,
    required this.child,
    required this.currentIndex,
    required this.onNavTap,
    required this.onRecordTap,
    required this.onRecordSwipeUp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main content
        child,
        
        // Floating Record Button
        FloatingRecordButton(
          onTap: onRecordTap,
          onSwipeUp: onRecordSwipeUp,
        ),
        
        // Bottom Nav Bar
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: BottomNavBar(
            currentIndex: currentIndex,
            onTap: onNavTap,
          ),
        ),
      ],
    );
  }
}