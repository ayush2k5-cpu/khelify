import 'dart:ui';
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
      child: ClipPath(
        clipper: _NavBarClipper(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.5),
                    Colors.black.withOpacity(0.4),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: Colors.white.withOpacity(0.15),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(Icons.home_rounded, 0),
                  _buildNavItem(Icons.explore_rounded, 1),
                  const SizedBox(width: 60), // Space for center button
                  _buildNavItem(Icons.people_rounded, 3),
                  _buildNavItem(Icons.bar_chart_rounded, 4),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF9fe7f5).withOpacity(0.25)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: AnimatedScale(
          scale: isSelected ? 1.15 : 1.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Icon(
            icon,
            color: isSelected
                ? const Color(0xFF9fe7f5)
                : Colors.white.withOpacity(0.6),
            size: 28,
          ),
        ),
      ),
    );
  }
}

// Smooth Custom Clipper for Center Cutout
class _NavBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    const cutoutRadius = 40.0;
    final cutoutCenter = size.width / 2;

    path.moveTo(0, 0);
    path.lineTo(cutoutCenter - cutoutRadius - 12, 0);

    // Smooth curved cutout
    path.cubicTo(
      cutoutCenter - cutoutRadius - 12,
      0,
      cutoutCenter - cutoutRadius - 5,
      5,
      cutoutCenter - cutoutRadius,
      12,
    );

    path.arcToPoint(
      Offset(cutoutCenter + cutoutRadius, 12),
      radius: const Radius.circular(cutoutRadius),
      clockwise: false,
    );

    path.cubicTo(
      cutoutCenter + cutoutRadius + 5,
      5,
      cutoutCenter + cutoutRadius + 12,
      0,
      cutoutCenter + cutoutRadius + 12,
      0,
    );

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
