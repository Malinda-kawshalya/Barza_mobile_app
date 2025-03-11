import 'package:cloud_firestore/cloud_firestore.dart';

class ExchangeRequest {
  final String requestId;
  final String requestingUserId;
  final String requestedItemId;
  final String? offeredItemId; // Optional, can be null
  final String itemOwnerId;
  final String status;
  final Timestamp timestamp;

  ExchangeRequest({
    required this.requestId,
    required this.requestingUserId,
    required this.requestedItemId,
    this.offeredItemId,
    required this.itemOwnerId,
    required this.status,
    required this.timestamp,
  });

  // Factory method to create an ExchangeRequest from a Firestore document
  factory ExchangeRequest.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return ExchangeRequest(
      requestId: doc.id,
      requestingUserId: data['requestingUserId'],
      requestedItemId: data['requestedItemId'],
      offeredItemId: data['offeredItemId'],
      itemOwnerId: data['itemOwnerId'],
      status: data['status'],
      timestamp: data['timestamp'],
    );
  }

  // Method to convert ExchangeRequest to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'requestingUserId': requestingUserId,
      'requestedItemId': requestedItemId,
      'offeredItemId': offeredItemId,
      'itemOwnerId': itemOwnerId,
      'status': status,
      'timestamp': timestamp,
    };
  }
}