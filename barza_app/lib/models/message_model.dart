import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String text;
  final Timestamp timestamp;

  Message({
    required this.senderId,
    required this.text,
    required this.timestamp,
  });

  factory Message.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Message(
      senderId: data['senderId'],
      text: data['text'],
      timestamp: data['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'text': text,
      'timestamp': timestamp,
    };
  }
}
