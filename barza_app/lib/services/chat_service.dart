// chat_service.dart - Core service for chat functionality
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;
  
  // Create a new chat or get existing chat ID
  Future<String> createOrGetChat(String otherUserId) async {
    // Check if a chat already exists between these users
    final querySnapshot = await _firestore
        .collection('chats')
        .where('participants', arrayContains: currentUserId)
        .get();
    
    for (var doc in querySnapshot.docs) {
      List participants = doc.data()['participants'];
      if (participants.contains(otherUserId)) {
        return doc.id; // Chat already exists
      }
    }
    
    // Create a new chat
    final chatRef = _firestore.collection('chats').doc();
    await chatRef.set({
      'participants': [currentUserId, otherUserId],
      'createdAt': FieldValue.serverTimestamp(),
      'lastMessage': '',
      'lastMessageTimestamp': FieldValue.serverTimestamp(),
    });
    
    // Add chat reference to both users
    await _firestore.collection('users').doc(currentUserId).update({
      'chats': FieldValue.arrayUnion([chatRef.id])
    });
    
    await _firestore.collection('users').doc(otherUserId).update({
      'chats': FieldValue.arrayUnion([chatRef.id])
    });
    
    return chatRef.id;
  }
  
  // Send a message
  Future<void> sendMessage(String chatId, String content) async {
    if (currentUserId == null) return;
    
    // Add message to chat
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
          'senderId': currentUserId,
          'content': content,
          'timestamp': FieldValue.serverTimestamp(),
          'read': false,
        });
    
    // Update last message info in chat document
    await _firestore.collection('chats').doc(chatId).update({
      'lastMessage': content,
      'lastMessageTimestamp': FieldValue.serverTimestamp(),
    });
  }
  
  // Get all chats for current user
  Stream<QuerySnapshot> getChats() {
    if (currentUserId == null) {
      throw Exception("User not authenticated");
    }
    
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: currentUserId)
        .orderBy('lastMessageTimestamp', descending: true)
        .snapshots();
  }
  
  // Get messages for a specific chat
  Stream<QuerySnapshot> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
  
  // Mark messages as read
  Future<void> markMessagesAsRead(String chatId) async {
    if (currentUserId == null) return;
    
    final querySnapshot = await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .where('senderId', isNotEqualTo: currentUserId)
        .where('read', isEqualTo: false)
        .get();
    
    final batch = _firestore.batch();
    
    for (var doc in querySnapshot.docs) {
      batch.update(doc.reference, {'read': true});
    }
    
    await batch.commit();
  }
  
  // Get user info by ID
  Future<DocumentSnapshot> getUserInfo(String userId) {
    return _firestore.collection('users').doc(userId).get();
  }
}