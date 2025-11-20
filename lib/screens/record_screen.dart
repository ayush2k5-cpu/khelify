import 'package:flutter/material.dart';
import '../models/post.dart';

class RecordScreen extends StatefulWidget {
  final Drill? selectedDrill;
  
  const RecordScreen({Key? key, this.selectedDrill}) : super(key: key);

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  String selectedSport = 'Football';
  String selectedSkill = 'Shooting';
  final TextEditingController descriptionController = TextEditingController();
  
  // State variables
  bool _isRecording = false;
  bool _isUploading = false;
  bool _isAnalyzing = false;
  Map<String, dynamic>? _analysisResults;
  String? _videoUrl;

  final Map<String, List<String>> sportSkills = {
    'Football': ['Shooting', 'Dribbling', 'Passing'],
    'Cricket': ['Batting', 'Bowling', 'Fielding'],
    'Badminton': ['Smash', 'Clear', 'Drop Shot'],
    'Basketball': ['Shooting', 'Dribbling', 'Defense'],
    'Tennis': ['Serve', 'Forehand', 'Backhand'],
  };

  @override
  void initState() {
    super.initState();
    print('🎬 DEBUG: RecordScreen initState called');
    print('🎬 DEBUG: Selected Drill: ${widget.selectedDrill?.name}');
    print('🎬 DEBUG: Selected Drill Sport: ${widget.selectedDrill?.sport}');
    
    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    // AUTO-SELECT BASED ON DRILL
    if (widget.selectedDrill != null) {
      _autoSelectDrill();
    }
  }

  void _autoSelectDrill() {
    if (widget.selectedDrill != null) {
      print('🎬 DEBUG: Auto-selecting drill: ${widget.selectedDrill!.name}');
      setState(() {
        selectedSport = widget.selectedDrill!.sport;
        selectedSkill = _mapDrillToSkill(widget.selectedDrill!);
      });
      print('🎬 DEBUG: Auto-selected - Sport: $selectedSport, Skill: $selectedSkill');
    }
  }

