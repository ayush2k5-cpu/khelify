import 'package:flutter/material.dart';

class AppTheme {
  // Final vibrant 5-color palette
  static const Color red = Color(0xFFC0301E);              // Primary RED energy
  static const Color black = Color(0xFF000000);            // Dark backgrounds
  static const Color creamLight = Color(0xFFF6DA9D);       // Bright cream accents
  static const Color creamDark = Color(0xFFD7C9AA);        // Warm cream text
  static const Color teal = Color(0xFF0BA475);             // Teal accent pops
  
  static const Color textLight = Color(0xFFFAFBFF);
  static const Color textMuted = Color(0xFF8B94A8);

  static ThemeData premiumDarkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: black,
    primaryColor: red,
    appBarTheme: AppBarTheme(
      backgroundColor: black,
      foregroundColor: creamLight,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: creamLight,
        letterSpacing: 0.5,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: red,
        foregroundColor: creamLight,
        elevation: 8,
        shadowColor: red.withOpacity(0.5),
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: red,
        side: BorderSide(color: red, width: 2),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1A1A1A),
      selectedItemColor: red,
      unselectedItemColor: textMuted,
      elevation: 16,
      type: BottomNavigationBarType.fixed,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.w900,
        color: creamLight,
        letterSpacing: -1,
      ),
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: creamLight,
        letterSpacing: -0.5,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: creamLight,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: creamDark,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textMuted,
      ),
    ),
  );

  static Widget buildPatternOverlay({double opacity = 0.08}) {
    return Positioned.fill(
      child: Opacity(
        opacity: opacity,
        child: CustomPaint(
          painter: SubtlePatternPainter(),
        ),
      ),
    );
  }
}

class SubtlePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFF0BA475).withOpacity(0.5)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    final path = Path();
    
    path.moveTo(0, size.height * 0.3);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.25,
      size.width * 0.5,
      size.height * 0.3,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.35,
      size.width,
      size.height * 0.3,
    );

    path.moveTo(0, size.height * 0.7);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.65,
      size.width * 0.5,
      size.height * 0.7,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.75,
      size.width,
      size.height * 0.7,
    );

    for (int i = 0; i < 8; i++) {
      final x = (size.width / 8) * i;
      final y = (size.height / 8) * (i % 3);
      canvas.drawCircle(Offset(x, y), 1.5, paint);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(SubtlePatternPainter oldDelegate) => false;
}