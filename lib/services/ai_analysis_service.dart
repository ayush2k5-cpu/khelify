import 'dart:convert';
import 'package:http/http.dart' as http;

class AIAnalysisService {
  // Use your local IP address (the one shown in your Flask server)
  static const String baseUrl = 'http://192.168.0.110:5000';
  
  static Future<Map<String, dynamic>> analyzeVideo({
    required String videoUrl,
    required String drillType,
  }) async {
    try {
      print('🎬 Sending video for AI analysis: $drillType');
      
      final response = await http.post(
        Uri.parse('$baseUrl/analyze_video'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'video_url': videoUrl,
          'drill_type': drillType,
        }),
      );
      
      print('📊 AI Server Response Status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        print('✅ AI Analysis Successful!');
        return result;
      } else {
        final error = jsonDecode(response.body);
        throw Exception('AI Analysis failed: ${error['error']}');
      }
    } catch (e) {
      print('❌ AI Analysis Error: $e');
      throw Exception('Failed to connect to AI server: $e');
    }
  }

  // Test connection to AI server
  static Future<bool> testConnection() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/'));
      return response.statusCode == 200;
    } catch (e) {
      print('❌ Cannot connect to AI server: $e');
      return false;
    }
  }
}