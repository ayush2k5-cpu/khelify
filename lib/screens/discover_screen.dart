import 'package:flutter/material.dart';
import '../themes/app_theme.dart';

class DiscoverScreen extends StatefulWidget {
  final String userRole;

  const DiscoverScreen({required this.userRole});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  String selectedSport = 'All Sports';
  final List<String> sports = [
    'All Sports',
    'Cricket',
    'Badminton',
    'Basketball',
    'Tennis',
    'Football'
  ];

  final List<Map<String, dynamic>> athletes = [
    {
      'name': 'Ravi Kumar',
      'sport': 'Cricket',
      'skill': 'Fast Bowling',
      'score': 9.2,
      'views': 1240,
      'rank': 12
    },
    {
      'name': 'Priya Singh',
      'sport': 'Badminton',
      'skill': 'Smash Shot',
      'score': 8.9,
      'views': 856,
      'rank': 28
    },
    {
      'name': 'Arjun Patel',
      'sport': 'Basketball',
      'skill': '3-Point Shot',
      'score': 9.5,
      'views': 2145,
      'rank': 8
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userRole == 'athlete' ? 'Explore' : 'Browse Talent'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 48,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: sports.length,
                itemBuilder: (context, index) {
                  final sport = sports[index];
                  final isSelected = selectedSport == sport;
                  return Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(sport),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          selectedSport = sport;
                        });
                      },
                      backgroundColor: Color(0xFF1A1A1A),
                      selectedColor: AppTheme.red.withOpacity(0.2),
                      side: BorderSide(
                        color: isSelected
                            ? AppTheme.red
                            : AppTheme.teal.withOpacity(0.2),
                        width: 1.5,
                      ),
                      labelStyle: TextStyle(
                        color: isSelected ? AppTheme.red : AppTheme.textMuted,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: athletes
                    .map((athlete) => _buildAthleteCard(athlete))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAthleteCard(Map<String, dynamic> athlete) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.red.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.red.withOpacity(0.1),
            blurRadius: 8,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2A1A1A), Color(0xFF1A1A1A)],
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [AppTheme.red, AppTheme.teal],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        athlete['name'][0],
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          athlete['name'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.creamLight,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${athlete['sport']} • ${athlete['skill']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.teal,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.creamLight.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.creamLight, width: 1),
                    ),
                    child: Text(
                      '#${athlete['rank']}',
                      style: TextStyle(
                        color: AppTheme.creamLight,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 180,
              color: AppTheme.black,
              child: Center(
                child: Icon(
                  Icons.play_circle_outline,
                  size: 56,
                  color: AppTheme.red,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Score',
                            style: TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${athlete['score']}/10',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.teal,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Views',
                            style: TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${athlete['views']}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      if (widget.userRole == 'recruiter')
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {},
                            child: Text('View Profile'),
                          ),
                        ),
                      if (widget.userRole == 'recruiter') SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text(widget.userRole == 'recruiter' ? 'Contact' : 'Follow'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}