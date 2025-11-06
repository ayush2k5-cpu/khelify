import 'package:flutter/material.dart';
import '../themes/app_theme.dart';

class RecordScreen extends StatefulWidget {
  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  String selectedSport = 'Cricket';
  String selectedSkill = 'Batting';
  final TextEditingController descriptionController = TextEditingController();

  final Map<String, List<String>> sportSkills = {
    'Cricket': ['Batting', 'Bowling', 'Fielding'],
    'Badminton': ['Smash', 'Clear', 'Drop Shot'],
    'Basketball': ['Shooting', 'Dribbling', 'Defense'],
    'Tennis': ['Serve', 'Forehand', 'Backhand'],
    'Football': ['Shooting', 'Dribbling', 'Passing'],
  };

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Record Assessment'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ScaleTransition(
              scale: Tween<double>(begin: 0.95, end: 1).animate(
                CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
              ),
              child: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Camera integration coming soon!')),
                  );
                },
                child: Container(
                  height: 280,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF2A1A1A), Color(0xFF1A1A1A)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppTheme.red.withOpacity(0.3),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.red.withOpacity(0.2),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.red.withOpacity(0.1),
                          border: Border.all(
                            color: AppTheme.red,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.videocam,
                          size: 56,
                          color: AppTheme.red,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Tap to Record',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.creamLight,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Hold for up to 60 seconds',
                        style: TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 32),
            Text(
              'Sport',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppTheme.creamLight,
              ),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.red.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedSport,
                  isExpanded: true,
                  dropdownColor: Color(0xFF1A1A1A),
                  style: TextStyle(
                    color: AppTheme.red,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                  items: sportSkills.keys.map((sport) {
                    return DropdownMenuItem(
                      value: sport,
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(sport),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSport = value!;
                      selectedSkill = sportSkills[value]![0];
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Skill',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppTheme.creamLight,
              ),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.red.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedSkill,
                  isExpanded: true,
                  dropdownColor: Color(0xFF1A1A1A),
                  style: TextStyle(
                    color: AppTheme.red,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                  items: sportSkills[selectedSport]!.map((skill) {
                    return DropdownMenuItem(
                      value: skill,
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(skill),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSkill = value!;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Description',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppTheme.creamLight,
              ),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.red.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: TextField(
                controller: descriptionController,
                maxLines: 4,
                style: TextStyle(color: AppTheme.creamLight),
                decoration: InputDecoration(
                  hintText: 'Describe your assessment...',
                  hintStyle: TextStyle(color: AppTheme.textMuted),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
            ),
            SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Assessment submitted! 🎉'),
                      backgroundColor: AppTheme.red,
                    ),
                  );
                },
                child: Text('Submit Assessment'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}