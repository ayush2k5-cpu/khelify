import 'package:flutter/material.dart';

class GlassHeader extends StatelessWidget {
  const GlassHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.9),
            Colors.black.withOpacity(0.7),
            Colors.black.withOpacity(0.3),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // LEFT: Profile Avatar (Twitter style)
            GestureDetector(
              onTap: () {},
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: ClipOval(
                  child: Icon(
                    Icons.person_outline,
                    color: Colors.white.withOpacity(0.9),
                    size: 20,
                  ),
                ),
              ),
            ),
            
            // CENTER: App Icon (use any Material icon you want)
            Icon(
              Icons.sports_soccer, // change to your favorite Material icon
              color: Color(0xFFFFD700),
              size: 32,
            ),
            
            // RIGHT: Twitter-style icons
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.search_outlined,
                    color: Colors.white.withOpacity(0.9),
                    size: 22,
                  ),
                  onPressed: () {},
                  splashRadius: 20,
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: Icon(
                    Icons.chat_bubble_outline,
                    color: Colors.white.withOpacity(0.9),
                    size: 22,
                  ),
                  onPressed: () {},
                  splashRadius: 20,
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: Icon(
                    Icons.notifications_none_outlined,
                    color: Colors.white.withOpacity(0.9),
                    size: 22,
                  ),
                  onPressed: () {},
                  splashRadius: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
