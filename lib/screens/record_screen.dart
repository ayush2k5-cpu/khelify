import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/post.dart';
import '../services/ai_analysis_service.dart'; // ← ADD THIS IMPORT

class RecordScreen extends StatefulWidget {
  final Drill? selectedDrill;
  
  const RecordScreen({Key? key, this.selectedDrill}) : super(key: key);

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  
  // Camera & Recording State
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _isRecording = false;
  bool _isUploading = false;
  bool _isAnalyzing = false;
  
  // Video State
  XFile? _videoFile;
  
  // Analysis Results
  Map<String, dynamic>? _analysisResults;
  
  // Animation
  late AnimationController _pulseController;
  
  // Sport/Skill Selection (Preserving original functionality)
  String selectedSport = 'Football';
  String selectedSkill = 'Shooting';
  final TextEditingController descriptionController = TextEditingController();
  
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
    WidgetsBinding.instance.addObserver(this);
    print('🎬 DEBUG: RecordScreen initState called');
    print('🎬 DEBUG: Selected Drill: ${widget.selectedDrill?.name}');
    print('🎬 DEBUG: Selected Drill Sport: ${widget.selectedDrill?.sport}');
    
    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    // AUTO-SELECT BASED ON DRILL (Preserved)
    if (widget.selectedDrill != null) {
      _autoSelectDrill();
    }
    
    // Initialize Camera
    _initializeCamera();
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

