import 'package:flutter/material.dart';

class GlassHeader extends StatelessWidget {
  const GlassHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left: Profile Icon
              IconButton(
                icon: const Icon(Icons.person_outline, size: 26),
                color: Colors.black87,
                onPressed: () {},
              ),
              // Center: Sports Icon
              const Icon(
                Icons.sports_soccer, // Soccer ball icon
                size: 32,
                color: Colors.black87,
              ),
              // Right: Action Icons
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.search, size: 26),
                    color: Colors.black87,
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined, size: 26),
                    color: Colors.black87,
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
