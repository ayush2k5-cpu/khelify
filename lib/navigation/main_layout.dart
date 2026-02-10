import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_gradients.dart';
import '../core/theme/app_typography.dart';
import '../features/feed/screens/feed_screen.dart';

/// Main app shell with bottom navigation and FAB for drill recording.
class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  // Screens for each tab
  final List<Widget> _screens = [
    const FeedScreen(),     // 0: Feed
    _PlaceholderScreen(title: 'Explore', icon: LucideIcons.compass),    // 1: Explore
    const SizedBox(),       // 2: Record (placeholder — FAB handles this)
    _PlaceholderScreen(title: 'Stats', icon: LucideIcons.barChart3),    // 3: Stats
    _PlaceholderScreen(title: 'Profile', icon: LucideIcons.user),       // 4: Profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentIndex == 2 ? 0 : _currentIndex, // Skip record tab
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: _buildRecordFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildBottomNav() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 64 + MediaQuery.of(context).padding.bottom,
          decoration: BoxDecoration(
            color: AppColors.surface.withOpacity(0.9),
            border: Border(
              top: BorderSide(color: Colors.white.withOpacity(0.08)),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(0, LucideIcons.home, 'Feed'),
              _navItem(1, LucideIcons.compass, 'Explore'),
              const SizedBox(width: 56), // Space for FAB
              _navItem(3, LucideIcons.barChart3, 'Stats'),
              _navItem(4, LucideIcons.user, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isActive ? AppColors.blue : Colors.white.withOpacity(0.35),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.label.copyWith(
                fontSize: 10,
                color: isActive ? AppColors.blue : Colors.white.withOpacity(0.35),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordFAB() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppGradients.blue,
        boxShadow: [
          BoxShadow(
            color: AppColors.blueDark.withOpacity(0.4),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/drill/select');
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: const CircleBorder(),
        child: const Icon(Icons.fiber_manual_record_rounded, color: Colors.white, size: 28),
      ),
    );
  }
}

/// Simple placeholder screen for tabs that aren't built yet.
class _PlaceholderScreen extends StatelessWidget {
  final String title;
  final IconData icon;

  const _PlaceholderScreen({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: AppColors.textTertiary),
            const SizedBox(height: 16),
            Text(title, style: AppTypography.h2.copyWith(color: AppColors.textTertiary)),
            const SizedBox(height: 8),
            Text('Coming soon', style: AppTypography.bodySmall),
          ],
        ),
      ),
    );
  }
}
