import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/confirmed_item_model.dart';
import '../models/exchange_requests_model.dart';
import '../models/profile_model.dart'; // Make sure this import is correct
import '../screens/chat_screen.dart';

class ExchangeRequestDetailsScreen extends StatelessWidget {
  final String exchangeRequestId;

  ExchangeRequestDetailsScreen({required this.exchangeRequestId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 218, 230, 229),
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        backgroundColor: const Color(0xFF0C969C),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
        title: Text(
          'Exchange Request Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('exchange_requests')
            .doc(exchangeRequestId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error loading request details"));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text("Request not found"));
          }

          final exchangeRequest = ExchangeRequest.fromFirestore(snapshot.data!);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              // Added SingleChildScrollView
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("Requested Item"),
                  _buildItemDetails(exchangeRequest.requestedItemId),
                  SizedBox(height: 16),
                  _buildSectionTitle("Offered Item"),
                  exchangeRequest.offeredItemId != null
                      ? _buildItemDetails(exchangeRequest.offeredItemId!)
                      : Text("No item was offered in exchange",
                          style: TextStyle(fontStyle: FontStyle.italic)),
                  SizedBox(height: 24),
                  _buildStatusAndActions(context, exchangeRequest),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildItemDetails(String itemId) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('confirmed_items')
          .doc(itemId)
          .get(),
      builder: (context, itemSnapshot) {
        if (itemSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (itemSnapshot.hasError ||
            !itemSnapshot.hasData ||
            !itemSnapshot.data!.exists) {
          return Text("Item details not found",
              style: TextStyle(color: Colors.red, fontStyle: FontStyle.italic));
        }
        final confirmedItem = ConfirmedItem.fromFirestore(itemSnapshot.data!);
        return Card(
          elevation: 3,
          margin: EdgeInsets.only(top: 8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (confirmedItem.images.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(confirmedItem.images[0],
                        height: 120, width: double.infinity, fit: BoxFit.cover),
                  ),
                SizedBox(height: 8),
                Text(confirmedItem.itemName,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                Text(confirmedItem.description,
                    style: TextStyle(color: Colors.grey[700])),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    SizedBox(width: 4),
                    Text(
                      "Rating: ${confirmedItem.rating ?? 'Not rated'}",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusAndActions(
      BuildContext context, ExchangeRequest exchangeRequest) {
    final currentUser = FirebaseAuth.instance.currentUser?.uid;

    return Column(
      children: [
        Text(
          "Status: ${exchangeRequest.status.toUpperCase()}",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: _getStatusColor(exchangeRequest.status),
          ),
        ),
        SizedBox(height: 16),
        if (exchangeRequest.status == 'pending' &&
            exchangeRequest.itemOwnerId == currentUser)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () =>
                    _updateStatus(context, 'accepted', exchangeRequest),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: Text("Accept"),
              ),
              ElevatedButton(
                onPressed: () =>
                    _updateStatus(context, 'declined', exchangeRequest),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text("Decline"),
              ),
            ],
          ),
        SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () => _startChat(context, exchangeRequest),
          icon: Icon(Icons.chat, color: Colors.white),
          label: Text(
              "Chat with ${_getChatButtonText(exchangeRequest, currentUser)}"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.blue;
      case 'accepted':
        return Colors.green;
      case 'declined':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getChatButtonText(ExchangeRequest request, String? currentUserId) {
    if (currentUserId == request.itemOwnerId) {
      return "Requester";
    } else {
      return "Owner";
    }
  }

  Future<void> _updateStatus(
      BuildContext context, String newStatus, ExchangeRequest request) async {
    try {
      // Update the request status
      await FirebaseFirestore.instance
          .collection('exchange_requests')
          .doc(request.requestId)
          .update({'status': newStatus});

      // If the status is 'accepted', adjust the stars
      if (newStatus == 'accepted') {
        await _adjustStarsForAcceptedRequest(request);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request ${newStatus}!')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update status: $e")),
      );
    }
  }

  Future<void> _adjustStarsForAcceptedRequest(ExchangeRequest request) async {
    try {
      // Check if both items exist
      if (request.offeredItemId == null) {
        return; // No offered item, so no star adjustment
      }

      // Get the requested item
      final requestedItemDoc = await FirebaseFirestore.instance
          .collection('confirmed_items')
          .doc(request.requestedItemId)
          .get();

      // Get the offered item
      final offeredItemDoc = await FirebaseFirestore.instance
          .collection('confirmed_items')
          .doc(request.offeredItemId)
          .get();

      if (!requestedItemDoc.exists || !offeredItemDoc.exists) {
        return; // One of the items doesn't exist
      }

      // Get the ratings of both items
      final requestedItemData = requestedItemDoc.data() as Map<String, dynamic>;
      final offeredItemData = offeredItemDoc.data() as Map<String, dynamic>;

      final requestedItemRating = requestedItemData['rating'] as num? ?? 3;
      final offeredItemRating = offeredItemData['rating'] as num? ?? 3;

      // Calculate the star difference
      final starDifference = offeredItemRating - requestedItemRating;

      // Update the requesting user's stars (increase)
      await _updateUserStars(request.requestingUserId, starDifference);

      // Update the item owner's stars (decrease)
      await _updateUserStars(request.itemOwnerId, -starDifference);

      // Log the star exchange
      await _logStarExchange(
        request.requestId,
        request.requestingUserId,
        request.itemOwnerId,
        starDifference,
      );
    } catch (e) {
      print("Error adjusting stars: $e");
    }
  }

  Future<void> _updateUserStars(String userId, num starDifference) async {
    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(userId);

    try {
      // Get the current user data
      final userDoc = await userDocRef.get();

      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        final currentStars = userData['stars'] as num? ?? 3;

        // Calculate new stars
        final newStars = currentStars + starDifference;

        // Update the user's stars
        await userDocRef.update({'stars': newStars});
      }
    } catch (e) {
      print("Error updating user stars for $userId: $e");
    }
  }

  Future<void> _logStarExchange(String requestId, String requestingUserId,
      String itemOwnerId, num starDifference) async {
    try {
      await FirebaseFirestore.instance.collection('star_exchanges').add({
        'requestId': requestId,
        'requestingUserId': requestingUserId,
        'itemOwnerId': itemOwnerId,
        'starDifference': starDifference,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error logging star exchange: $e");
    }
  }

  void _startChat(BuildContext context, ExchangeRequest request) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please log in to chat.')));
      return;
    }

    String currentUserId = user.uid;
    String otherUserId = currentUserId == request.itemOwnerId
        ? request.requestingUserId
        : request.itemOwnerId;

    if (currentUserId == otherUserId) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You cannot chat with yourself.')));
      return;
    }

    // Create a unique chat ID
    String chatId = currentUserId.hashCode <= otherUserId.hashCode
        ? '$currentUserId\_$otherUserId'
        : '$otherUserId\_$currentUserId';

    // Navigate to the ChatScreen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          chatId: chatId,
          otherUserId: otherUserId,
        ),
      ),
    );
  }
}
