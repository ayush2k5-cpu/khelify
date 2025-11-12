import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ══════════════════════════════════════════════════════════
// KHELIFY COLOR SYSTEM V1.0
// Blue-Red-Gold Premium Theme
// ══════════════════════════════════════════════════════════

class KhelifyColors {
  // ========== BACKGROUNDS ==========
  static const Color scaffoldBackground = Color(0xFF000000);
  static const Color cardDark = Color(0xFF0D1117);
  static const Color inputBackground = Color(0xFF141414);
  
  // ========== BLUES (Primary - 30%) ==========
  static const Color darkCerulean = Color(0xFF08457E);
  static const Color sapphireBlue = Color(0xFF0F52BA);
  static const Color electricBlue = Color(0xFF1E90FF);
  static const Color iceBlue = Color(0xFF4FC3F7);
  
  // ========== REDS (Energy - 15%) ==========
  static const Color persianRed = Color(0xFFC93631);
  static const Color sangria = Color(0xFF8E020A);
  
  // ========== GOLD (Premium - 15%) ==========
  static const Color championGold = Color(0xFFFFD700);
  
  // ========== GREYS & TEXT (35%) ==========
  static const Color white = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0BEC5);
  static const Color textTertiary = Color(0xFF6C7A89);
  static const Color border = Color(0xFF1F2937);
  
  // ========== STATUS COLORS (5%) ==========
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color warningOrange = Color(0xFFFF9800);
  static const Color errorRed = Color(0xFFF44336);
  static const Color onlineGreen = Color(0xFF00E676);
  
  // ========== GLASS EFFECTS ==========
  static const Color glassBackground = Color(0x1AFFFFFF); // 10% white
  static const Color glassBorder = Color(0x33FFFFFF);     // 20% white
  
  // ========== GRADIENTS ==========
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
  
  static const LinearGradient redGradient = LinearGradient(
    colors: [Color(0xFFC93631), Color(0xFF8E020A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

// ══════════════════════════════════════════════════════════
// TYPOGRAPHY SYSTEM
// ══════════════════════════════════════════════════════════

class KhelifyTypography {
  // Display (Hero text)
  static TextStyle displayLarge = GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w900,
    color: KhelifyColors.white,
    height: 1.1,
    letterSpacing: -1,
  );
  
  // Headings
  static TextStyle heading1 = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: KhelifyColors.white,
  );
  
  static TextStyle heading2 = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: KhelifyColors.white,
  );
  
  static TextStyle heading3 = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: KhelifyColors.white,
  );
  
  // Body
  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: KhelifyColors.white,
    height: 1.5,
  );
  
  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: KhelifyColors.white,
    height: 1.5,
  );
  
  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: KhelifyColors.textSecondary,
    height: 1.5,
  );
  
  // Special
  static TextStyle caption = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: KhelifyColors.textTertiary,
  );
  
  static TextStyle button = GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: KhelifyColors.white,
    letterSpacing: 0.5,
  );
  
  static TextStyle stats = GoogleFonts.spaceGrotesk(
    fontSize: 48,
    fontWeight: FontWeight.w900,
    color: KhelifyColors.white,
    letterSpacing: -2,
  );
}

// ══════════════════════════════════════════════════════════
// GLASS EFFECTS
// ══════════════════════════════════════════════════════════

class KhelifyGlass {
  static BoxDecoration standard({double blur = 10}) {
    return BoxDecoration(
      color: KhelifyColors.glassBackground,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: KhelifyColors.glassBorder,
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 20,
          spreadRadius: -5,
        ),
      ],
    );
  }
  
  static BoxDecoration goldBorder() {
    return BoxDecoration(
      color: KhelifyColors.glassBackground,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: KhelifyColors.championGold,
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: KhelifyColors.championGold.withOpacity(0.3),
          blurRadius: 30,
          spreadRadius: 0,
        ),
      ],
    );
  }
  
  static BoxDecoration blueBorder() {
    return BoxDecoration(
      color: KhelifyColors.glassBackground,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: KhelifyColors.sapphireBlue,
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: KhelifyColors.sapphireBlue.withOpacity(0.3),
          blurRadius: 20,
          spreadRadius: 0,
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════
// THEME DATA
// ══════════════════════════════════════════════════════════

class KhelifyTheme {
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: KhelifyColors.scaffoldBackground,

    colorScheme: ColorScheme.dark(
      primary: KhelifyColors.sapphireBlue,
      secondary: KhelifyColors.championGold,
      error: KhelifyColors.errorRed,
      surface: KhelifyColors.cardDark,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.white,
    ),

    textTheme: TextTheme(
      displayLarge: KhelifyTypography.displayLarge,
      headlineLarge: KhelifyTypography.heading1,
      headlineMedium: KhelifyTypography.heading2,
      headlineSmall: KhelifyTypography.heading3,
      bodyLarge: KhelifyTypography.bodyLarge,
      bodyMedium: KhelifyTypography.bodyMedium,
      bodySmall: KhelifyTypography.bodySmall,
      labelLarge: KhelifyTypography.button,
    ),
  );
}

// Legacy AppTheme class for backward compatibility
class AppTheme {
  static const Color black = KhelifyColors.scaffoldBackground;
  static const Color creamLight = KhelifyColors.white;
  static const Color red = KhelifyColors.persianRed;
  static const Color teal = KhelifyColors.electricBlue;
  static const Color textMuted = KhelifyColors.textSecondary;

  static ThemeData get premiumDarkTheme => KhelifyTheme.darkTheme;

  static Widget buildPatternOverlay({required double opacity}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(opacity),
      ),
    );
  }
}
