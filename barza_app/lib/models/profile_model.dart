import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  String? id;
  String email;
  String phoneNumber;
  String address;
  String location;

  UserProfile({
    this.id,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.location,
  });

  // Convert UserProfile to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'location': location,
    };
  }

  // Create UserProfile from Firestore document
  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return UserProfile(
      id: doc.id,
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      address: data['address'] ?? '',
      location: data['location'] ?? '',
    );
  }
}