// chatcomms_services.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatCommsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> sendMessage(String messageText, String userEmail) async {
    if (messageText.trim().isEmpty || userEmail.isEmpty) return;
    try {
      await _firestore.collection('messages').add({
        'text': messageText,
        'sender': userEmail,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print(e);
    }
  }

  Stream<QuerySnapshot> getMessages() {
    return _firestore
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
