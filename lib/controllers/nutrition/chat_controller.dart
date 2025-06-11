import 'package:flutter/material.dart';
import '../../../services/gemini_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatController {
  final TextEditingController messageController = TextEditingController();
  final GeminiService geminiService = GeminiService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, String>> messages = [];
  bool isLoading = false;

  Future<void> initializeSession(VoidCallback onUpdate) async {
    isLoading = true;
    onUpdate();
    
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        QuerySnapshot querySnapshot = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('chat_history')
            .orderBy('timestamp', descending: false)
            .get();

        messages = querySnapshot.docs.map((doc) => {
              'text': doc['text'] as String,
              'isUser': doc['isUser'] as String,
            }).toList();
      } catch (e) {
        print('Error loading chat history: $e');
      }
    }
    isLoading = false;
    onUpdate();
  }

  Future<void> sendMessage(VoidCallback onUpdate) async {
    if (messageController.text.isNotEmpty) {
      final userMessage = messageController.text;
      messages.add({
        'text': userMessage,
        'isUser': 'true',
      });

      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('chat_history')
            .add({
          'text': userMessage,
          'isUser': 'true',
          'timestamp': FieldValue.serverTimestamp(),
          'userId': user.uid,
        });
      }
      
      isLoading = true;
      onUpdate();
      
      final response = await geminiService.sendMessage(userMessage);
      
      messages.add({
        'text': response,
        'isUser': 'false',
      });

      if (user != null) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('chat_history')
            .add({
          'text': response,
          'isUser': 'false',
          'timestamp': FieldValue.serverTimestamp(),
          'userId': user.uid,
        });
      }
      
      messageController.clear();
      isLoading = false;
      onUpdate();
    }
  }

  Future<void> sendInitialMessage(String message, VoidCallback onUpdate) async {
    print('sendInitialMessage called with: $message');
    messages.add({
      'text': message,
      'isUser': 'true',
    });
    print('Messages after adding user message: ${messages.length} - ${messages.last}');

    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('chat_history')
          .add({
        'text': message,
        'isUser': 'true',
        'timestamp': FieldValue.serverTimestamp(),
        'userId': user.uid,
      });
      print('User message saved to Firestore.');
    }
    
    isLoading = true;
    onUpdate(); // Notify listeners for isLoading and initial message display
    print('isLoading set to true, onUpdate called.');
    
    final response = await geminiService.sendMessage(message);
    print('Gemini response received: $response');
    
    messages.add({
      'text': response,
      'isUser': 'false',
    });
    print('Messages after adding AI response: ${messages.length} - ${messages.last}');

    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('chat_history')
          .add({
        'text': response,
        'isUser': 'false',
        'timestamp': FieldValue.serverTimestamp(),
        'userId': user.uid,
      });
      print('AI message saved to Firestore.');
    }
    
    isLoading = false;
    onUpdate(); // Notify listeners for isLoading and AI message display
    print('isLoading set to false, onUpdate called.');
  }

  void dispose() {
    messageController.dispose();
  }
} 