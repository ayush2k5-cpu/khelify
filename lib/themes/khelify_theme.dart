import 'package:flutter/material.dart';

class KhelifyColors {
  static const Color scaffoldBackground = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF1E1E1E);  // You can remove or replace if not used

  static const Color sapphireBlue = Color(0xFF0F52BA);
  static const Color championGold = Color(0xFFFFD700);
  static const Color errorRed = Color(0xFFF44336);
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color warningOrange = Color(0xFFFF9800);
  static const Color persianRed = Color(0xFFC93631);

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  static const Color textPrimary = Color(0xFF222E42);
  static const Color textSecondary = Color(0xFF6C7A89);
  static const Color textTertiary = Color(0xFFB0BEC5);

  static const Color border = Color(0xFFE0E0E0);

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFFFB800)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient blueGradient = LinearGradient(
    colors: [Color(0xFF1E90FF), Color(0xFF0F52BA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class KhelifyTypography {
  static const TextStyle displayLarge = TextStyle(fontSize: 36, fontWeight: FontWeight.bold);
  static const TextStyle heading1 = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
  static const TextStyle heading2 = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  static const TextStyle heading3 = TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
  static const TextStyle bodyLarge = TextStyle(fontSize: 16);
  static const TextStyle bodyMedium = TextStyle(fontSize: 14);
  static const TextStyle bodySmall = TextStyle(fontSize: 12);
  static const TextStyle button = TextStyle(fontSize: 14, fontWeight: FontWeight.bold);
}

class KhelifyTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: KhelifyColors.scaffoldBackground,
    colorScheme: ColorScheme.light(
      primary: KhelifyColors.sapphireBlue,
      secondary: KhelifyColors.championGold,
      error: KhelifyColors.errorRed,
      surface: KhelifyColors.cardLight,
      onPrimary: KhelifyColors.white,
      onSecondary: KhelifyColors.black,
      onSurface: KhelifyColors.textPrimary,
    ),
    textTheme: const TextTheme(
      displayLarge: KhelifyTypography.displayLarge,
      headlineLarge: KhelifyTypography.heading1,
      headlineMedium: KhelifyTypography.heading2,
      headlineSmall: KhelifyTypography.heading3,
      bodyLarge: KhelifyTypography.bodyLarge,
      bodyMedium: KhelifyTypography.bodyMedium,
      bodySmall: KhelifyTypography.bodySmall,
      labelLarge: KhelifyTypography.button,
    ),
    cardColor: KhelifyColors.cardLight,
    dividerColor: KhelifyColors.border,
    appBarTheme: const AppBarTheme(
      backgroundColor: KhelifyColors.white,
      foregroundColor: KhelifyColors.black,
      elevation: 1,
      iconTheme: IconThemeData(color: KhelifyColors.black),
    ),
  );
}
