import 'package:flutter/material.dart';
import '../themes/khelify_theme.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 8),
        children: [
          _buildSectionHeader('Account'),
          _buildSettingsTile(
            icon: Icons.account_circle_outlined,
            title: 'Account Settings',
            subtitle: 'Manage your account',
            onTap: () {},
          ),
          _buildSettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy',
            subtitle: 'Control your privacy',
            onTap: () {},
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(
              color: AppTheme.red.withOpacity(0.1),
              indent: 16,
              endIndent: 16,
            ),
          ),
          _buildSectionHeader('App'),
          _buildSettingsTile(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            subtitle: 'Manage notifications',
            onTap: () {},
          ),
          _buildSettingsTile(
            icon: Icons.language,
            title: 'Language',
            subtitle: 'Choose language',
            onTap: () {},
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(
              color: AppTheme.red.withOpacity(0.1),
              indent: 16,
              endIndent: 16,
            ),
          ),
          _buildSectionHeader('About'),
          _buildSettingsTile(
            icon: Icons.info_outlined,
            title: 'About Khelify',
            subtitle: 'Version 1.0.0',
            onTap: () {},
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: ElevatedButton(
              onPressed: () {},
              child: Text('Logout'),
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: AppTheme.red,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.teal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: AppTheme.teal.withOpacity(0.3), width: 1),
                ),
                child: Icon(icon, color: AppTheme.teal, size: 22),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.creamLight,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right,
                  color: AppTheme.red.withOpacity(0.4)),
            ],
          ),
        ),
      ),
    );
  }
}