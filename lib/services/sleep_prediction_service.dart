import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/sleep_prediction_request.dart';

class SleepPredictionService {
  // Use your computer's IP address here
  static const String baseUrl = 'http://192.168.1.7:5000';

  Future<bool> testConnection() async {
    try {
      debugPrint('Testing connection to: $baseUrl/test');
      final response = await http.get(Uri.parse('$baseUrl/test'));
      debugPrint('Test response status: ${response.statusCode}');
      debugPrint('Test response body: ${response.body}');
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Connection test failed: $e');
      return false;
    }
  }

  Future<SleepPredictionResponse> getSleepAdvice(SleepPredictionRequest request) async {
    try {
      // Test connection first
      final isConnected = await testConnection();
      if (!isConnected) {
        throw Exception('Could not connect to the server. Please make sure it is running.');
      }

      debugPrint('Sending request to: $baseUrl/predict');
      debugPrint('Request body: ${jsonEncode(request.toJson())}');

      final response = await http.post(
        Uri.parse('$baseUrl/predict'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      debugPrint('Response status code: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return SleepPredictionResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to get sleep advice: ${response.body}');
      }
    } catch (e, stackTrace) {
      debugPrint('Error in getSleepAdvice: $e');
      debugPrint('Stack trace: $stackTrace');
      return SleepPredictionResponse(
        advice: [],
        error: 'Failed to connect to the server: $e',
      );
    }
  }
} 