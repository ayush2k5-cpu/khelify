// 1. Dart/Flutter SDK
import 'package:flutter/material.dart';

// 2. External packages
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 3. App imports — core first
import 'package:khelify_app/core/models/user_model.dart';
import 'package:khelify_app/core/theme/app_colors.dart';
import 'package:khelify_app/core/theme/app_typography.dart';
import 'package:khelify_app/core/theme/app_gradients.dart';
import 'package:khelify_app/features/auth/providers/auth_provider.dart';

// 4. Relative imports — same feature
import '../providers/profile_provider.dart';
// import 'edit_profile_screen.dart'; ← uncomment after next file

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authUser = ref.read(currentUserProvider);
      if (authUser != null) {
        ref.read(profileProvider.notifier).loadProfile(authUser.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: switch (profileState) {
        ProfileLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
        ProfileError(:final message) => Center(
            child: Text(
              message,
              style: AppTypography.bodyMedium,
            ),
          ),
        ProfileLoaded(:final user) => _buildProfile(user),
        _ => const SizedBox.shrink(),
      },
    );
  }

  Widget _buildProfile(UserModel user) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // ── Top Section ──────────────────────────────
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: AppGradients.blue,
            ),
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 32),
            child: Column(
              children: [
                // Avatar with camera overlay
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.surface,
                      backgroundImage: user.avatarUrl != null
                          ? NetworkImage(user.avatarUrl!)
                          : null,
                      child: user.avatarUrl == null
                          ? const Icon(Icons.person,
                              size: 50, color: Colors.white)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: AppColors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt,
                            size: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Display name
                Text(user.displayName, style: AppTypography.h2),
                const SizedBox(height: 8),
                // Sport badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    user.sport.toUpperCase(),
                    style: AppTypography.button,
                  ),
                ),
              ],
            ),
          ),

          // ── Stats Row ────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStat('Total Drills', '${user.totalDrills}'),
                _buildDivider(),
                _buildStat('Best Score', user.bestScore.toStringAsFixed(1)),
                _buildDivider(),
                _buildStat('Tier', user.tier.toUpperCase()),
              ],
            ),
          ),

          // ── Action Buttons ───────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      // TODO: uncomment after edit_profile_screen.dart is created
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (_) => EditProfileScreen(user: user),
                      //   ),
                      // );
                    },
                    child: Text('Edit Profile', style: AppTypography.button),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.blue),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      // R2's settings screen — coordinate later
                    },
                    child: Text('Settings', style: AppTypography.button),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: AppTypography.h2),
        const SizedBox(height: 4),
        Text(label, style: AppTypography.bodySmall),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: AppColors.surface,
    );
  }
}
