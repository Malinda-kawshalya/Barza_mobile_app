import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  String? id;
  String email;
  String phoneNumber;
  String address;
  String location;
  String? profileImageUrl; // Added profileImageUrl
  String? fullName;

  UserProfile({
    this.id,
    this.profileImageUrl,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.location,
    required this.fullName,
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
    );
  }
}