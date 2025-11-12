import 'package:flutter/material.dart';

class KhelifyFeedCard extends StatelessWidget {
  const KhelifyFeedCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18, vertical: 17),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFa27f53), Color(0xFF927252)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.white.withOpacity(0.23),
          width: 1.7,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.13),
            blurRadius: 22,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.person, color: Colors.white, size: 28),
                ),
                SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Sarah Johnson",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.5),
                          ),
                          SizedBox(width: 5),
                          Icon(Icons.verified, color: Colors.blue, size: 17),
                        ],
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Elite Athlete • 2h",
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.77),
                            fontSize: 12.2,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.more_vert, color: Colors.white.withOpacity(0.62)),
              ],
            ),
            SizedBox(height: 17),
            // Main content
            Text(
              "Crushed my 40m sprint today! 🔥\nNew PR: 5.9s (-0.4s improvement)\nFeeling unstoppable! 💪",
              style: TextStyle(
                fontSize: 15.5,
                color: Colors.white,
                fontWeight: FontWeight.w500,
                height: 1.34,
              ),
            ),
            SizedBox(height: 15),
            // Media
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    "https://images.unsplash.com/photo-1464983953574-0892a716854b?fit=crop&w=600&q=80",
                    height: 185,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 26,
                  child: Icon(Icons.play_arrow, color: Colors.blue, size: 34),
                ),
                Positioned(
                  bottom: 10,
                  right: 15,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.54),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "0:15",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 13),
            // Badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 13, vertical: 6),
              decoration: BoxDecoration(
                color: Color(0xffffd700).withOpacity(0.11),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Color(0xffffd700), width: 1.2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.flash_on, color: Color(0xffffd700), size: 17),
                  SizedBox(width: 7),
                  Text("40m Sprint",
                      style: TextStyle(
                          color: Color(0xffffd700),
                          fontSize: 14.1,
                          fontWeight: FontWeight.bold)),
                  SizedBox(width: 8),
                  Text("•", style: TextStyle(color: Color(0xffffd700))),
                  SizedBox(width: 8),
                  Text("87", style: TextStyle(color: Color(0xffffd700))),
                  SizedBox(width: 8),
                  Text("•", style: TextStyle(color: Color(0xffffd700))),
                  SizedBox(width: 8),
                  Text("ELITE", style: TextStyle(color: Color(0xffffd700))),
                ],
              ),
            ),
            SizedBox(height: 10),
            // Actions
            Row(
              children: [
                Icon(Icons.favorite_border, color: Colors.white.withOpacity(0.83), size: 22),
                SizedBox(width: 4),
                Text("124", style: TextStyle(color: Colors.white70, fontSize: 15)),
                SizedBox(width: 28),
                Icon(Icons.mode_comment_outlined, color: Colors.white.withOpacity(0.73), size: 21),
                SizedBox(width: 4),
                Text("18", style: TextStyle(color: Colors.white60, fontSize: 15)),
                SizedBox(width: 28),
                Icon(Icons.sync, color: Colors.white.withOpacity(0.68), size: 20),
                SizedBox(width: 4),
                Text("7", style: TextStyle(color: Colors.white54, fontSize: 15)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
