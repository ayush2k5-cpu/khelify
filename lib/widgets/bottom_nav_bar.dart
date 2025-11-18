import 'dart:ui';
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool isVisible;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.isVisible = true,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 200),
      offset: isVisible ? Offset.zero : const Offset(0, 1),
      curve: Curves.easeInOut,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 16,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Main nav bar with cutout
            ClipPath(
              clipper: _NavBarClipper(),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.15),
                          Colors.white.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 25,
                          spreadRadius: 0,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      top: false,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildNavItem(0, Icons.home_rounded, 'Home'),
                          _buildNavItem(1, Icons.explore_rounded, 'Explore'),
                          const SizedBox(width: 80), // Space for button + cutout
                          _buildNavItem(3, Icons.people_rounded, 'Connect'),
                          _buildNavItem(4, Icons.bar_chart_rounded, 'Stats'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected
                  ? const Color(0xFFFFFFFF)
                  : Colors.white.withOpacity(0.6),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? const Color(0xFFFFFFFF)
                    : Colors.white.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom clipper to create the center cutout
class _NavBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    const cutoutRadius = 38.0; // Radius of the circular cutout
    final cutoutCenter = size.width / 2; // Center X position

    // Start from top-left
    path.moveTo(0, 0);

    // Top edge until the cutout
    path.lineTo(cutoutCenter - cutoutRadius - 10, 0);

    // Create the curved cutout (semicircle notch)
    path.quadraticBezierTo(
      cutoutCenter - cutoutRadius,
      0,
      cutoutCenter - cutoutRadius,
      10,
    );
    
    path.arcToPoint(
      Offset(cutoutCenter + cutoutRadius, 10),
      radius: const Radius.circular(cutoutRadius),
      clockwise: false,
    );
    
    path.quadraticBezierTo(
      cutoutCenter + cutoutRadius,
      0,
      cutoutCenter + cutoutRadius + 10,
      0,
    );

    // Complete the top edge
    path.lineTo(size.width, 0);

    // Right edge
    path.lineTo(size.width, size.height);

    // Bottom edge
    path.lineTo(0, size.height);

    // Close the path
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
