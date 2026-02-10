import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class TierConstants {
  static const Map<String, TierInfo> tiers = {
    'elite': TierInfo(
      name: 'Elite',
      icon: '🏆',
      minScore: 90,
      maxScore: 100,
      color: AppColors.elite,
    ),
    'pro': TierInfo(
      name: 'Pro',
      icon: '⚡',
      minScore: 75,
      maxScore: 89,
      color: AppColors.pro,
    ),
    'advanced': TierInfo(
      name: 'Advanced',
      icon: '🎯',
      minScore: 60,
      maxScore: 74,
      color: AppColors.advanced,
    ),
    'beginner': TierInfo(
      name: 'Beginner',
      icon: '🌱',
      minScore: 0,
      maxScore: 59,
      color: AppColors.beginner,
    ),
  };

  static TierInfo getTierInfo(String tier) {
    return tiers[tier] ?? tiers['beginner']!;
  }

  static TierInfo getTierFromScore(int score) {
    if (score >= 90) return tiers['elite']!;
    if (score >= 75) return tiers['pro']!;
    if (score >= 60) return tiers['advanced']!;
    return tiers['beginner']!;
  }
}

class TierInfo {
  final String name;
  final String icon;
  final int minScore;
  final int maxScore;
  final Color color;

  const TierInfo({
    required this.name,
    required this.icon,
    required this.minScore,
    required this.maxScore,
    required this.color,
  });
}
