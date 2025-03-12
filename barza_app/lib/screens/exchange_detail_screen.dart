import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/confirmed_item_model.dart'; // Import your ConfirmedItem model
import '../models/exchange_requests_model.dart'; // Import your ExchangeRequest model

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
                Text(
                  "Request ID: ${exchangeRequest.requestId}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text("Requesting User ID: ${exchangeRequest.requestingUserId}"),
                SizedBox(height: 8),
                // Requested Item Details
                Text("Requested Item:"),
                FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('confirmed_items') // Corrected collection name
                      .doc(exchangeRequest.requestedItemId)
                      .get(),
                  builder: (context, itemSnapshot) {
                    if (itemSnapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (itemSnapshot.hasError || !itemSnapshot.hasData || !itemSnapshot.data!.exists) {
                      return Text("Requested item details not found");
                    }
                    final confirmedItem = ConfirmedItem.fromFirestore(itemSnapshot.data!);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (confirmedItem.images.isNotEmpty)
                          Image.network(confirmedItem.images[0], height: 100, width: double.infinity, fit: BoxFit.cover),
                        Text("Name: ${confirmedItem.itemName}"),
                        Text("Comment: ${confirmedItem.comment}"),
                      ],
                    );
                  },
                ),
                SizedBox(height: 16),
                // Offered Item Details
                Text("Offered Item:"),
                FutureBuilder<DocumentSnapshot>(
                  future: exchangeRequest.offeredItemId != null
                      ? FirebaseFirestore.instance
                          .collection('confirmed_items')
                          .doc(exchangeRequest.offeredItemId)
                          .get()
                      : Future.value(null),
                  builder: (context, offeredItemSnapshot) {
                    if (offeredItemSnapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (offeredItemSnapshot.hasError || offeredItemSnapshot.data == null || !offeredItemSnapshot.data!.exists) {
                      return Text("Offered item details not found");
                    }
                    final confirmedItem = ConfirmedItem.fromFirestore(offeredItemSnapshot.data!);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (confirmedItem.images.isNotEmpty)
                          Image.network(confirmedItem.images[0], height: 100, width: double.infinity, fit: BoxFit.cover),
                        Text("Name: ${confirmedItem.itemName}"),
                        Text("Comment: ${confirmedItem.comment}"),
                      ],
                    );
                  },
                ),
                SizedBox(height: 8),
                Text("Status: ${exchangeRequest.status}"),
                SizedBox(height: 24),
                if (exchangeRequest.status == 'pending' &&
                    exchangeRequest.itemOwnerId == FirebaseAuth.instance.currentUser?.uid)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => _updateStatus(context, 'accepted', exchangeRequest.requestId),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        child: Text("Accept"),
                      ),
                      ElevatedButton(
                        onPressed: () => _updateStatus(context, 'declined', exchangeRequest.requestId),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: Text("Decline"),
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _updateStatus(BuildContext context, String newStatus, String requestId) async {
    try {
      await FirebaseFirestore.instance
          .collection('exchange_requests')
          .doc(requestId)
          .update({'status': newStatus});

      Navigator.pop(context); // Go back after update
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to update status: $e"),
      ));
    }
  }
}