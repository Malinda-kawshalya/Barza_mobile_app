import 'package:cloud_firestore/cloud_firestore.dart';

class ConfirmedItem {
  String? id;
  String itemId;
  String itemName;
  String description;
  String userId;
  double rating;
  String comment;
  Timestamp confirmedAt;
  String category;
  String condition;
  List<String> images;

  ConfirmedItem({
    this.id,
    required this.itemId,
    required this.itemName,
    required this.description,
    required this.userId,
    required this.rating,
    required this.comment,
    required this.confirmedAt,
    required this.category,
    required this.condition,
    this.images = const [],
  });

  // Convert Firestore document to ConfirmedItem object
  factory ConfirmedItem.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ConfirmedItem(
      id: doc.id,
      itemId: data['itemId'] ?? '',
      itemName: data['itemName'] ?? '',
      description: data['description'] ?? '',
      userId: data['userId'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      comment: data['comment'] ?? '',
      confirmedAt: data['confirmedAt'] ?? Timestamp.now(),
      category: data['category'] ?? '',
      condition: data['condition'] ?? '',
      images: List<String>.from(data['images'] ?? []),
    );
  }

  // Convert ConfirmedItem to a map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'itemId': itemId,
      'itemName': itemName,
      'description': description,
      'userId': userId,
      'rating': rating,
      'comment': comment,
      'confirmedAt': confirmedAt,
      'category': category,
      'condition': condition,
      'images': images,
    };
  }
}
