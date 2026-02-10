import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds
  static const Color background = Color(0xFF0A0E1A);
  static const Color surface = Color(0xFF131829);
  static const Color surfaceLight = Color(0xFF1C2237);

  // Blue (Primary Action / Brand)
  static const Color blue = Color(0xFF2872A1);
  static const Color blueLight = Color(0xFF1E90FF);
  static const Color blueDark = Color(0xFF0F52BA);

  // Gold (Elite / Achievement Only)
  static const Color gold = Color(0xFFFFD700);
  static const Color goldLight = Color(0xFFFFE44D);
  static const Color goldDark = Color(0xFFFFB800);

  // Semantic
  static const Color success = Color(0xFF00E676);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFFF5252);

  // Tiers
  static const Color elite = Color(0xFFFFD700);
  static const Color pro = Color(0xFF1E90FF);
  static const Color advanced = Color(0xFFC0C0C0);
  static const Color beginner = Color(0xFF4CAF50);

  // Text
  static Color textPrimary = const Color(0xFFFFFFFF).withOpacity(0.95);
  static Color textSecondary = const Color(0xFFFFFFFF).withOpacity(0.60);
  static Color textTertiary = const Color(0xFFFFFFFF).withOpacity(0.35);
  static const Color textOnAction = Color(0xFFFFFFFF);
  static const Color textOnGold = Color(0xFF0A0E1A);

  // Glass
  static Color glassFill = const Color(0xFFFFFFFF).withOpacity(0.08);
  static Color glassFillStrong = const Color(0xFFFFFFFF).withOpacity(0.15);
  static Color glassBorder = const Color(0xFFFFFFFF).withOpacity(0.12);
  static Color glassBorderActive = const Color(0xFFFFFFFF).withOpacity(0.25);
  static Color glassBorderGold = const Color(0xFFFFD700).withOpacity(0.30);
  static Color glassBorderBlue = const Color(0xFF2872A1).withOpacity(0.30);
}
