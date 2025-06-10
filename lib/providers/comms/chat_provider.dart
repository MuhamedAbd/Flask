import 'package:flutter/material.dart';
import '../../controllers/comms/chat_controller.dart';

class ChatProvider extends ChangeNotifier {
  final ChatController controller = ChatController();
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  String? get loggedInUserEmail => controller.loggedInUserEmail;
  String get messageText => controller.messageText;
  TextEditingController get messageController => controller.messageController;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();
    await controller.getCurrentUser();
    _isLoading = false;
    notifyListeners();
  }

  void updateMessageText(String value) {
    controller.messageText = value;
    notifyListeners();
  }

  void sendMessage() {
    controller.sendMessage();
    notifyListeners();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
} 