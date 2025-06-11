import 'package:flutter/material.dart';
import '../../../services/auth_service.dart';

class SignUpController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final AuthService authService = AuthService();
  bool isDoctor = false;

  Future<bool> signUp() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String username = usernameController.text.trim();
    
    if (username.isEmpty) {
      return false;
    }
    
    var user = await authService.registerWithEmailAndPassword(email, password, username, isDoctor);
    return user != null;
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
  }
} 