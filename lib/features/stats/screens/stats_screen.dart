import 'package:flutter/material.dart';
import 'package:khelify_app/core/theme/app_colors.dart';
import 'package:khelify_app/core/theme/app_typography.dart';
import 'package:lucide_icons/lucide_icons.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your Stats', style: AppTypography.h1),
              const SizedBox(height: 24),

              // Mock Highlights
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard('Total Drills', '42', LucideIcons.activity),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard('Avg Score', '82.0', LucideIcons.trendingUp),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard('Best Score', '95.5', LucideIcons.award),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard('Rank', 'Elite', LucideIcons.medal),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              Text('Recent Performance', style: AppTypography.h2),
              const SizedBox(height: 16),
              
              // Mock Chart Placeholder
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LucideIcons.barChart, size: 48, color: AppColors.blue),
                      const SizedBox(height: 12),
                      Text('Performance Trend', style: AppTypography.bodyMedium),
                      const SizedBox(height: 4),
                      Text('+15% improvement this week', 
                        style: AppTypography.bodySmall.copyWith(color: AppColors.success)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
              Text('Top Skills', style: AppTypography.h2),
              const SizedBox(height: 12),
              _buildSkillBar('Knee Drive', 92, AppColors.blue),
              const SizedBox(height: 12),
              _buildSkillBar('Arm Swing', 85, AppColors.success),
              const SizedBox(height: 12),
              _buildSkillBar('Balance', 78, AppColors.warning),
              const SizedBox(height: 100), // Bottom padding for FAB/Nav
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: AppColors.blue),
          const SizedBox(height: 12),
          Text(value, style: AppTypography.h1.copyWith(fontSize: 24)),
          const SizedBox(height: 4),
          Text(title, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildSkillBar(String skill, int percentage, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(skill, style: AppTypography.bodyMedium),
            Text('$percentage%', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percentage / 100,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
