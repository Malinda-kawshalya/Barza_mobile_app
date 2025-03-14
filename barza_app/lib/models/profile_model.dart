import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  String? id;
  String email;
  String phoneNumber;
  String address;
  String location;
  String? profileImageUrl; // Added profileImageUrl
  String? fullName;
  int stars; // Added stars field

  UserProfile({
    this.id,
    this.profileImageUrl,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.location,
    required this.fullName,
    required this.stars, // Required stars in constructor
  });

  // Convert UserProfile to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'location': location,
      'profileImageUrl': profileImageUrl, // Added profileImageUrl
      'stars': stars, // Added stars
    };
  }

  // Create UserProfile from Firestore document
  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return UserProfile(
      id: doc.id,
      fullName: data['fullName'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      address: data['address'] ?? '',
      location: data['location'] ?? '',
      profileImageUrl: data['profileImageUrl'] ?? '', // Added profileImageUrl
      stars: data['stars'] ?? 3, // Default stars to 3 for new users
    );
  }
}
