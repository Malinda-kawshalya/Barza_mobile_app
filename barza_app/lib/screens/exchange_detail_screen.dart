import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/confirmed_item_model.dart';
import '../models/exchange_requests_model.dart';
import '../services/chat_service.dart';
import 'chat_screen.dart';

class ExchangeRequestDetailsScreen extends StatelessWidget {
  final String exchangeRequestId;

  ExchangeRequestDetailsScreen({required this.exchangeRequestId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Exchange Request Details"),
        backgroundColor: Color(0xFF0C969C),
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
        if (itemSnapshot.hasError || !itemSnapshot.hasData || !itemSnapshot.data!.exists) {
          return Text("Item details not found",
              style: TextStyle(color: Colors.red, fontStyle: FontStyle.italic));
        }
        final confirmedItem = ConfirmedItem.fromFirestore(itemSnapshot.data!);
        return Card(
          elevation: 3,
          margin: EdgeInsets.only(top: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                Text(confirmedItem.description,
                    style: TextStyle(color: Colors.grey[700])),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusAndActions(BuildContext context, ExchangeRequest exchangeRequest) {
    final currentUser = FirebaseAuth.instance.currentUser?.uid;

    return Column(
      children: [
        Text("Status: ${exchangeRequest.status}",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),

        SizedBox(height: 16),

        if (exchangeRequest.status == 'pending' && exchangeRequest.itemOwnerId == currentUser)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _updateStatus(context, 'accepted', exchangeRequest),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: Text("Accept"),
              ),
              ElevatedButton(
                onPressed: () => _updateStatus(context, 'declined', exchangeRequest),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text("Decline"),
              ),
            ],
          ),

        if (exchangeRequest.status == 'accepted')
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton.icon(
              onPressed: () => openChat(context, exchangeRequest),
              icon: Icon(Icons.chat, color: Colors.white),
              label: Text("Chat with User"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0C969C),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ),
      ],
    );
  }

  void _updateStatus(BuildContext context, String newStatus, ExchangeRequest request) async {
    try {
      await FirebaseFirestore.instance
          .collection('exchange_requests')
          .doc(request.requestId)
          .update({'status': newStatus});

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to update status: $e"),
      ));
    }
  }

  String getChatId(String user1, String user2) {
    List<String> sortedUsers = [user1, user2]..sort();
    return "${sortedUsers[0]}_${sortedUsers[1]}";
  }

  void openChat(BuildContext context, ExchangeRequest exchangeRequest) {
    String chatId = getChatId(exchangeRequest.requestingUserId, exchangeRequest.itemOwnerId);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          chatId: chatId,
          otherUserId: exchangeRequest.itemOwnerId, 
        ),
      ),
    );
  }
}
