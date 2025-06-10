import 'package:flutter/material.dart';
import '../controllers/user_controller.dart';

class UserProvider extends ChangeNotifier {
  final UserController controller = UserController();

  String get userName => controller.userName;

  void getUserEmail() {
    controller.getUserEmail(notifyListeners);
  }

  Future<void> logout(BuildContext context) async {
    await controller.logout(context, notifyListeners);
  }

  @override
  void dispose() {
    super.dispose();
  }
} 