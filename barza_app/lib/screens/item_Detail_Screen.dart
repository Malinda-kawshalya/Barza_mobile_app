import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/exchange_requests_model.dart';
import 'chat_screen.dart';
import 'item_selection_screen.dart';

class ItemDetailScreen extends StatefulWidget {
  final String itemId;

  const ItemDetailScreen({Key? key, required this.itemId}) : super(key: key);

  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  late Future<DocumentSnapshot> _itemFuture;
  int _currentImageIndex = 0;

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
            content:
                Text('You cannot request an exchange for your own item.')));
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
        _createExchangeRequest(
            requestingUserId, widget.itemId, itemOwnerId, offeredItemId);
      } else {
        // Multiple items, show selection screen
        _showItemSelectionScreen(
            userItems.docs, requestingUserId, widget.itemId, itemOwnerId);
      }
    } catch (e) {
      print('Error sending exchange request: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send exchange request.')));
    }
  }

  void _createExchangeRequest(String requestingUserId, String requestedItemId,
      String itemOwnerId, String offeredItemId) async {
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

  void _showItemSelectionScreen(List<DocumentSnapshot> items,
      String requestingUserId, String requestedItemId, String itemOwnerId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemSelectionScreen(
          items: items,
          onItemSelected: (selectedItemId) {
            _createExchangeRequest(
                requestingUserId, requestedItemId, itemOwnerId, selectedItemId);
            Navigator.pop(context); // Close selection screen
          },
        ),
      ),
    );
  }

  void _startChat(String itemOwnerId) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please log in to chat with the owner.')));
      return;
    }

    String currentUserId = user.uid;
    if (currentUserId == itemOwnerId) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You cannot chat with yourself.')));
      return;
    }

    // Create a unique chat ID
    String chatId = currentUserId.hashCode <= itemOwnerId.hashCode
        ? '$currentUserId\_$itemOwnerId'
        : '$itemOwnerId\_$currentUserId';

    // Navigate to the ChatScreen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          chatId: chatId,
          otherUserId: itemOwnerId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 350.0,
                  floating: false,
                  pinned: true,
                  backgroundColor: Color(0xFF0C969C),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      children: [
                        PageView.builder(
                          itemCount: images.isEmpty ? 1 : images.length,
                          onPageChanged: (index) {
                            setState(() {
                              _currentImageIndex = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return images.isNotEmpty
                                ? Image.network(
                                    images[index],
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    color: Colors.grey[200],
                                    child: Icon(Icons.image_not_supported,
                                        size: 100, color: Colors.grey[400]),
                                  );
                          },
                        ),
                        if (images.length > 1)
                          Positioned(
                            bottom: 16,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                images.length,
                                (index) => Container(
                                  width: 8,
                                  height: 8,
                                  margin: EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _currentImageIndex == index
                                        ? Color(0xFF0C969C)
                                        : Colors.white.withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                itemData['itemName'] ?? 'Unknown Item',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Color(0xFF0C969C).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.star,
                                      color: Colors.amber, size: 20),
                                  SizedBox(width: 4),
                                  Text(
                                    itemData['rating']?.toString() ?? 'N/A',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0C969C),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _buildChip(
                                Icons.category, itemData['category'] ?? 'N/A'),
                            _buildChip(Icons.check_circle,
                                itemData['condition'] ?? 'N/A'),
                          ],
                        ),
                        SizedBox(height: 24),
                        Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            itemData['description'] ??
                                'No description available.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              height: 1.5,
                            ),
                          ),
                        ),
                        SizedBox(height: 32),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  // Fetch user's stars and convert to double
                                  DocumentSnapshot userDoc =
                                      await FirebaseFirestore
                                          .instance
                                          .collection('users')
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .get();

                                  // Convert user stars to double
                                  double userStars = 0.0;
                                  var userStarsData = (userDoc.data()
                                      as Map<String, dynamic>)['stars'];
                                  
                                  if (userStarsData is int) {
                                    userStars = userStarsData.toDouble();
                                  } else if (userStarsData is double) {
                                    userStars = userStarsData;
                                  }

                                  // Convert item rating to double
                                  double itemRating = 0.0;
                                  var itemRatingData = itemData['rating'];
                                  
                                  if (itemRatingData is int) {
                                    itemRating = itemRatingData.toDouble();
                                  } else if (itemRatingData is double) {
                                    itemRating = itemRatingData;
                                  }

                                  if (userStars >= itemRating) {
                                    _sendExchangeRequest(itemData);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'You need at least ${itemRating.toStringAsFixed(1)} stars to request this item.',
                                        ),
                                      ),
                                    );
                                  }
                                },
                                icon:
                                    Icon(Icons.swap_horiz, color: Colors.white),
                                label: Text('Request Exchange',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF0C969C),
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 2,
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                onPressed: () => _startChat(itemData['userId']),
                                icon: Icon(Icons.chat_bubble_outline,
                                    color: Color(0xFF0C969C), size: 28),
                                padding: EdgeInsets.all(12),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Text('Item not found'));
          }
        },
      ),
    );
  }

  Widget _buildChip(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Color(0xFF0C969C)),
          SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}