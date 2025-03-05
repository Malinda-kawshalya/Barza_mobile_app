import 'package:cloud_firestore/cloud_firestore.dart';

class BarterItem {
  String? id;
  String itemName;
  String category;
  String condition;
  String? brand;
  String description;
  String usageDuration;
  String? reasonForBarter;
  List<String> images;
  String? videoUrl;
  String preferredExchange;
  bool acceptMultipleOffers;
  String exchangeLocation;
  String contactMethod;
  bool showContactInfo;
  Timestamp? createdAt;
  String? userId;
  String status;

  BarterItem({
    this.id,
    required this.itemName,
    required this.category,
    required this.condition,
    this.brand,
    required this.description,
    required this.usageDuration,
    this.reasonForBarter,
    this.images = const [],
    this.videoUrl,
    required this.preferredExchange,
    this.acceptMultipleOffers = false,
    required this.exchangeLocation,
    required this.contactMethod,
    this.showContactInfo = false,
    this.createdAt,
    this.userId,
    this.status = 'active',
  });

  // Convert Firestore document to BarterItem object
  factory BarterItem.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return BarterItem(
      id: doc.id,
      itemName: data['itemName'] ?? '',
      category: data['category'] ?? '',
      condition: data['condition'] ?? '',
      brand: data['brand'],
      description: data['description'] ?? '',
      usageDuration: data['usageDuration'] ?? '',
      reasonForBarter: data['reasonForBarter'],
      images: List<String>.from(data['images'] ?? []),
      videoUrl: data['videoUrl'],
      preferredExchange: data['preferredExchange'] ?? '',
      acceptMultipleOffers: data['acceptMultipleOffers'] ?? false,
      exchangeLocation: data['exchangeLocation'] ?? '',
      contactMethod: data['contactMethod'] ?? '',
      showContactInfo: data['showContactInfo'] ?? false,
      createdAt: data['createdAt'],
      userId: data['userId'],
      status: data['status'] ?? 'active',
    );
  }

  // Convert BarterItem to a map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'itemName': itemName,
      'category': category,
      'condition': condition,
      'brand': brand,
      'description': description,
      'usageDuration': usageDuration,
      'reasonForBarter': reasonForBarter,
      'images': images,
      'videoUrl': videoUrl,
      'preferredExchange': preferredExchange,
      'acceptMultipleOffers': acceptMultipleOffers,
      'exchangeLocation': exchangeLocation,
      'contactMethod': contactMethod,
      'showContactInfo': showContactInfo,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'userId': userId,
      'status': status,
    };
  }
}