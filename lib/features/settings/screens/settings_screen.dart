import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/widgets/glass_card.dart';
import '../../auth/providers/auth_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.background),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text('Settings', style: AppTypography.h1),
                const SizedBox(height: 4),
                Text(
                  'Customize your experience',
                  style: AppTypography.bodyMedium
                      .copyWith(color: AppColors.textTertiary),
                ),
                const SizedBox(height: 28),

                // ── Account Section ──
                _SectionHeader(title: 'Account'),
                const SizedBox(height: 12),
                GlassCard(
                  child: Column(
                    children: [
                      _SettingsTile(
                        icon: Icons.person_outline_rounded,
                        title: 'Edit Profile',
                        subtitle: 'Name, photo, sport preference',
                        onTap: () => Navigator.pushNamed(context, '/profile/edit'),
                      ),
                      _Divider(),
                      _SettingsTile(
                        icon: Icons.shield_outlined,
                        title: 'Privacy',
                        subtitle: 'Profile visibility, data sharing',
                        onTap: () => _showComingSoon(context),
                      ),
                      _Divider(),
                      _SettingsTile(
                        icon: Icons.lock_outline_rounded,
                        title: 'Change Password',
                        subtitle: 'Update your account password',
                        onTap: () => _showComingSoon(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ── Preferences Section ──
                _SectionHeader(title: 'Preferences'),
                const SizedBox(height: 12),
                GlassCard(
                  child: Column(
                    children: [
                      _SettingsToggle(
                        icon: Icons.notifications_none_rounded,
                        title: 'Push Notifications',
                        subtitle: 'Drill reminders & achievements',
                        value: true,
                        onChanged: (_) => _showComingSoon(context),
                      ),
                      _Divider(),
                      _SettingsToggle(
                        icon: Icons.vibration_rounded,
                        title: 'Haptic Feedback',
                        subtitle: 'Vibrate during drill scoring',
                        value: true,
                        onChanged: (_) => _showComingSoon(context),
                      ),
                      _Divider(),
                      _SettingsTile(
                        icon: Icons.language_rounded,
                        title: 'Language',
                        subtitle: 'English',
                        onTap: () => _showComingSoon(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ── About Section ──
                _SectionHeader(title: 'About'),
                const SizedBox(height: 12),
                GlassCard(
                  child: Column(
                    children: [
                      _SettingsTile(
                        icon: Icons.info_outline_rounded,
                        title: 'App Version',
                        subtitle: '1.0.0 (MVP)',
                        onTap: () {},
                      ),
                      _Divider(),
                      _SettingsTile(
                        icon: Icons.description_outlined,
                        title: 'Terms of Service',
                        onTap: () => _showComingSoon(context),
                      ),
                      _Divider(),
                      _SettingsTile(
                        icon: Icons.privacy_tip_outlined,
                        title: 'Privacy Policy',
                        onTap: () => _showComingSoon(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // ── Logout Button ──
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          backgroundColor: AppColors.surface,
                          title: Text('Log Out', style: AppTypography.h2),
                          content: Text(
                            'Are you sure you want to log out?',
                            style: AppTypography.bodyMedium,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: Text('Cancel',
                                  style: AppTypography.bodyMedium
                                      .copyWith(color: AppColors.textTertiary)),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: Text('Log Out',
                                  style: AppTypography.bodyMedium
                                      .copyWith(color: AppColors.error)),
                            ),
                          ],
                        ),
                      );
                      if (confirmed == true) {
                        await ref.read(authServiceProvider).signOut();
                        if (context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/', (_) => false);
                        }
                      }
                    },
                    icon: const Icon(Icons.logout_rounded, color: AppColors.error),
                    label: Text('Log Out',
                        style: AppTypography.button.copyWith(color: AppColors.error)),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.error.withOpacity(0.4)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Coming soon!')),
    );
  }
}

// ── Helper widgets (private to this file) ──────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: AppTypography.label.copyWith(
        color: AppColors.textTertiary,
        letterSpacing: 1.5,
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.glassFill,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.blue, size: 20),
      ),
      title: Text(title, style: AppTypography.h3.copyWith(fontSize: 15)),
      subtitle: subtitle != null
          ? Text(subtitle!,
              style: AppTypography.bodySmall
                  .copyWith(color: AppColors.textTertiary))
          : null,
      trailing: Icon(Icons.chevron_right_rounded,
          color: AppColors.textTertiary, size: 20),
      onTap: onTap,
    );
  }
}

class _SettingsToggle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsToggle({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.glassFill,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.blue, size: 20),
      ),
      title: Text(title, style: AppTypography.h3.copyWith(fontSize: 15)),
      subtitle: subtitle != null
          ? Text(subtitle!,
              style: AppTypography.bodySmall
                  .copyWith(color: AppColors.textTertiary))
          : null,
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.blue,
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 0.5,
      color: AppColors.glassBorder,
    );
  }
}
