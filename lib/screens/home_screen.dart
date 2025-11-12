import 'package:flutter/material.dart';
import '../widgets/khelify_feed_card.dart';
import '../widgets/glass_header.dart';  // Import your header widget

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const GlassHeader(),  // Add the top section here
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) => const KhelifyFeedCard(),
            ),
          ),
        ],
      ),
    );
  }
}
