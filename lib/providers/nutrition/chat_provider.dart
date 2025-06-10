import 'package:flutter/material.dart';
import '../../controllers/nutrition/chat_controller.dart';

class ChatProvider extends ChangeNotifier {
  final ChatController controller = ChatController();

  List<Map<String, String>> get messages => controller.messages;
  bool get isLoading => controller.isLoading;
  TextEditingController get messageController => controller.messageController;

  Future<void> initializeSession() async {
    await controller.initializeSession(notifyListeners);
  }

  Future<void> sendMessage() async {
    await controller.sendMessage(notifyListeners);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
} 