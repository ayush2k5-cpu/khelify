import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khelify_app/core/theme/app_colors.dart';
import 'package:khelify_app/core/theme/app_typography.dart';
import '../providers/explore_provider.dart';
import '../widgets/drill_card.dart';
import '../widgets/sport_filter_chips.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drills = ref.watch(filteredDrillsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              child: Text('Explore Drills', style: AppTypography.h1),
            ),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Search drills...',
                  hintStyle: AppTypography.bodyMedium,
                  prefixIcon: Icon(Icons.search,
                      color: AppColors.textSecondary, size: 20),
                  filled: true,
                  fillColor: AppColors.surface,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: AppColors.glassBorder, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: AppColors.glassBorder, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: AppColors.blue, width: 1.5),
                  ),
                ),
                onChanged: (value) =>
                    ref.read(searchQueryProvider.notifier).state = value,
              ),
            ),
            const SizedBox(height: 14),

            // Sport filter chips
            const SportFilterChips(),
            const SizedBox(height: 16),

            // Drill count label
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '${drills.length} drill${drills.length == 1 ? '' : 's'} found',
                style: AppTypography.bodySmall,
              ),
            ),
            const SizedBox(height: 10),

            // Drill grid
            Expanded(
              child: drills.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🔍', style: TextStyle(fontSize: 40)),
                          const SizedBox(height: 12),
                          Text('No drills found',
                              style: AppTypography.bodyMedium),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.72,
                      ),
                      itemCount: drills.length,
                      itemBuilder: (context, index) => DrillCard(
                        drill: drills[index],
                        onTap: () {
                          // TODO: navigate to drill detail / recording screen
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
