import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../models/item_model.dart';

class BarterItemService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Upload multiple images
  Future<List<String>> uploadImages(List<File> images) async {
    List<String> imageUrls = [];
    try {
      for (var image in images) {
        final fileName =
            'item_images/${DateTime.now().millisecondsSinceEpoch}_${image.path.split('/').last}';
        final storageRef = _storage.ref().child(fileName);

        final uploadTask = await storageRef.putFile(image);
        final downloadUrl = await uploadTask.ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      }
      return imageUrls;
    } catch (e) {
      debugPrint('Image Upload Error: $e');
      return [];
    }
  }

  // Upload video
  Future<String?> uploadVideo(File? videoFile) async {
    if (videoFile == null) return null;
    try {
      final fileName =
          'item_videos/${DateTime.now().millisecondsSinceEpoch}_${videoFile.path.split('/').last}';
      final storageRef = _storage.ref().child(fileName);

      final uploadTask = await storageRef.putFile(videoFile);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      debugPrint('Video Upload Error: $e');
      return null;
    }
  }

  // Add new barter item
  Future<BarterItem?> addBarterItem({
    required String itemName,
    required String category,
    required String condition,
    String? brand,
    required String description,
    required String usageDuration,
    String? reasonForBarter,
    required List<File> images,
    File? videoFile,
    required String preferredExchange,
    bool acceptMultipleOffers = false,
    required String exchangeLocation,
    required String contactMethod,
    bool showContactInfo = false,
  }) async {
    try {
      // Ensure user is logged in
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User must be logged in to add an item');
      }

      // Upload images
      final imageUrls = await uploadImages(images);

      // Upload video
      final videoUrl = await uploadVideo(videoFile);

      // Create BarterItem
      final barterItem = BarterItem(
        itemName: itemName,
        category: category,
        condition: condition,
        brand: brand,
        description: description,
        usageDuration: usageDuration,
        reasonForBarter: reasonForBarter,
        images: imageUrls,
        videoUrl: videoUrl,
        preferredExchange: preferredExchange,
        acceptMultipleOffers: acceptMultipleOffers,
        exchangeLocation: exchangeLocation,
        contactMethod: contactMethod,
        showContactInfo: showContactInfo,
        userId: user.uid,
        createdAt: Timestamp.now(),
      );

      // Add to Firestore
      final docRef = await _firestore
          .collection('barter_items')
          .add(barterItem.toFirestore());

      // Update the item with its Firestore document ID
      barterItem.id = docRef.id;

      return barterItem;
    } catch (e) {
      debugPrint('Add Barter Item Error: $e');
      return null;
    }
  }

  // Get all active barter items
  Stream<List<BarterItem>> getActiveBarterItems() {
    return _firestore
        .collection('barter_items')
        .where('status', isEqualTo: 'active')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => BarterItem.fromFirestore(doc)).toList());
  }

  // Get user's barter items
  Stream<List<BarterItem>> getUserBarterItems() {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('barter_items')
        .where('userId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => BarterItem.fromFirestore(doc)).toList());
  }

  // Update barter item status
  Future<bool> updateBarterItemStatus(String itemId, String status) async {
    try {
      await _firestore
          .collection('barter_items')
          .doc(itemId)
          .update({'status': status});
      return true;
    } catch (e) {
      debugPrint('Update Barter Item Status Error: $e');
      return false;
    }
  }

  // Delete barter item
  Future<bool> deleteBarterItem(String itemId) async {
    try {
      await _firestore.collection('barter_items').doc(itemId).delete();
      return true;
    } catch (e) {
      debugPrint('Delete Barter Item Error: $e');
      return false;
    }
  }

  // Search barter items
  Future<List<BarterItem>> searchBarterItems(String query) async {
    try {
      final snapshot = await _firestore
          .collection('barter_items')
          .where('status', isEqualTo: 'active')
          .where('itemName', isGreaterThanOrEqualTo: query)
          .where('itemName', isLessThan: query + 'z')
          .get();

      return snapshot.docs.map((doc) => BarterItem.fromFirestore(doc)).toList();
    } catch (e) {
      debugPrint('Search Barter Items Error: $e');
      return [];
    }
  }
}
