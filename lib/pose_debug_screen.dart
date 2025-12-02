import 'dart:async';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class PoseDebugScreen extends StatefulWidget {
  const PoseDebugScreen({super.key});

  @override
  State<PoseDebugScreen> createState() => _PoseDebugScreenState();
}

class _PoseDebugScreenState extends State<PoseDebugScreen> {
  CameraController? _cameraController;
  late PoseDetector _poseDetector;
  bool _isBusy = false;
  List<Pose> _poses = [];
  CameraDescription? _cameraDescription;
  StreamSubscription? _cameraStreamSub;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    // 1. Get available cameras
    final cameras = await availableCameras();
    // Prefer back camera
    _cameraDescription = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );

    // 2. Init camera controller
    _cameraController = CameraController(
      _cameraDescription!,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _cameraController!.initialize();
    await _cameraController!.startImageStream(_processCameraImage);

    // 3. Init ML Kit pose detector
    final options = PoseDetectorOptions(
      mode: PoseDetectionMode.stream,
    );
    _poseDetector = PoseDetector(options: options);

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _processCameraImage(CameraImage image) async {
    if (_isBusy || !mounted) return;
    _isBusy = true;

    try {
      final inputImage = _buildInputImage(image, _cameraDescription!);
      final poses = await _poseDetector.processImage(inputImage);

      if (!mounted) return;
      setState(() {
        _poses = poses;
      });
    } catch (_) {
      // swallow for now – this is just a debug screen
    } finally {
      _isBusy = false;
    }
  }

  InputImage _buildInputImage(
    CameraImage image,
    CameraDescription camera,
  ) {
    final rotation =
        InputImageRotationValue.fromRawValue(camera.sensorOrientation) ??
            InputImageRotation.rotation0deg;

    final format =
        InputImageFormatValue.fromRawValue(image.format.raw) ??
            InputImageFormat.nv21;

    final plane = image.planes.first;

    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  @override
  void dispose() {
    _cameraStreamSub?.cancel();
    _cameraController?.dispose();
    _poseDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _cameraController;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pose Debug'),
      ),
      backgroundColor: Colors.black,
      body: controller == null || !controller.value.isInitialized
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              fit: StackFit.expand,
              children: [
                CameraPreview(controller),
                CustomPaint(
                  painter: _PosePainter(
                    poses: _poses,
                    absoluteImageSize: Size(
                      controller.value.previewSize!.height,
                      controller.value.previewSize!.width,
                    ),
                    rotation: controller.description.sensorOrientation,
                    isFrontCamera: controller.description.lensDirection ==
                        CameraLensDirection.front,
                  ),
                ),
                Positioned(
                  left: 16,
                  bottom: 24,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Poses: ${_poses.length}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _PosePainter extends CustomPainter {
  _PosePainter({
    required this.poses,
    required this.absoluteImageSize,
    required this.rotation,
    required this.isFrontCamera,
  });

  final List<Pose> poses;
  final Size absoluteImageSize;
  final int rotation;
  final bool isFrontCamera;

  @override
  void paint(Canvas canvas, Size size) {
    if (poses.isEmpty) return;

    final Paint jointPaint = Paint()
      ..color = Colors.orangeAccent
      ..style = PaintingStyle.fill
      ..strokeWidth = 4;

    final Paint bonePaint = Paint()
      ..color = Colors.lightBlueAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (final pose in poses) {
      final landmarks = pose.landmarks;

      Offset? _p(PoseLandmarkType type) {
        final landmark = landmarks[type];
        if (landmark == null) return null;
        final x = landmark.x;
        final y = landmark.y;

        // Convert from image space to widget space
        double scaleX = size.width / absoluteImageSize.width;
        double scaleY = size.height / absoluteImageSize.height;

        double mappedX = x * scaleX;
        double mappedY = y * scaleY;

        if (isFrontCamera) {
          mappedX = size.width - mappedX;
        }

        return Offset(mappedX, mappedY);
      }

      void drawBone(PoseLandmarkType a, PoseLandmarkType b) {
        final p1 = _p(a);
        final p2 = _p(b);
        if (p1 == null || p2 == null) return;
        canvas.drawLine(p1, p2, bonePaint);
      }

      // Draw main bones
      drawBone(PoseLandmarkType.leftShoulder, PoseLandmarkType.rightShoulder);
      drawBone(PoseLandmarkType.leftHip, PoseLandmarkType.rightHip);

      drawBone(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow);
      drawBone(PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist);
      drawBone(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow);
      drawBone(PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist);

      drawBone(PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee);
      drawBone(PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle);
      drawBone(PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee);
      drawBone(PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle);

      // Draw joints
      for (final landmark in landmarks.values) {
        final x = landmark.x;
        final y = landmark.y;

        double scaleX = size.width / absoluteImageSize.width;
        double scaleY = size.height / absoluteImageSize.height;

        double mappedX = x * scaleX;
        double mappedY = y * scaleY;

        if (isFrontCamera) {
          mappedX = size.width - mappedX;
        }

        canvas.drawCircle(Offset(mappedX, mappedY), 4, jointPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PosePainter oldDelegate) {
    return oldDelegate.poses != poses;
  }
}
