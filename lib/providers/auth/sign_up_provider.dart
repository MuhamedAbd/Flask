import 'package:flutter/material.dart';
import '../../controllers/auth/sign_up_controller.dart';

class SignUpProvider extends ChangeNotifier {
  final SignUpController controller = SignUpController();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<bool> signUp() async {
    _isLoading = true;
    notifyListeners();
    bool result = await controller.signUp();
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