import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_gradients.dart';
import '../models/drill.dart';
import '../services/pose_analysis_service.dart';
import '../services/scoring_service.dart';
import '../widgets/pose_painter.dart';

class DrillRecordingScreen extends ConsumerStatefulWidget {
  final Drill drill;
  const DrillRecordingScreen({super.key, required this.drill});

  @override
  ConsumerState<DrillRecordingScreen> createState() => _DrillRecordingScreenState();
}

class _DrillRecordingScreenState extends ConsumerState<DrillRecordingScreen>
    with TickerProviderStateMixin {
  CameraController? _cameraController;
  CameraDescription? _cameraDescription;
  final PoseAnalysisService _poseService = PoseAnalysisService();

  // State
  bool _isInitialized = false;
  bool _isRecording = false;
  bool _isCountingDown = false;
  int _countdown = 3;
  List<Pose> _currentPoses = [];
  final List<List<Pose>> _allPoseFrames = [];
  Timer? _recordingTimer;
  int _elapsedSeconds = 0;

  // Animation
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      _cameraDescription = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        _cameraDescription!,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      _poseService.initialize();

      if (mounted) {
        setState(() => _isInitialized = true);
      }
    } catch (e) {
      debugPrint('Camera init error: $e');
    }
  }

  Future<void> _startCountdown() async {
    setState(() {
      _isCountingDown = true;
      _countdown = 3;
    });

    for (int i = 3; i > 0; i--) {
      if (!mounted) return;
      setState(() => _countdown = i);
      await Future.delayed(const Duration(seconds: 1));
    }

    if (mounted) {
      setState(() => _isCountingDown = false);
      _startRecording();
    }
  }

  void _startRecording() {
    setState(() {
      _isRecording = true;
      _elapsedSeconds = 0;
      _allPoseFrames.clear();
    });

    // Start pose detection stream
    _cameraController!.startImageStream((image) async {
      if (!_isRecording || _cameraDescription == null) return;

      final poses = await _poseService.processFrame(image, _cameraDescription!);
      if (mounted && _isRecording) {
        setState(() => _currentPoses = poses);
        if (poses.isNotEmpty) {
          _allPoseFrames.add(poses);
        }
      }
    });

    // Timer for elapsed time
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() => _elapsedSeconds++);

        // Auto-stop after drill duration + 5 seconds buffer
        if (_elapsedSeconds >= widget.drill.estimatedDuration.inSeconds + 5) {
          _stopRecording();
        }
      }
    });
  }

  Future<void> _stopRecording() async {
    _recordingTimer?.cancel();

    try {
      await _cameraController?.stopImageStream();
    } catch (_) {}

    if (!mounted) return;

    setState(() => _isRecording = false);

    // Calculate score
    final result = ScoringService.evaluate(_allPoseFrames, widget.drill);

    if (mounted) {
      Navigator.pushReplacementNamed(
        context,
        '/drill/results',
        arguments: {
          'drill': widget.drill,
          'scoringResult': result,
          'duration': _elapsedSeconds,
        },
      );
    }
  }

  @override
  void dispose() {
    _recordingTimer?.cancel();
    _pulseController.dispose();
    _cameraController?.dispose();
    _poseService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || _cameraController == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: const Center(child: CircularProgressIndicator(color: AppColors.blue)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Camera Preview
          CameraPreview(_cameraController!),

          // Pose Overlay
          if (_currentPoses.isNotEmpty && _isRecording)
            CustomPaint(
              painter: PosePainter(
                poses: _currentPoses,
                absoluteImageSize: Size(
                  _cameraController!.value.previewSize!.height,
                  _cameraController!.value.previewSize!.width,
                ),
                rotation: _cameraDescription!.sensorOrientation,
                isFrontCamera: _cameraDescription!.lensDirection == CameraLensDirection.front,
              ),
            ),

          // Countdown Overlay
          if (_isCountingDown)
            Container(
              color: Colors.black.withOpacity(0.6),
              child: Center(
                child: Text(
                  '$_countdown',
                  style: AppTypography.displayLarge.copyWith(
                    fontSize: 96,
                    color: AppColors.blueLight,
                  ),
                ),
              ),
            ),

          // Top Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back Button
                    if (!_isRecording)
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close, color: Colors.white),
                        ),
                      )
                    else
                      const SizedBox(width: 40),

                    // Drill Name + Timer
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Text(widget.drill.icon, style: const TextStyle(fontSize: 18)),
                          const SizedBox(width: 8),
                          Text(widget.drill.name, style: AppTypography.h3.copyWith(fontSize: 14)),
                          if (_isRecording) ...[
                            const SizedBox(width: 12),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.error,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _formatTime(_elapsedSeconds),
                              style: AppTypography.h3.copyWith(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(width: 40), // Balance
                  ],
                ),
              ),
            ),
          ),

          // Bottom Controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Pose Detection Status
                    if (_isRecording)
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: _currentPoses.isNotEmpty
                              ? AppColors.success.withOpacity(0.2)
                              : AppColors.warning.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _currentPoses.isNotEmpty
                                ? AppColors.success.withOpacity(0.5)
                                : AppColors.warning.withOpacity(0.5),
                          ),
                        ),
                        child: Text(
                          _currentPoses.isNotEmpty
                              ? 'Tracking ${_currentPoses.length} pose(s) ✓'
                              : 'Looking for your body...',
                          style: AppTypography.bodySmall.copyWith(
                            color: _currentPoses.isNotEmpty
                                ? AppColors.success
                                : AppColors.warning,
                          ),
                        ),
                      ),

                    // Record / Stop Button
                    GestureDetector(
                      onTap: () {
                        if (_isRecording) {
                          _stopRecording();
                        } else if (!_isCountingDown) {
                          _startCountdown();
                        }
                      },
                      child: AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          final scale = _isRecording
                              ? 1.0
                              : 1.0 + (_pulseController.value * 0.05);
                          return Transform.scale(
                            scale: scale,
                            child: Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: _isRecording ? null : AppGradients.blue,
                                color: _isRecording ? AppColors.error : null,
                                boxShadow: [
                                  BoxShadow(
                                    color: (_isRecording ? AppColors.error : AppColors.blueDark)
                                        .withOpacity(0.4),
                                    blurRadius: 16,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Icon(
                                _isRecording ? Icons.stop_rounded : Icons.fiber_manual_record_rounded,
                                color: Colors.white,
                                size: 36,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 8),
                    Text(
                      _isRecording ? 'TAP TO STOP' : 'TAP TO START',
                      style: AppTypography.label.copyWith(color: AppColors.textTertiary),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
