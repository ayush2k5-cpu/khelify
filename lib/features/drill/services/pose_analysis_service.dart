import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

/// Wraps Google ML Kit Pose Detection for on-device analysis.
///
/// Handles camera image conversion, pose detection, and provides
/// detected poses that the UI and scoring engine can consume.
class PoseAnalysisService {
  late PoseDetector _poseDetector;
  bool _isBusy = false;
  bool _isInitialized = false;

  /// Initialize the pose detector.
  void initialize() {
    _poseDetector = PoseDetector(
      options: PoseDetectorOptions(mode: PoseDetectionMode.stream),
    );
    _isInitialized = true;
  }

  /// Process a single camera frame and return detected poses.
  Future<List<Pose>> processFrame(
    CameraImage image,
    CameraDescription camera,
  ) async {
    if (_isBusy || !_isInitialized) return [];
    _isBusy = true;

    try {
      final inputImage = _buildInputImage(image, camera);
      if (inputImage == null) return [];

      final poses = await _poseDetector.processImage(inputImage);
      return poses;
    } catch (e) {
      debugPrint('PoseAnalysisService error: $e');
      return [];
    } finally {
      _isBusy = false;
    }
  }

  /// Convert CameraImage to ML Kit InputImage.
  /// 
  /// Android cameras produce YUV_420_888 which must be converted to NV21.
  /// iOS cameras produce BGRA8888 which ML Kit accepts directly.
  InputImage? _buildInputImage(CameraImage image, CameraDescription camera) {
    final rotation =
        InputImageRotationValue.fromRawValue(camera.sensorOrientation) ??
            InputImageRotation.rotation0deg;

    // Determine the correct format based on platform
    InputImageFormat format;
    Uint8List bytes;

    if (Platform.isAndroid) {
      // Android: Convert YUV_420_888 to NV21
      format = InputImageFormat.nv21;
      bytes = _yuv420ToNv21(image);
    } else if (Platform.isIOS) {
      // iOS: Use BGRA8888 directly
      format = InputImageFormat.bgra8888;
      bytes = _concatenatePlanes(image.planes);
    } else {
      // Unsupported platform
      return null;
    }

    return InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes.first.bytesPerRow,
      ),
    );
  }

  /// Convert YUV_420_888 camera image to NV21 byte array.
  /// 
  /// NV21 layout: [Y plane] [interleaved V,U]
  /// The camera provides 3 planes: Y, U, V
  /// We need to interleave V and U into VU pairs after the Y plane.
  Uint8List _yuv420ToNv21(CameraImage image) {
    final int width = image.width;
    final int height = image.height;
    final int ySize = width * height;
    final int uvSize = width * height ~/ 2;

    final Uint8List nv21 = Uint8List(ySize + uvSize);

    // Y plane
    final yPlane = image.planes[0];
    final yBytes = yPlane.bytes;
    final int yRowStride = yPlane.bytesPerRow;

    // U and V planes  
    final uPlane = image.planes[1];
    final vPlane = image.planes[2];
    final uBytes = uPlane.bytes;
    final vBytes = vPlane.bytes;
    final int uvRowStride = uPlane.bytesPerRow;
    final int uvPixelStride = uPlane.bytesPerPixel ?? 1;

    // Copy Y plane
    if (yRowStride == width) {
      // Simple case: no padding in Y plane, direct copy
      nv21.setRange(0, ySize, yBytes);
    } else {
      // Row-by-row copy to skip padding
      for (int row = 0; row < height; row++) {
        final int srcOffset = row * yRowStride;
        final int dstOffset = row * width;
        for (int col = 0; col < width; col++) {
          nv21[dstOffset + col] = yBytes[srcOffset + col];
        }
      }
    }

    // Copy UV interleaved as VU (NV21 format)
    int uvIndex = ySize;
    final int uvHeight = height ~/ 2;
    final int uvWidth = width ~/ 2;

    for (int row = 0; row < uvHeight; row++) {
      for (int col = 0; col < uvWidth; col++) {
        final int uvOffset = row * uvRowStride + col * uvPixelStride;

        // NV21 is V then U
        if (uvOffset < vBytes.length) {
          nv21[uvIndex++] = vBytes[uvOffset];
        } else {
          nv21[uvIndex++] = 128; // neutral value
        }
        if (uvOffset < uBytes.length) {
          nv21[uvIndex++] = uBytes[uvOffset];
        } else {
          nv21[uvIndex++] = 128; // neutral value
        }
      }
    }

    return nv21;
  }

  /// Simple plane concatenation (for iOS BGRA8888).
  Uint8List _concatenatePlanes(List<Plane> planes) {
    final List<int> bytes = <int>[];
    for (final plane in planes) {
      bytes.addAll(plane.bytes);
    }
    return Uint8List.fromList(bytes);
  }

  /// Clean up resources.
  void dispose() {
    if (_isInitialized) {
      _poseDetector.close();
      _isInitialized = false;
    }
  }
}
