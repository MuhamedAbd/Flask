import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'auth_service.dart'; // استيراد AuthService
import '../views/auth/login_page.dart';  // استيراد صفحة تسجيل الدخول
import '../views/mainscreen.dart'; // استيراد الشاشة الرئيسية

class Wrapper extends StatelessWidget {
  final AuthService authService = AuthService(); // إنشاء كائن من AuthService

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: authService.user, // الاستماع لتغيرات حالة المستخدم
      builder: (context, snapshot) {
        // إذا كانت حالة الاتصال في الانتظار
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        // إذا كان هناك مستخدم مسجل دخول
        if (snapshot.hasData) {
          return WellnessHomePage();  // توجيه المستخدم إلى الشاشة الرئيسية
        } else {
          return LoginPage();  // توجيه المستخدم إلى صفحة تسجيل الدخول
        }
      },
    );
  }
}
