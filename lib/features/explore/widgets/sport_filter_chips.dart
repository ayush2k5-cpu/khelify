import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khelify_app/core/theme/app_colors.dart';
import 'package:khelify_app/core/theme/app_typography.dart';
import '../providers/explore_provider.dart';

class SportFilterChips extends ConsumerWidget {
  const SportFilterChips({super.key});

  static const List<Map<String, String>> _filters = [
    {'label': 'All', 'icon': '🏅'},
    {'label': 'Football', 'icon': '⚽'},
    {'label': 'Badminton', 'icon': '🏸'},
    {'label': 'Athletics', 'icon': '🏃'},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedSportProvider);

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = selected == filter['label'];

          return GestureDetector(
            onTap: () => ref.read(selectedSportProvider.notifier).state =
                filter['label']!,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.blue : AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.blue : AppColors.glassBorder,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(filter['icon']!, style: const TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  Text(
                    filter['label']!,
                    style: AppTypography.label.copyWith(
                      color: isSelected
                          ? AppColors.textOnAction
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
