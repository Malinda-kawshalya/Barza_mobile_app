import 'dart:io';
import 'package:barza_app/models/profile_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class UserProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Save user profile to Firestore
  Future<void> saveUserProfile(UserProfile profile) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('No authenticated user found');
      }

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

      return doc.exists ? UserProfile.fromFirestore(doc) : null;
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    }
  }

  // Update profile photo and save URL to Firestore
  Future<void> updateProfilePhoto(File imageFile) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('No authenticated user found');
      }

      final fileName = path.basename(imageFile.path);
      final storageRef = _storage
          .ref()
          .child('profile_images/${currentUser.uid}/$fileName');

      final UploadTask uploadTask = storageRef.putFile(imageFile);
      final TaskSnapshot snapshot = await uploadTask;
      final String imageUrl = await snapshot.ref.getDownloadURL();

      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .update({'profileImageUrl': imageUrl});
    } catch (e) {
      print('Error updating profile photo: $e');
      rethrow;
    }
  }
}