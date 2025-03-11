import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String notificationId;
  final String userId;
  final String type;
  final String message;
  final Timestamp timestamp;
  final bool read;
  final String? relatedItemId;
  final String? senderId;
  final String? exchangeRequestId;

  NotificationModel({
    required this.notificationId,
    required this.userId,
    required this.type,
    required this.message,
    required this.timestamp,
    required this.read,
    this.relatedItemId,
    this.senderId,
    this.exchangeRequestId,
  });

  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return NotificationModel(
      notificationId: doc.id,
      userId: data['userId'],
      type: data['type'],
      message: data['message'],
      timestamp: data['timestamp'],
      read: data['read'],
      relatedItemId: data['relatedItemId'],
      senderId: data['senderId'],
      exchangeRequestId: data['exchangeRequestId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'type': type,
      'message': message,
      'timestamp': timestamp,
      'read': read,
      'relatedItemId': relatedItemId,
      'senderId': senderId,
      'exchangeRequestId': exchangeRequestId,
    };
  }
}