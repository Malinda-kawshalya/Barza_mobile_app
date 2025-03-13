import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String chatId;
  final List<String> participants;
  final String lastMessage;
  final Timestamp timestamp;
  final String? fullName;

  Chat({
    required this.chatId,
    required this.participants,
    required this.lastMessage,
    required this.timestamp,
    this.fullName,
  });

  factory Chat.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Chat(
      chatId: doc.id,
      participants: List<String>.from(data['participants']),
      lastMessage: data['lastMessage'],
      timestamp: data['timestamp'],
      fullName: data['fullName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'participants': participants,
      'lastMessage': lastMessage,
      'timestamp': timestamp,
      'fullName': fullName,
    };
  }
}
