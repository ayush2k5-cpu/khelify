import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../../../core/theme/app_colors.dart';

/// Paints the ML Kit pose skeleton over the camera preview.
///
/// Draws joints as blue dots and bones as light-blue lines,
/// matching the Khelify design system.
class PosePainter extends CustomPainter {
  final List<Pose> poses;
  final Size absoluteImageSize;
  final int rotation;
  final bool isFrontCamera;

  PosePainter({
    required this.poses,
    required this.absoluteImageSize,
    required this.rotation,
    required this.isFrontCamera,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (poses.isEmpty) return;

    final Paint jointPaint = Paint()
      ..color = AppColors.blueLight
      ..style = PaintingStyle.fill;

    final Paint bonePaint = Paint()
      ..color = AppColors.blueLight.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    // Confidence threshold paint (dim joints with low confidence)
    final Paint dimJointPaint = Paint()
      ..color = AppColors.blueLight.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    for (final pose in poses) {
      final landmarks = pose.landmarks;

      Offset? pointFor(PoseLandmarkType type) {
        final landmark = landmarks[type];
        if (landmark == null) return null;

        final scaleX = size.width / absoluteImageSize.width;
        final scaleY = size.height / absoluteImageSize.height;

        double mappedX = landmark.x * scaleX;
        double mappedY = landmark.y * scaleY;

        if (isFrontCamera) {
          mappedX = size.width - mappedX;
        }

        return Offset(mappedX, mappedY);
      }

      void drawBone(PoseLandmarkType a, PoseLandmarkType b) {
        final p1 = pointFor(a);
        final p2 = pointFor(b);
        if (p1 == null || p2 == null) return;
        canvas.drawLine(p1, p2, bonePaint);
      }

      // ── Draw Skeleton ──

      // Torso
      drawBone(PoseLandmarkType.leftShoulder, PoseLandmarkType.rightShoulder);
      drawBone(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip);
      drawBone(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip);
      drawBone(PoseLandmarkType.leftHip, PoseLandmarkType.rightHip);

      // Left Arm
      drawBone(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow);
      drawBone(PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist);

      // Right Arm
      drawBone(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow);
      drawBone(PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist);

      // Left Leg
      drawBone(PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee);
      drawBone(PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle);

      // Right Leg
      drawBone(PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee);
      drawBone(PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle);

      // Joints
      for (final entry in landmarks.entries) {
        final landmark = entry.value;
        final p = pointFor(entry.key);
        if (p == null) continue;

        // Use confidence to decide paint intensity
        final paint = landmark.likelihood > 0.5 ? jointPaint : dimJointPaint;
        canvas.drawCircle(p, 5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant PosePainter oldDelegate) {
    return oldDelegate.poses != poses;
  }
}
