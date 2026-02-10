import 'package:flutter/material.dart';

class AthleteCard extends StatelessWidget {
  final String name;
  final String role;
  final String subtitle;
  final int connections;
  final String avatarUrl;
  final VoidCallback onConnect;

  const AthleteCard({
    super.key,
    required this.name,
    required this.role,
    required this.subtitle,
    required this.connections,
    required this.avatarUrl,
    required this.onConnect,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
      elevation: 1.7,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(11, 14, 11, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: 38,
                  backgroundImage: NetworkImage(avatarUrl),
                  backgroundColor: Colors.orange[50],
                ),
                Positioned(
                  right: -7,
                  top: -7,
                  child: ClipOval(
                    child: Material(
                      color: Colors.grey.shade200,
                      child: InkWell(
                        onTap: () {},
                        child: const Padding(
                          padding: EdgeInsets.all(3),
                          child: Icon(Icons.close,
                              size: 18, color: Colors.black38),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              "$connections Shared Connections",
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onConnect,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0.5,
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                child: const Text("Connect"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
