import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // دالة لتسجيل الدخول باستخدام البريد الإلكتروني وكلمة المرور
  Future<User?> loginWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Error during login: $e');
      return null;
    }
  }

  // دالة للتسجيل باستخدام البريد الإلكتروني وكلمة المرور
  Future<User?> registerWithEmailAndPassword(String email, String password, String username, bool isDoctor) async {
    try {
      // Create the user account
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Store additional user data in Firestore
      if (userCredential.user != null) {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'username': username,
          'email': email,
          'isDoctor': isDoctor,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      
      return userCredential.user;
    } catch (e) {
      print('Error during registration: $e');
      return null;
    }
  }

  // دالة لتسجيل الخروج
  Future<void> logout() async {
    await _auth.signOut();
  }

  // دالة للتحقق من حالة تسجيل الدخول (إذا كان المستخدم مسجل دخول أو لا)
  Future<bool> isUserLoggedIn() async {
    final User? user = _auth.currentUser;  // جلب المستخدم الحالي
    return user != null;  // إذا كان هناك مستخدم مسجل دخول
  }

  // Getter for current user
  User? get currentUser => _auth.currentUser;

  // دالة للاستماع لتغيرات حالة المستخدم
  Stream<User?> get user {
    return _auth.authStateChanges();  // تدفق التغيرات في حالة المستخدم
  }

  // Function to update username in Firestore
  Future<bool> updateUsername(String newUsername) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'username': newUsername,
        });
        return true;
      }
      return false;
    } catch (e) {
      print('Error updating username: $e');
      return false;
    }
  }

  // Function to update password
  Future<bool> updatePassword(String newPassword) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);
        return true;
      }
      return false;
    } catch (e) {
      print('Error updating password: $e');
      return false;
    }
  }
}