  // CAMERA INITIALIZATION - NEW REAL FUNCTIONALITY
  Future<void> _initializeCamera() async {
    try {
      print('📸 Requesting camera permissions...');
      
      // Request permissions
      final cameraStatus = await Permission.camera.request();
      final micStatus = await Permission.microphone.request();
      
      if (!cameraStatus.isGranted || !micStatus.isGranted) {
        print('❌ Permissions denied');
        if (mounted) _showPermissionDialog();
        return;
      }

      print('✅ Permissions granted, initializing camera...');
      
      // Get available cameras
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        print('❌ No cameras found on device');
        if (mounted) _showErrorDialog('No cameras found on this device');
        return;
      }

      print('📸 Found ${_cameras!.length} camera(s)');

      // Initialize back camera (index 0)
      _cameraController = CameraController(
        _cameras![0],
        ResolutionPreset.high,
        enableAudio: true,
      );

      await _cameraController!.initialize();
      
      if (!mounted) return;
      
      setState(() {
        _isCameraInitialized = true;
      });
      
      print('✅ Camera initialized successfully');
    } catch (e) {
      print('❌ Camera initialization error: $e');
      if (mounted) {
        _showErrorDialog('Camera initialization failed: ${e.toString()}');
      }
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF2C2C2E),
        title: Text('Permissions Required', style: TextStyle(color: Colors.white)),
        content: Text(
          'Camera and microphone permissions are required to record videos for your assessments.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: Text('Open Settings', style: TextStyle(color: Color(0xFF4A90E2))),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF2C2C2E),
        title: Text('Error', style: TextStyle(color: Colors.red)),
        content: Text(message, style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: TextStyle(color: Color(0xFF4A90E2))),
          ),
        ],
      ),
    );
  }

  // REAL VIDEO RECORDING FUNCTIONALITY
  Future<void> _recordVideo() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      _showErrorDialog('Camera not ready. Please wait...');
      return;
    }

    if (_isRecording) {
      // STOP RECORDING
      await _stopRecording();
    } else {
      // START RECORDING
      await _startRecording();
    }
  }

  Future<void> _startRecording() async {
    try {
      print('🎬 Starting video recording...');
      
      await _cameraController!.startVideoRecording();
      
      setState(() {
        _isRecording = true;
        _videoFile = null;
        _analysisResults = null;
      });
      
      print('✅ Recording started');
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🔴 Recording started...'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('❌ Error starting recording: $e');
      _showErrorDialog('Failed to start recording: ${e.toString()}');
    }
  }

  Future<void> _stopRecording() async {
    try {
      print('🎬 Stopping video recording...');
      
      final video = await _cameraController!.stopVideoRecording();
      
      setState(() {
        _isRecording = false;
        _videoFile = video;
      });
      
      print('✅ Recording stopped: ${video.path}');
      print('📁 Video size: ${File(video.path).lengthSync()} bytes');
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Recording saved! Analyzing...'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      
      // Auto-analyze after recording
      await _analyzeVideo();
    } catch (e) {
      print('❌ Error stopping recording: $e');
      setState(() {
        _isRecording = false;
      });
      _showErrorDialog('Failed to stop recording: ${e.toString()}');
    }
  }

  // UPLOAD EXISTING VIDEO (Preserved functionality)
  Future<void> _uploadExistingVideo() async {
    try {
      print('📤 Opening gallery to select video...');
      
      final ImagePicker picker = ImagePicker();
      final XFile? video = await picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: Duration(minutes: 2),
      );
      
      if (video == null) {
        print('ℹ️ No video selected');
        return;
      }
      
      print('✅ Video selected: ${video.path}');
      
      setState(() {
        _videoFile = video;
      });
      
      await _analyzeVideo();
    } catch (e) {
      print('❌ Error uploading video: $e');
      _showErrorDialog('Failed to upload video: ${e.toString()}');
    }
  }

  // ⭐ REAL AI ANALYSIS - UPDATED TO USE BACKEND
  Future<void> _analyzeVideo() async {
    if (_videoFile == null) return;
    
    try {
      print('🔍 Starting REAL AI analysis with MediaPipe...');
      
      setState(() {
        _isUploading = true;
      });
      
      await Future.delayed(Duration(milliseconds: 500));
      
      setState(() {
        _isUploading = false;
        _isAnalyzing = true;
      });
      
      // ⭐ CALL REAL AI BACKEND
      final results = await AIAnalysisService.analyzeVideo(
        videoPath: _videoFile!.path,
        drillType: widget.selectedDrill?.name ?? 'Unknown',
      );
      
      setState(() {
        _isAnalyzing = false;
        _analysisResults = {'results': results}; // Wrap in results key
      });
      
      print('✅ Real AI Analysis completed');
      print('📊 Results: $results');
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Real AI Analysis completed for ${widget.selectedDrill?.name ?? "video"}!'),
          backgroundColor: Colors.green,
        ),
      );
      
    } catch (e) {
      print('❌ Analysis error: $e');
      setState(() {
        _isUploading = false;
        _isAnalyzing = false;
      });
      _showErrorDialog('AI analysis failed: ${e.toString()}\n\nMake sure the backend server is running and ngrok URL is correct.');
    }
  }

  // SUBMIT ASSESSMENT (Preserved functionality)
  void _submitAssessment() {
    if (_analysisResults == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please record and analyze a video first!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    print('🎬 DEBUG: Submitting assessment for drill: ${widget.selectedDrill?.name}');
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.selectedDrill?.name ?? "Assessment"} submitted with AI analysis! 🎉'),
        backgroundColor: Color(0xFFFFD700),
      ),
    );

    // Navigate back after submission
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    _pulseController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _cameraController;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }
    
    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  // UI BUILDERS - Preserved with camera preview

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

  Widget _buildCameraPreview() {
    if (!_isCameraInitialized || _cameraController == null) {
      return Container(
        height: 400,
        decoration: BoxDecoration(
          color: Color(0xFF2C2C2E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Color(0xFF4A90E2).withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4A90E2)),
              ),
              SizedBox(height: 16),
              Text(
                'Initializing camera...',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _isRecording ? Colors.red : Color(0xFF4A90E2),
          width: _isRecording ? 4 : 2,
        ),
        boxShadow: _isRecording ? [
          BoxShadow(
            color: Colors.red.withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ] : [],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            CameraPreview(_cameraController!),
            if (_isRecording)
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.fiber_manual_record, color: Colors.white, size: 12),
                      SizedBox(width: 6),
                      Text(
                        'REC',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordButton() {
    if (_isUploading || _isAnalyzing) {
      return _buildLoadingState(
        _isUploading ? 'Uploading...' : 'AI Analyzing...',
        _isUploading ? Icons.cloud_upload : Icons.psychology,
      );
    }

    return Column(
      children: [
        _buildDrillInfo(),
        
        // Camera Preview
        _buildCameraPreview(),
        
        SizedBox(height: 24),
        
        // Record/Upload Controls
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // RECORD BUTTON
            ScaleTransition(
              scale: Tween<double>(begin: 0.95, end: 1.05).animate(
                CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
              ),
              child: GestureDetector(
                onTap: _recordVideo,
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isRecording ? Colors.red : Color(0xFF4A90E2),
                    boxShadow: [
                      BoxShadow(
                        color: (_isRecording ? Colors.red : Color(0xFF4A90E2)).withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    _isRecording ? Icons.stop : Icons.videocam,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            
            // UPLOAD BUTTON
            GestureDetector(
              onTap: _uploadExistingVideo,
              child: Container(
                height: 65,
                width: 65,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFFD700),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFFFD700).withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.upload,
                  size: 30,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        
        SizedBox(height: 16),
        
        // Instructions
        Text(
          _isRecording 
            ? 'Tap stop when done recording' 
            : widget.selectedDrill != null 
              ? 'Record: ${widget.selectedDrill!.name}'
              : 'Tap camera to record or upload existing video',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
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
            'Drill: ${_analysisResults!['results']?['drill_type'] ?? _analysisResults!['results']?['key_metrics']?['note'] ?? 'N/A'}',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Jump Height: ${_analysisResults!['results']?['key_metrics']?['estimated_jump_height_cm'] ?? 'N/A'}',
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
          SizedBox(height: 8),
          Text(
            'Power Output: ${_analysisResults!['results']?['key_metrics']?['power_output'] ?? 'N/A'}',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Consistency: ${_analysisResults!['results']?['key_metrics']?['consistency'] ?? 'N/A'}',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Analysis:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            _analysisResults!['results']?['key_metrics']?['analysis'] ?? 
            _analysisResults!['results']?['status'] ?? 
            'Analysis completed',
            style: TextStyle(color: Colors.white70),
          ),
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
