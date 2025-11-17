import 'package:flutter/material.dart';
import '../services/mock_data_service.dart';

class FollowSuggestionCard extends StatelessWidget {
  final List<Map<String, String>> suggestions;

  const FollowSuggestionCard({super.key, required this.suggestions});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.grey[900]!.withOpacity(0.92),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.13),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Suggested for you',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.2,
                ),
              ),
              const Spacer(),
              Icon(Icons.close, size: 20, color: Colors.grey[400]),
            ],
          ),
          const SizedBox(height: 13),
          SizedBox(
            height: 116,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: suggestions.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                final suggestion = suggestions[index];
                return _InstagramSuggestionItem(
                  name: suggestion['name'] ?? 'User',
                  emoji: suggestion['emoji'] ?? '👤',
                  index: index,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _InstagramSuggestionItem extends StatelessWidget {
  final String name;
  final String emoji;
  final int index;

  const _InstagramSuggestionItem({
    required this.name,
    required this.emoji,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final gradients = [
      [Color(0xFFF58529), Color(0xFFDD2A7B), Color(0xFF8134AF), Color(0xFF515BD4)],
      [Color(0xFF4DEDFE), Color(0xFF38B6FF), Color(0xFF6248FE), Color(0xFFCB2D3E)],
      [Color(0xFFFFB56B), Color(0xFFD72660), Color(0xFF6A82FB), Color(0xFFFC5C7D)],
      [Color(0xFF42E695), Color(0xFF3BB2B8), Color(0xFF8360C3), Color(0xFF2EBF91)],
    ];
    final g = gradients[index % gradients.length];

    return SizedBox(
      width: 73,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: g,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.1, 0.5, 0.7, 1],
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.3),
              ),
              child: Center(
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 22),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.1,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          const SizedBox(height: 6),
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              // Your follow action here
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFDD2A7B), Color(0xFFF58529)],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.pink.withOpacity(0.18),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Text(
                'Follow',
                style: TextStyle(
                  fontSize: 10.5,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
