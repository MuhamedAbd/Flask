import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  late final GenerativeModel _model;
  late final ChatSession _chat;

  GeminiService() {
    const String apiKey = 'AIzaSyAUmfovt1Gv4no4bHqF4fwlsMQ2lazwULU';
    
    try {
      _model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey,
      );
      
      // Initialize chat with a simple system message
      _chat = _model.startChat();
      
      // Send initial system message
      _chat.sendMessage(
        Content.text('You are a helpful AI nutrition assistant. Provide clear, accurate, and helpful responses about nutrition, health, and wellness.'),
      );
    } catch (e) {
      print('Error initializing Gemini model: $e');
      rethrow;
    }
  }

  Future<String> sendMessage(String message) async {
    try {
      if (message.trim().isEmpty) {
        return "Please enter a message.";
      }

      final response = await _chat.sendMessage(
        Content.text(message),
      );
      
      if (response.text != null && response.text!.isNotEmpty) {
        return response.text!;
      } else {
        return "I apologize, but I couldn't generate a response at this time. Please try again.";
      }
    } catch (e) {
      print('Error sending message to Gemini: $e');
      if (e.toString().contains('API key')) {
        return "Error: Invalid API key. Please check your API key configuration.";
      } else if (e.toString().contains('model')) {
        return "Error: Model not available. Please check the model configuration. Error details: $e";
      } else {
        return "I apologize, but I encountered an error while processing your request. Please try again later.";
      }
    }
  }

  void resetChat() {
    try {
      _chat = _model.startChat();
      // Send initial system message after reset
      _chat.sendMessage(
        Content.text('You are a helpful AI nutrition assistant. Provide clear, accurate, and helpful responses about nutrition, health, and wellness.'),
      );
    } catch (e) {
      print('Error resetting chat: $e');
      rethrow;
    }
  }
} 