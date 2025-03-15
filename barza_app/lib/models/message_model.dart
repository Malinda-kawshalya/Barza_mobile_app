import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String message;
  final Timestamp timestamp;

  Message({
    required this.senderId,
    required this.message,
    required this.timestamp,
  });

  factory Message.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Message(
      senderId: data['senderId'],
      message: data['message'],
      timestamp: data['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
