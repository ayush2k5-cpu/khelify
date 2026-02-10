import 'package:flutter/material.dart';

class AppGradients {
  static const LinearGradient blue = LinearGradient(
    colors: [Color(0xFF1E90FF), Color(0xFF0F52BA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient gold = LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFFFB800)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient background = LinearGradient(
    colors: [Color(0xFF0A0E1A), Color(0xFF131829)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  static const LinearGradient glass = LinearGradient(
    colors: [
      Color(0x1AFFFFFF), // 10% white
      Color(0x0DFFFFFF), // 5% white
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
