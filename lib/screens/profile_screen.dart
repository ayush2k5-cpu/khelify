import 'package:flutter/material.dart';
import '../themes/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  final String userRole;

  const ProfileScreen({required this.userRole});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(icon: Icon(Icons.edit), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppTheme.red.withOpacity(0.2),
                  width: 1,
                ),
              ),
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [AppTheme.red, AppTheme.teal],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.red.withOpacity(0.5),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: AppTheme.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Your Name',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.creamLight,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.teal.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.teal, width: 1.5),
                    ),
                    child: Text(
                      userRole == 'athlete'
                          ? '⚽ Cricket • All-Rounder'
                          : '🎯 Sports Scout',
                      style: TextStyle(
                        color: AppTheme.teal,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  if (userRole == 'athlete') ...[
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildProfileStat('Followers', '1.2K'),
                        Container(
                          width: 1,
                          height: 40,
                          color: AppTheme.red.withOpacity(0.2),
                        ),
                        _buildProfileStat('Score', '8.7'),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 24),
            if (userRole == 'athlete') ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'My Assessments',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.creamLight,
                  ),
                ),
              ),
              SizedBox(height: 12),
              Column(
                children: List.generate(3, (index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.red.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppTheme.black,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppTheme.red.withOpacity(0.4),
                              width: 1,
                            ),
                          ),
                          child: Icon(Icons.play_arrow, color: AppTheme.red),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Assessment ${index + 1}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.creamLight,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '${3 - index} days ago',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${8.5 + (index * 0.1)}',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: AppTheme.red,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ] else ...[
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.red.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildRecruiterStat('Viewed', '234'),
                    Container(
                      width: 1,
                      height: 60,
                      color: AppTheme.red.withOpacity(0.2),
                    ),
                    _buildRecruiterStat('Contacted', '12'),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProfileStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppTheme.red,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildRecruiterStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppTheme.red,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.textMuted,
          ),
        ),
      ],
    );
  }
}