import 'package:flutter/material.dart';
import '../../../services/auth_service.dart';

class LoginController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();

  Future<bool> login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    var user = await authService.loginWithEmailAndPassword(email, password);
    return user != null;
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
} 