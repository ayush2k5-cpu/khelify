import 'package:flutter/material.dart';

class ExploreConnectionsScreen extends StatelessWidget {
  const ExploreConnectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy invitation data
    final invitations = [
      {
        'name': 'Florjan Juhasz',
        'avatarUrl': 'https://randomuser.me/api/portraits/men/75.jpg',
        'subtitle': 'Student at Peqjna University',
      },
      {
        'name': 'adigun oluwatosin',
        'avatarUrl': 'https://randomuser.me/api/portraits/men/51.jpg',
        'subtitle': 'Advanced diploma at Covenant Institute',
      },
      {
        'name': 'Sarah Roberts',
        'avatarUrl': 'https://randomuser.me/api/portraits/women/57.jpg',
        'subtitle': 'Regional Human Resources Director',
      },
    ];

    // Dummy People suggestions data
    final people = [
      {
        'name': 'Henry Ford',
        'avatarUrl': 'https://randomuser.me/api/portraits/men/22.jpg',
        'subtitle': 'Recruiter | Helping healthcare...',
        'connections': 34,
      },
      {
        'name': 'Stephanie Smith',
        'avatarUrl': 'https://randomuser.me/api/portraits/women/32.jpg',
        'subtitle': "We're Hiring!",
        'connections': 8,
      },
      {
        'name': 'William Able',
        'avatarUrl': 'https://randomuser.me/api/portraits/men/36.jpg',
        'subtitle': "Scrum Servant Leader",
        'connections': 2,
      },
      {
        'name': 'Jason Porsche',
        'avatarUrl': 'https://randomuser.me/api/portraits/men/40.jpg',
        'subtitle': "Brand Strategist",
        'connections': 2,
      },
      {
        'name': 'Andrada Miller',
        'avatarUrl': 'https://randomuser.me/api/portraits/women/48.jpg',
        'subtitle': "#FlavoredWriting Freelancer",
        'connections': 35,
      },
      {
        'name': 'Deanna Geller',
        'avatarUrl': 'https://randomuser.me/api/portraits/women/57.jpg',
        'subtitle': "Columnist and Writer",
        'connections': 3,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Connect",
            style:
                TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0.3,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Invitations section
          if (invitations.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Invitations (${invitations.length})",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Colors.black87,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        child: const Text("Manage all",
                            style: TextStyle(fontWeight: FontWeight.w500)),
                      )
                    ],
                  ),
                  ...invitations
                      .map((invite) => _InvitationTile(invite))
                      .toList(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text("Show more",
                            style: TextStyle(fontSize: 15, color: Colors.blue)),
                      ),
                    ],
                  )
                ],
              ),
            ),
          const Divider(height: 0, thickness: 1, color: Color(0xFFF1F1F4)),
          // More Suggestions
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 12, 6),
            child: Text(
              "More suggestions for you",
              style: TextStyle(
                color: Colors.grey[900],
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: people.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: .74,
              ),
              itemBuilder: (context, i) => _SuggestionCard(person: people[i]),
            ),
          ),
          const SizedBox(height: 18)
        ],
      ),
    );
  }
}

// Widget for invitation tiles at the top
Widget _InvitationTile(Map<String, dynamic> invite) {
  return Container(
    margin: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage(invite['avatarUrl']),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            "${invite['name']}\n${invite['subtitle'] ?? ""}",
            style: const TextStyle(fontSize: 13.7),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        TextButton(
            onPressed: () {},
            child:
                const Text("Ignore", style: TextStyle(color: Colors.black54))),
        ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue.shade600,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              minimumSize: const Size(10, 38),
            ),
            child: const Text("Accept")),
      ],
    ),
  );
}

// Widget for suggestion cards
class _SuggestionCard extends StatelessWidget {
  final Map<String, dynamic> person;
  const _SuggestionCard({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 14, 8, 12),
        child: Column(
          children: [
            CircleAvatar(
              radius: 33,
              backgroundImage: NetworkImage(person['avatarUrl']),
            ),
            const SizedBox(height: 8),
            Text(
              person['name'],
              style:
                  const TextStyle(fontWeight: FontWeight.w700, fontSize: 15.5),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              person['subtitle'] ?? '',
              style: const TextStyle(fontSize: 13, color: Colors.black54),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.supervisor_account,
                    size: 18, color: Colors.grey),
                const SizedBox(width: 3),
                Text(
                  "${person['connections']} mutual connections",
                  style: const TextStyle(fontSize: 12.5, color: Colors.black38),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.blue.shade600),
                    elevation: 0.7,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Connect",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontSize: 13.5))),
            ),
          ],
        ),
      ),
    );
  }
}
