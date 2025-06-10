import 'package:flutter/material.dart';
import '../../../services/chatcomms_services.dart';

class ChatController {
  final ChatCommsService chatCommsService = ChatCommsService();
  final TextEditingController messageController = TextEditingController();
  String messageText = '';
  String? loggedInUserEmail;

  Future<void> getCurrentUser() async {
    final user = await chatCommsService.getCurrentUser();
    if (user != null) {
      loggedInUserEmail = user.email;
    }
  }

  void sendMessage() {
    if (messageText.trim().isEmpty || loggedInUserEmail == null) return;
    chatCommsService.sendMessage(messageText, loggedInUserEmail!);
    messageController.clear();
    messageText = '';
  }

  void dispose() {
    messageController.dispose();
  }
} 