import 'package:flutter/material.dart';
import '../themes/khelify_theme.dart';

class RecordModalSheet extends StatelessWidget {
  const RecordModalSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: KhelifyColors.darkGrey,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'RECORD ASSESSMENT',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          
          // Sport Selection
          _buildSectionHeader('SELECT SPORT'),
          _buildSportGrid(),
          
          SizedBox(height: 20),
          
          // Drill Selection
          _buildSectionHeader('SELECT DRILL'),
          _buildDrillList(),
          
          Spacer(),
          
          // Start Recording Button
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () {
                // This will open camera for recording
                _startRecording(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: KhelifyColors.sapphireBlue,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                'START RECORDING',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        title,
        style: TextStyle(
          color: KhelifyColors.textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSportGrid() {
    final sports = ['Football', 'Basketball', 'Cricket', 'Tennis', 'Badminton', 'Athletics'];
    
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 15),
        itemCount: sports.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(right: 12),
            child: Column(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: KhelifyColors.mediumGrey,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: index == 0 ? KhelifyColors.championGold : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.sports_soccer,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  sports[index],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDrillList() {
    final drills = [
      {'name': '40m Sprint', 'duration': '10s', 'difficulty': 'Medium'},
      {'name': '100m Sprint', 'duration': '20s', 'difficulty': 'Hard'},
      {'name': 'Agility Ladder', 'duration': '15s', 'difficulty': 'Easy'},
      {'name': 'Ball Control', 'duration': '20s', 'difficulty': 'Medium'},
    ];
    
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 15),
        itemCount: drills.length,
        itemBuilder: (context, index) {
          final drill = drills[index];
          return Container(
            margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: KhelifyColors.mediumGrey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: KhelifyColors.sapphireBlue.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.play_arrow,
                    color: KhelifyColors.sapphireBlue,
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        drill['name']!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${drill['duration']} • ${drill['difficulty']}',
                        style: TextStyle(
                          color: KhelifyColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: KhelifyColors.textSecondary,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _startRecording(BuildContext context) {
    // Close the modal first
    Navigator.pop(context);
    
    // Then open camera (you'll need to implement camera functionality)
    // For now, show a dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: KhelifyColors.darkGrey,
        title: Text(
          'Camera Ready!',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Camera functionality will be implemented here.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: TextStyle(color: KhelifyColors.sapphireBlue)),
          ),
        ],
      ),
    );
  }
}