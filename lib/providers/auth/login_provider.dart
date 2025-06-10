import 'package:flutter/material.dart';
import '../../controllers/auth/login_controller.dart';

class LoginProvider extends ChangeNotifier {
  final LoginController controller = LoginController();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<bool> login() async {
    _isLoading = true;
    notifyListeners();
    bool result = await controller.login();
    _isLoading = false;
    notifyListeners();
    return result;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
} 