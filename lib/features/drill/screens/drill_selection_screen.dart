import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/drill_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/widgets/glass_card.dart';
import '../../drill/models/drill.dart';

class DrillSelectionScreen extends ConsumerStatefulWidget {
  const DrillSelectionScreen({super.key});

  @override
  ConsumerState<DrillSelectionScreen> createState() => _DrillSelectionScreenState();
}

class _DrillSelectionScreenState extends ConsumerState<DrillSelectionScreen> {
  String _selectedSport = DrillConstants.sports.first;

  @override
  Widget build(BuildContext context) {
    final drills = DrillConstants.getDrillsBySport(_selectedSport);

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(decoration: const BoxDecoration(gradient: AppGradients.background)),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      Text("Choose Your Drill", style: AppTypography.h1),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Sport Tabs
                  _buildSportTabs(),
                  const SizedBox(height: 24),

                  // Drill List
                  Expanded(
                    child: ListView.builder(
                      itemCount: drills.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildDrillCard(drills[index]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSportTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: DrillConstants.sports.map((sport) {
          final isSelected = sport == _selectedSport;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => setState(() => _selectedSport = sport),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  gradient: isSelected ? AppGradients.blue : null,
                  color: isSelected ? null : AppColors.glassFill,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isSelected ? Colors.transparent : AppColors.glassBorder,
                  ),
                ),
                child: Text(
                  sport,
                  style: AppTypography.h3.copyWith(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDrillCard(Drill drill) {
    return GlassCard(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/drill/record',
          arguments: drill,
        );
      },
      child: Row(
        children: [
          // Icon
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.glassFillStrong,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(drill.icon, style: const TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(width: 16),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(drill.name, style: AppTypography.h3),
                const SizedBox(height: 4),
                Text(drill.category, style: AppTypography.bodySmall),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _difficultyChip(drill.difficulty),
                    const SizedBox(width: 8),
                    Text(
                      '${drill.estimatedDuration.inSeconds}s',
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Arrow
          Icon(Icons.chevron_right, color: AppColors.textTertiary),
        ],
      ),
    );
  }

  Widget _difficultyChip(String difficulty) {
    Color color;
    switch (difficulty) {
      case 'beginner':
        color = AppColors.beginner;
        break;
      case 'intermediate':
        color = AppColors.pro;
        break;
      case 'advanced':
        color = AppColors.error;
        break;
      default:
        color = AppColors.textTertiary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        difficulty.toUpperCase(),
        style: AppTypography.label.copyWith(color: color, fontSize: 10),
      ),
    );
  }
}
