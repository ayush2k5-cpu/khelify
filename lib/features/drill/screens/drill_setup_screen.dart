import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/widgets/glass_card.dart';
import '../models/drill.dart';
import '../services/pose_analysis_service.dart';
import '../widgets/pose_painter.dart';

/// Pre-recording setup screen that ensures the user has correct
/// camera placement, lighting, and body visibility before a drill.
///
/// Flow:  Drill Selection → **DrillSetupScreen** → DrillRecordingScreen
class DrillSetupScreen extends ConsumerStatefulWidget {
  final Drill drill;
  const DrillSetupScreen({super.key, required this.drill});

  @override
  ConsumerState<DrillSetupScreen> createState() => _DrillSetupScreenState();
}

class _DrillSetupScreenState extends ConsumerState<DrillSetupScreen>
    with TickerProviderStateMixin {
  // Camera
  CameraController? _cameraController;
  CameraDescription? _cameraDescription;
  final PoseAnalysisService _poseService = PoseAnalysisService();
  bool _isInitialized = false;

  // Readiness checks
  bool _bodyDetected = false;
  bool _goodConfidence = false;
  int _landmarksVisible = 0;
  double _avgConfidence = 0.0;
  List<Pose> _currentPoses = [];
  Timer? _checkTimer;
  int _consecutiveGoodFrames = 0;

  // Tutorial state
  int _currentStep = 0;
  bool _tutorialComplete = false;
  late AnimationController _pulseController;

  static const _kRequiredGoodFrames = 5; // Need 5 consecutive good frames

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
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
        _startReadinessDetection();
      }
    } catch (e) {
      debugPrint('Camera init error: $e');
    }
  }

  void _startReadinessDetection() {
    _cameraController!.startImageStream((image) async {
      if (_cameraDescription == null) return;

      final poses = await _poseService.processFrame(image, _cameraDescription!);
      if (!mounted) return;

      setState(() => _currentPoses = poses);

      if (poses.isNotEmpty) {
        final pose = poses.first;
        final landmarks = pose.landmarks.values.toList();
        final visibleLandmarks = landmarks.where((l) => l.likelihood >= 0.65).length;
        final avgLikelihood = landmarks.isEmpty
            ? 0.0
            : landmarks.map((l) => l.likelihood).reduce((a, b) => a + b) / landmarks.length;

        setState(() {
          _bodyDetected = true;
          _landmarksVisible = visibleLandmarks;
          _avgConfidence = avgLikelihood;
          _goodConfidence = avgLikelihood >= 0.65 && visibleLandmarks >= 20;
        });

        if (_goodConfidence) {
          _consecutiveGoodFrames++;
        } else {
          _consecutiveGoodFrames = 0;
        }
      } else {
        setState(() {
          _bodyDetected = false;
          _landmarksVisible = 0;
          _avgConfidence = 0.0;
          _goodConfidence = false;
        });
        _consecutiveGoodFrames = 0;
      }
    });
  }

  bool get _isReady =>
      _tutorialComplete && _consecutiveGoodFrames >= _kRequiredGoodFrames;

  void _proceedToRecording() {
    _cameraController?.stopImageStream().catchError((_) {});
    _cameraController?.dispose();
    _cameraController = null;

    Navigator.pushReplacementNamed(
      context,
      '/drill/record',
      arguments: widget.drill,
    );
  }

  @override
  void dispose() {
    _checkTimer?.cancel();
    _pulseController.dispose();
    _cameraController?.dispose();
    _poseService.dispose();
    super.dispose();
  }

  // ═══════════════════════════════════════════════════════════════
  //  BUILD
  // ═══════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(decoration: const BoxDecoration(gradient: AppGradients.background)),

          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: _tutorialComplete
                      ? _buildReadinessCheck()
                      : _buildTutorialSteps(),
                ),
                _buildBottomBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Setup", style: AppTypography.h2),
                Text(
                  widget.drill.name,
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          // Step indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.glassFill,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              _tutorialComplete
                  ? 'Ready Check'
                  : 'Step ${_currentStep + 1} of ${_setupRules.length}',
              style: AppTypography.label.copyWith(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  //  TUTORIAL STEPS
  // ═══════════════════════════════════════════════════════════════

  List<_SetupRule> get _setupRules {
    final pos = widget.drill.cameraPosition;
    return [
      _SetupRule(
        icon: Icons.phone_android,
        title: 'Phone Position',
        description: pos == 'side'
            ? 'Place your phone to the side, propped up at waist height. You should be perpendicular to the camera.'
            : pos == 'front'
                ? 'Place your phone in front of you, facing you directly. Prop it up at waist height.'
                : 'Place your phone at a rear angle, slightly behind and to the side.',
        tip: 'Use a phone tripod or lean against a wall/bottle.',
        emoji: pos == 'side' ? '📐' : '📱',
      ),
      _SetupRule(
        icon: Icons.straighten,
        title: 'Distance: 3-4 meters',
        description: 'Stand 3-4 meters (about 10-13 feet) from your phone. The camera needs to see your entire body from head to toe.',
        tip: 'If doing kicks or jumps, add 1 extra meter of space.',
        emoji: '📏',
      ),
      _SetupRule(
        icon: Icons.wb_sunny_outlined,
        title: 'Good Lighting',
        description: 'Make sure there is plenty of light. Avoid standing in front of a bright window or light source — it will silhouette you.',
        tip: 'Outdoor daylight or a well-lit room works best.',
        emoji: '☀️',
      ),
      _SetupRule(
        icon: Icons.accessibility_new,
        title: 'Wear Fitted Clothing',
        description: 'Avoid very baggy clothing. The AI tracks your joints, so fitted pants and a regular shirt give the best results.',
        tip: 'Shorts and a t-shirt are perfect.',
        emoji: '👕',
      ),
      _SetupRule(
        icon: Icons.space_bar,
        title: 'Clear Space',
        description: 'Make sure you have enough room to perform the drill safely. Remove any obstacles that could be in your way.',
        tip: 'You need roughly 3m × 3m of clear space around you.',
        emoji: '🏟️',
      ),
    ];
  }

  Widget _buildTutorialSteps() {
    final rule = _setupRules[_currentStep];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Large emoji
          Text(rule.emoji, style: const TextStyle(fontSize: 72)),
          const SizedBox(height: 24),

          // Title
          Text(rule.title, style: AppTypography.h1, textAlign: TextAlign.center),
          const SizedBox(height: 16),

          // Description
          Text(
            rule.description,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 15,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // Tip card
          GlassCard(
            child: Row(
              children: [
                const Icon(Icons.lightbulb_outline, color: AppColors.gold, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    rule.tip,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.goldLight,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Step dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_setupRules.length, (i) {
              final isActive = i == _currentStep;
              final isDone = i < _currentStep;
              return Container(
                width: isActive ? 24 : 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: isDone
                      ? AppColors.success
                      : isActive
                          ? AppColors.blueLight
                          : AppColors.glassFillStrong,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  //  READINESS CHECK (Live Camera)
  // ═══════════════════════════════════════════════════════════════

  Widget _buildReadinessCheck() {
    return Column(
      children: [
        // Camera preview with pose overlay
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _isReady
                    ? AppColors.success.withOpacity(0.6)
                    : AppColors.glassBorder,
                width: _isReady ? 2 : 1,
              ),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (_isInitialized && _cameraController != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CameraPreview(_cameraController!),
                  ),

                // Pose overlay
                if (_currentPoses.isNotEmpty && _cameraController != null)
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

                // "Body not detected" overlay
                if (!_bodyDetected)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              return Opacity(
                                opacity: 0.5 + _pulseController.value * 0.5,
                                child: const Icon(
                                  Icons.person_outline,
                                  size: 80,
                                  color: AppColors.blueLight,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Step into frame',
                            style: AppTypography.h3.copyWith(color: AppColors.blueLight),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Checklist
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              _buildCheckItem(
                'Body detected',
                _bodyDetected,
                _bodyDetected ? '$_landmarksVisible landmarks visible' : 'Step into the camera frame',
              ),
              const SizedBox(height: 8),
              _buildCheckItem(
                'Good detection quality',
                _goodConfidence,
                _goodConfidence
                    ? 'Confidence: ${(_avgConfidence * 100).round()}%'
                    : 'Move to better lighting or adjust distance',
              ),
              const SizedBox(height: 8),
              _buildCheckItem(
                'Stable detection',
                _consecutiveGoodFrames >= _kRequiredGoodFrames,
                _consecutiveGoodFrames >= _kRequiredGoodFrames
                    ? 'Hold steady — you\'re good!'
                    : 'Hold still for a moment...',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCheckItem(String label, bool passed, String subtitle) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Icon(
              passed ? Icons.check_circle : Icons.radio_button_unchecked,
              key: ValueKey(passed),
              color: passed ? AppColors.success : AppColors.textTertiary,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.h3.copyWith(
                    fontSize: 13,
                    color: passed ? Colors.white : AppColors.textSecondary,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTypography.label.copyWith(
                    fontSize: 11,
                    color: passed ? AppColors.success.withOpacity(0.8) : AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  //  BOTTOM BAR
  // ═══════════════════════════════════════════════════════════════

  Widget _buildBottomBar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!_tutorialComplete) ...[
            // Tutorial navigation
            Row(
              children: [
                // Back step
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => setState(() => _currentStep--),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.glassBorder),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Back', style: AppTypography.button.copyWith(color: AppColors.textSecondary)),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 12),

                // Next / I'm Ready
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentStep < _setupRules.length - 1) {
                          setState(() => _currentStep++);
                        } else {
                          setState(() => _tutorialComplete = true);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: AppGradients.blue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            _currentStep < _setupRules.length - 1 ? 'NEXT' : "I'M READY →",
                            style: AppTypography.button,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Skip tutorial
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => setState(() => _tutorialComplete = true),
              child: Text(
                'Skip tutorial',
                style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary),
              ),
            ),
          ] else ...[
            // Start Recording button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isReady ? _proceedToRecording : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isReady ? null : AppColors.glassFillStrong,
                  disabledBackgroundColor: AppColors.glassFillStrong,
                  padding: EdgeInsets.zero,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isReady
                    ? Ink(
                        decoration: BoxDecoration(
                          gradient: AppGradients.blue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.videocam, color: Colors.white, size: 22),
                              const SizedBox(width: 10),
                              Text('START RECORDING', style: AppTypography.button),
                            ],
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.textTertiary,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Checking readiness...',
                            style: AppTypography.button.copyWith(color: AppColors.textTertiary),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _proceedToRecording,
              child: Text(
                'Skip check & start anyway',
                style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Data class for a single setup rule/instruction.
class _SetupRule {
  final IconData icon;
  final String title;
  final String description;
  final String tip;
  final String emoji;

  const _SetupRule({
    required this.icon,
    required this.title,
    required this.description,
    required this.tip,
    required this.emoji,
  });
}
