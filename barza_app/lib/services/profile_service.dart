import 'package:barza_app/models/profile_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:barza_app/services/profile_service.dart';


class UserProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Save user profile to Firestore
  Future<void> saveUserProfile(UserProfile profile) async {
    try {
      // Get current user's UID
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('No authenticated user found');
      }

      // Save profile to Firestore under user's UID
      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .set(profile.toMap(), SetOptions(merge: true));
    } catch (e) {
      print('Error saving user profile: $e');
      rethrow;
    }
  }

  // Fetch user profile from Firestore
  Future<UserProfile?> fetchUserProfile() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        return null;
      }

      final doc = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .get();

      return doc.exists 
        ? UserProfile.fromFirestore(doc) 
        : null;
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    }
  }
}