import 'package:flutter/material.dart';
import '../../../services/gemini_service.dart';

class ChatController {
  final TextEditingController messageController = TextEditingController();
  final GeminiService geminiService = GeminiService();
  List<Map<String, String>> messages = [];
  bool isLoading = false;

  Future<void> initializeSession(VoidCallback onUpdate) async {
    messages = [];
    geminiService.resetChat();
    onUpdate();
  }

  Future<void> sendMessage(VoidCallback onUpdate) async {
    if (messageController.text.isNotEmpty) {
      final userMessage = messageController.text;
      messages.add({
        'text': userMessage,
        'isUser': 'true',
      });
      
      isLoading = true;
      onUpdate();
      
      final response = await geminiService.sendMessage(userMessage);
      
      messages.add({
        'text': response,
        'isUser': 'false',
      });
      
      messageController.clear();
      isLoading = false;
      onUpdate();
    }
  }

  void dispose() {
    messageController.dispose();
  }
} 