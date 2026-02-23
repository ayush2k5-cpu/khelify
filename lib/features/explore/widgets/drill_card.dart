import 'package:flutter/material.dart';
import 'package:khelify_app/core/theme/app_colors.dart';
import 'package:khelify_app/core/theme/app_typography.dart';
import 'package:khelify_app/features/drill/models/drill.dart';

class DrillCard extends StatelessWidget {
  final Drill drill;
  final VoidCallback? onTap;

  const DrillCard({super.key, required this.drill, this.onTap});

  Color _difficultyColor(String difficulty) {
    switch (difficulty) {
      case 'advanced':
        return AppColors.warning;
      case 'intermediate':
        return AppColors.blue;
      default:
        return AppColors.success; // beginner
    }
  }

  String _sportIcon(String sport) {
    switch (sport) {
      case 'Football':
        return '⚽';
      case 'Badminton':
        return '🏸';
      case 'Athletics':
        return '🏃';
      default:
        return '🏅';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.glassBorder, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: drill icon + sport badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(drill.icon, style: const TextStyle(fontSize: 28)),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.glassFill,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.glassBorder, width: 1),
                  ),
                  child: Text(
                    '${_sportIcon(drill.sport)} ${drill.sport}',
                    style: AppTypography.bodySmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Drill name
            Text(drill.name, style: AppTypography.h3),
            const SizedBox(height: 4),

            // Category
            Text(drill.category, style: AppTypography.bodySmall),
            const SizedBox(height: 8),

            // Description
            Text(
              drill.description,
              style: AppTypography.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),

            // Bottom row: difficulty + duration
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _difficultyColor(drill.difficulty).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    drill.difficulty.toUpperCase(),
                    style: AppTypography.label.copyWith(
                      color: _difficultyColor(drill.difficulty),
                    ),
                  ),
                ),
                Text(
                  '${drill.estimatedDuration.inSeconds}s',
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