  String _mapDrillToSkill(Drill drill) {
    final drillName = drill.name.toLowerCase();
    print('🎬 DEBUG: Mapping drill to skill: $drillName');
    
    if (drillName.contains('sprint') || drillName.contains('40m') || drillName.contains('100m')) {
      return 'Shooting';
    } else if (drillName.contains('jump') || drillName.contains('vertical')) {
      return 'Shooting';
    } else if (drillName.contains('batting')) {
      return 'Batting';
    } else if (drillName.contains('bowling')) {
      return 'Bowling';
    } else if (drillName.contains('smash')) {
      return 'Smash';
    } else if (drillName.contains('clear')) {
      return 'Clear';
    } else if (drillName.contains('dribbling') || drillName.contains('dribble')) {
      return 'Dribbling';
    } else if (drillName.contains('passing') || drillName.contains('pass')) {
      return 'Passing';
    } else {
      return sportSkills[drill.sport]?.first ?? 'Shooting';
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  // SIMULATED RECORDING FUNCTIONALITY
  Future<void> _recordVideo() async {
    try {
      print('🎬 DEBUG: Starting video recording for drill: ${widget.selectedDrill?.name}');
      
      setState(() {
        _isRecording = true;
      });

      // Simulate recording process
      await Future.delayed(Duration(seconds: 2));

      setState(() {
        _isRecording = false;
        _isUploading = true;
      });

      // Simulate upload process
      await Future.delayed(Duration(seconds: 2));

      setState(() {
        _isUploading = false;
        _isAnalyzing = true;
      });

      // Simulate AI analysis
      await Future.delayed(Duration(seconds: 3));

      setState(() {
        _isAnalyzing = false;
        _analysisResults = {
          'results': {
            'drill_type': widget.selectedDrill?.name ?? 'Vertical Jump',
            'key_metrics': {
              'estimated_jump_height_cm': '68.5',
              'technique_score': '87/100',
              'power_output': 'High',
              'consistency': 'Good'
            },
            'feedback': [
              'Great explosive power!',
              'Work on landing technique',
              'Excellent knee drive'
            ]
          }
        };
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ AI Analysis completed for ${widget.selectedDrill?.name}!'),
          backgroundColor: Colors.green,
        ),
      );

    } catch (e) {
      print('🎬 DEBUG: Recording error: $e');
      setState(() {
        _isRecording = false;
        _isUploading = false;
        _isAnalyzing = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Recording failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // SIMULATED UPLOAD FUNCTIONALITY
  Future<void> _uploadExistingVideo() async {
    try {
      print('🎬 DEBUG: Uploading existing video for drill: ${widget.selectedDrill?.name}');
      
      setState(() {
        _isUploading = true;
      });

      // Simulate upload process
      await Future.delayed(Duration(seconds: 2));

      setState(() {
        _isUploading = false;
        _isAnalyzing = true;
      });

      // Simulate AI analysis
      await Future.delayed(Duration(seconds: 3));

      setState(() {
        _isAnalyzing = false;
        _analysisResults = {
          'results': {
            'drill_type': widget.selectedDrill?.name ?? 'Vertical Jump',
            'key_metrics': {
              'estimated_jump_height_cm': '72.1',
              'technique_score': '92/100',
              'power_output': 'Excellent',
              'consistency': 'Very Good'
            },
            'feedback': [
              'Outstanding technique!',
              'Perfect landing form',
              'Elite level performance'
            ]
          }
        };
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Video analyzed successfully for ${widget.selectedDrill?.name}!'),
          backgroundColor: Colors.green,
        ),
      );

    } catch (e) {
      print('🎬 DEBUG: Upload error: $e');
      setState(() {
        _isUploading = false;
        _isAnalyzing = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Upload failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _submitAssessment() {
    if (_analysisResults == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please record and analyze a video first!')),
      );
      return;
    }

    print('🎬 DEBUG: Submitting assessment for drill: ${widget.selectedDrill?.name}');
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.selectedDrill?.name} assessment submitted with AI analysis! 🎉'),
        backgroundColor: Color(0xFFFFD700),
      ),
    );

    // Navigate back after submission
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }

  Widget _buildDrillInfo() {
    if (widget.selectedDrill == null) {
      return Container();
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Color(0xFF1E3A8A).withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF4A90E2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SELECTED DRILL',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF4A90E2),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            widget.selectedDrill!.name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4),
          Text(
            '${widget.selectedDrill!.sport} • ${widget.selectedDrill!.estimatedDuration}s • ${widget.selectedDrill!.difficulty}',
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
        ],
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

    return Column(
      children: [
        _buildDrillInfo(),
        
        // RECORD NEW VIDEO BUTTON
        ScaleTransition(
          scale: Tween<double>(begin: 0.95, end: 1).animate(
            CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
          ),
          child: GestureDetector(
            onTap: _recordVideo,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2A1A1A), Color(0xFF1A1A1A)],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Color(0xFF4A90E2).withOpacity(0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF4A90E2).withOpacity(0.2),
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
                      color: Color(0xFF4A90E2).withOpacity(0.1),
                      border: Border.all(
                        color: Color(0xFF4A90E2),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.videocam,
                      size: 56,
                      color: Color(0xFF4A90E2),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    widget.selectedDrill != null 
                      ? 'Record: ${widget.selectedDrill!.name}' 
                      : 'Record New Video',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tap to start recording',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        SizedBox(height: 16),
        
        // UPLOAD EXISTING VIDEO BUTTON
        GestureDetector(
          onTap: _uploadExistingVideo,
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: Color(0xFF2C2C2E),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Color(0xFFFFD700).withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.upload,
                  size: 32,
                  color: Color(0xFFFFD700),
                ),
                SizedBox(width: 12),
                Text(
                  'Upload Existing Video',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState(String text, IconData icon) {
    return Column(
      children: [
        _buildDrillInfo(),
        Container(
          height: 280,
          decoration: BoxDecoration(
            color: Color(0xFF2C2C2E),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Color(0xFF4A90E2).withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4A90E2)),
              ),
              SizedBox(height: 20),
              Icon(icon, size: 40, color: Color(0xFF4A90E2)),
              SizedBox(height: 10),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              if (widget.selectedDrill != null) ...[
                SizedBox(height: 10),
                Text(
                  'for ${widget.selectedDrill!.name}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
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
            '📊 AI Analysis Results',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Drill: ${_analysisResults!['results']?['drill_type'] ?? 'N/A'}',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Jump Height: ${_analysisResults!['results']?['key_metrics']?['estimated_jump_height_cm'] ?? 'N/A'} cm',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Technique Score: ${_analysisResults!['results']?['key_metrics']?['technique_score'] ?? 'N/A'}',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Feedback:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          ...(_analysisResults!['results']?['feedback'] as List? ?? []).map((feedback) => 
            Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text('• $feedback', style: TextStyle(color: Colors.white70)),
            )
          ).toList(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('🎬 DEBUG: RecordScreen build method - Selected Drill: ${widget.selectedDrill?.name}');
    
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.selectedDrill != null 
            ? 'Record: ${widget.selectedDrill!.name}'
            : 'Record Assessment',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRecordButton(),
            
            SizedBox(height: 20),
            _buildResultsSection(),
            
            SizedBox(height: 32),
            Text(
              'Sport',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF2C2C2E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedSport,
                  isExpanded: true,
                  dropdownColor: Color(0xFF2C2C2E),
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF4A90E2),
                    fontWeight: FontWeight.bold,
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
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF2C2C2E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedSkill,
                  isExpanded: true,
                  dropdownColor: Color(0xFF2C2C2E),
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF4A90E2),
                    fontWeight: FontWeight.bold,
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4A90E2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Submit Assessment',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}