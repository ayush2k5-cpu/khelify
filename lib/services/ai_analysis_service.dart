import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AIAnalysisService {
  // 🔥 REPLACE THIS WITH YOUR NGROK URL
  // Example: 'https://abc123.ngrok-free.app'
  static const String baseUrl = 'https://earlie-unsurgical-ivanna.ngrok-free.dev';
  
  /// Analyze video with MediaPipe - Direct file upload
  static Future<Map<String, dynamic>> analyzeVideo({
    required String videoPath,
    required String drillType,
  }) async {
    try {
      print('🤖 Sending video to AI backend...');
      print('📁 Video path: $videoPath');
      print('🎯 Drill type: $drillType');
      print('🌐 Backend URL: $baseUrl');
      
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/analyze'),
      );
      
      // Add video file
      request.files.add(
        await http.MultipartFile.fromPath('video', videoPath),
      );
      
      // Add drill type
      request.fields['drill_type'] = drillType;
      
      print('📤 Uploading video...');
      
      var streamedResponse = await request.send().timeout(
        Duration(seconds: 120),
        onTimeout: () {
          throw Exception('Upload timeout - check your connection');
        },
      );
      
      print('⏳ Waiting for AI analysis...');
      
      var response = await http.Response.fromStream(streamedResponse);
      
      print('📨 Response status: ${response.statusCode}');
      print('📨 Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          print('✅ AI Analysis successful');
          return data['results'];
        } else {
          throw Exception(data['error'] ?? 'Analysis failed');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
      
    } catch (e) {
      print('❌ AI Analysis error: $e');
      throw Exception('Failed to analyze video: $e');
    }
  }
  
  /// Test connection to AI server
  static Future<bool> testConnection() async {
    try {
      print('🔍 Testing backend connection...');
      final response = await http.get(
        Uri.parse('$baseUrl/health'),
      ).timeout(Duration(seconds: 5));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ Backend connection successful');
        print('   MediaPipe: ${data['mediapipe']}');
        print('   OpenCV: ${data['opencv']}');
        return true;
      }
      return false;
    } catch (e) {
      print('❌ Backend connection failed: $e');
      return false;
    }
  }
}
