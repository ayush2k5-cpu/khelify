import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class VideoUploadService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<String> uploadVideo(File videoFile, String userId) async {
    try {
      // Create unique filename
      String fileName = 'drill_${DateTime.now().millisecondsSinceEpoch}.mp4';
      String storagePath = 'users/$userId/drills/$fileName';

      // Upload to Firebase Storage
      TaskSnapshot snapshot = await _storage
          .ref(storagePath)
          .putFile(videoFile);

      // Get download URL
      String downloadUrl = await snapshot.ref.getDownloadURL();
      
      print('✅ Video uploaded successfully: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('❌ Video upload failed: $e');
      throw Exception('Video upload failed: $e');
    }
  }

  static Future<void> deleteVideo(String videoUrl) async {
    try {
      // Extract path from URL and delete
      final ref = _storage.refFromURL(videoUrl);
      await ref.delete();
      print('✅ Video deleted successfully');
    } catch (e) {
      print('❌ Video deletion failed: $e');
    }
  }
}