import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/exchange_requests_model.dart';

class ItemDetailScreen extends StatefulWidget {
  final String itemId;

  const ItemDetailScreen({Key? key, required this.itemId}) : super(key: key);

  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  late Future<DocumentSnapshot> _itemFuture;

  @override
  void initState() {
    super.initState();
    _itemFuture = _fetchItemDetails();
  }

  Future<DocumentSnapshot> _fetchItemDetails() async {
    try {
      return await FirebaseFirestore.instance
          .collection('confirmed_items')
          .doc(widget.itemId)
          .get();
    } catch (e) {
      print('Error fetching item details: $e');
      throw Exception('Failed to load item details');
    }
  }

  void _sendExchangeRequest(Map<String, dynamic> itemData) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please log in to request an exchange.')));
        return;
      }

      String requestingUserId = user.uid;
      String itemOwnerId = itemData['userId'];

      if (requestingUserId == itemOwnerId) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('You cannot request an exchange for your own item.')));
        return;
      }

      // Fetch user's items from confirmed_items
      QuerySnapshot userItems = await FirebaseFirestore.instance
          .collection('confirmed_items')
          .where('userId', isEqualTo: requestingUserId)
          .get();

      if (userItems.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('You have no items to offer.')));
        return;
      }

      if (userItems.docs.length == 1) {
        // Only one item, use it directly
        String offeredItemId = userItems.docs.first.id;
        _createExchangeRequest(requestingUserId, widget.itemId, itemOwnerId, offeredItemId);
      } else {
        // Multiple items, show selection screen
        _showItemSelectionScreen(userItems.docs, requestingUserId, widget.itemId, itemOwnerId);
      }
    } catch (e) {
      print('Error sending exchange request: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send exchange request.')));
    }
  }

  void _createExchangeRequest(String requestingUserId, String requestedItemId, String itemOwnerId, String offeredItemId) async {
    ExchangeRequest exchangeRequest = ExchangeRequest(
      requestId: '',
      requestingUserId: requestingUserId,
      requestedItemId: requestedItemId,
      itemOwnerId: itemOwnerId,
      status: 'pending',
      timestamp: Timestamp.now(),
      offeredItemId: offeredItemId, // Add offeredItemId
    );

    await FirebaseFirestore.instance
        .collection('exchange_requests')
        .add(exchangeRequest.toMap());

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Exchange request sent!')));
  }

  void _showItemSelectionScreen(List<DocumentSnapshot> items, String requestingUserId, String requestedItemId, String itemOwnerId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemSelectionScreen(
          items: items,
          onItemSelected: (selectedItemId) {
            _createExchangeRequest(requestingUserId, requestedItemId, itemOwnerId, selectedItemId);
            Navigator.pop(context); // Close selection screen
          },
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item Details'),
        backgroundColor: Color(0xFF0C969C),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _itemFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.exists) {
            var itemData = snapshot.data!.data() as Map<String, dynamic>;
            List<dynamic> images = itemData['images'] ?? [];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
 Container(
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: images.isNotEmpty
                          ? Image.network(
                              images[0],
                              fit: BoxFit.cover,
                              width: double.infinity,
                            )
                          : Container(
                              color: Colors.grey[300],
                              child: Icon(Icons.image, size: 100, color: Colors.grey[600]),
                            ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    itemData['itemName'] ?? 'Unknown Item',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0C969C),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Category: ${itemData['category'] ?? 'N/A'}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Condition: ${itemData['condition'] ?? 'N/A'}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Rating: ${itemData['rating'] ?? 'No rating'} ⭐',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.amber[700],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'description: ${itemData['description'] ?? 'No comments'}',
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[700],
                    ),
                  ),
                  

                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _sendExchangeRequest(itemData), // Call sendExchangeRequest
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0C969C),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                    child: Text('Request Exchange', style: TextStyle(color: Colors.white)),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      print('chat with the owner: ${widget.itemId}');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0C969C),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                    child: Text('Chat with Owner', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('Item not found'));
          }
        },
      ),
    );
  }
}

class ItemSelectionScreen extends StatelessWidget {
  final List<DocumentSnapshot> items;
  final Function(String) onItemSelected;

  ItemSelectionScreen({required this.items, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Item to Offer')),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          var itemData = items[index].data() as Map<String, dynamic>;
          return ListTile(
            title: Text(itemData['itemName'] ?? 'Unknown Item'),
            onTap: () {
              onItemSelected(items[index].id);
            },
          );
        },
      ),
    );
  }
}