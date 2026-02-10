import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Color> gradient;
  final bool active;

  const SectionHeader({
    super.key,
    required this.title,
    required this.icon,
    required this.gradient,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: gradient),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: gradient.first.withOpacity(0.35),
                      spreadRadius: 3,
                      blurRadius: 16,
                    )
                  ]
                : [],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
        const SizedBox(width: 13),
        Text(
          title,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w900,
            fontSize: 22,
            foreground: Paint()
              ..shader = LinearGradient(colors: gradient)
                  .createShader(const Rect.fromLTWH(0, 0, 200, 30)),
            letterSpacing: 1.1,
            shadows: [
              Shadow(
                color: gradient.first.withOpacity(0.45),
                blurRadius: 8,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
