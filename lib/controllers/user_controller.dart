import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String userName = '';

  Future<void> getUserEmail(VoidCallback onUpdate) async {
    User? user = _auth.currentUser;
    print('Current user: ${user?.email}'); // Debug print
    
    if (user != null) {
      try {
        print('Fetching user data for UID: ${user.uid}'); // Debug print
        // Get user data from Firestore
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        print('User document exists: ${userDoc.exists}'); // Debug print
        
        if (userDoc.exists) {
          Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
          print('User data: $userData'); // Debug print
          userName = userData['username'] ?? user.email?.split('@')[0] ?? '';
          print('Set username to: $userName'); // Debug print
        } else {
          print('No user document found, using email prefix'); // Debug print
          // Fallback to email if no Firestore document exists
          userName = user.email?.split('@')[0] ?? '';
        }
        onUpdate();
      } catch (e) {
        print('Error fetching user data: $e');
        // Fallback to email if there's an error
        userName = user.email?.split('@')[0] ?? '';
        onUpdate();
      }
    } else {
      print('No user is currently logged in'); // Debug print
    }
  }

  Future<void> logout(BuildContext context, VoidCallback onUpdate) async {
    try {
      await _auth.signOut();
      onUpdate();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print('Logout failed: $e');
    }
  }
} 