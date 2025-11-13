import 'package:flutter/material.dart';
import '../themes/app_theme.dart';
import '../services/video_upload_service.dart';
import '../services/ai_analysis_service.dart';
import 'package:image_picker/image_picker.dart';

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
  
  // New state variables for AI integration
  bool _isRecording = false;
  bool _isUploading = false;
  bool _isAnalyzing = false;
  Map<String, dynamic>? _analysisResults;
  String? _videoUrl;

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

  Future<void> _recordVideo() async {
    final ImagePicker picker = ImagePicker();
    
    try {
      setState(() {
        _isRecording = true;
      });

      // For web, we'll use a different approach since File isn't available
      // We'll simulate the process for now
      await _simulateVideoProcessing();
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Recording simulation: $e')),
      );
    } finally {
      setState(() {
        _isRecording = false;
      });
    }
  }

  // Simulate the video processing for web demo
  Future<void> _simulateVideoProcessing() async {
    try {
      setState(() {
        _isUploading = true;
      });

      // Simulate upload delay
      await Future.delayed(Duration(seconds: 2));
      
      // For web demo, we'll use a mock video URL
      String mockVideoUrl = 'https://example.com/mock_video_${DateTime.now().millisecondsSinceEpoch}.mp4';
      
      setState(() {
        _isUploading = false;
        _isAnalyzing = true;
      });

      // Simulate AI analysis delay
      await Future.delayed(Duration(seconds: 3));

      // Use mock analysis results for web demo
      final mockResults = {
        "success": true,
        "results": {
          "drill_type": _getDrillType(),
          "status": "analysis_completed",
          "key_metrics": {
            "estimated_jump_height_cm": 42.5,
            "technique_score": 0.78,
            "frames_analyzed": 45,
            "analysis": "Web demo - Good form detected"
          }
        }
      };

      setState(() {
        _analysisResults = mockResults;
        _isAnalyzing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Demo Analysis completed! (Web Simulation)'),
          backgroundColor: Colors.green,
        ),
      );

    } catch (e) {
      setState(() {
        _isUploading = false;
        _isAnalyzing = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Demo failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _getDrillType() {
    // Map sport+skill to specific drill types
    if (selectedSport == 'Basketball' && selectedSkill == 'Shooting') {
      return 'vertical_jump';
    } else if (selectedSport == 'Football' && selectedSkill == 'Shooting') {
      return 'sprint';
    }
    return 'vertical_jump'; // Default
  }

  void _submitAssessment() {
    if (_analysisResults == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please record and analyze a video first!')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Assessment submitted with AI analysis! 🎉'),
        backgroundColor: AppTheme.red,
      ),
    );
  }

  Widget _buildRecordButton() {
    if (_isRecording) {
      return _buildLoadingState('Recording...', Icons.videocam);
    } else if (_isUploading) {
      return _buildLoadingState('Uploading...', Icons.cloud_upload);
    } else if (_isAnalyzing) {
      return _buildLoadingState('AI Analyzing...', Icons.psychology);
    }

    return ScaleTransition(
      scale: Tween<double>(begin: 0.95, end: 1).animate(
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
      ),
      child: GestureDetector(
        onTap: _recordVideo,
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
                'Tap to Record (Web Demo)',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.creamLight,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Simulated workflow for web testing',
                style: TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState(String text, IconData icon) {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.red.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.red),
          ),
          SizedBox(height: 20),
          Icon(icon, size: 40, color: AppTheme.red),
          SizedBox(height: 10),
          Text(
            text,
            style: TextStyle(
              color: AppTheme.creamLight,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsSection() {
    if (_analysisResults == null) return SizedBox();

    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📊 AI Analysis Results (Web Demo)',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Drill: ${_analysisResults!['results']?['drill_type'] ?? 'N/A'}',
            style: TextStyle(color: AppTheme.creamLight),
          ),
          Text(
            'Jump Height: ${_analysisResults!['results']?['key_metrics']?['estimated_jump_height_cm'] ?? 'N/A'} cm',
            style: TextStyle(color: AppTheme.creamLight),
          ),
          Text(
            'Technique Score: ${_analysisResults!['results']?['key_metrics']?['technique_score'] ?? 'N/A'}',
            style: TextStyle(color: AppTheme.creamLight),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Record Assessment (Web Demo)'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRecordButton(),
            
            SizedBox(height: 20),
            _buildResultsSection(),
            
            // ... rest of your existing form fields
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
                      _analysisResults = null;
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
            
            SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _submitAssessment,
                child: Text('Submit Assessment'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}