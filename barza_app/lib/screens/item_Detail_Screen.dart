import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      return await FirebaseFirestore.instance.collection('confirmed_items').doc(widget.itemId).get();
    } catch (e) {
      print('Error fetching item details: $e');
      throw Exception('Failed to load item details');
    }
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
                    'Comment: ${itemData['comment'] ?? 'No comments'}',
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Confirmed On: ${(itemData['confirmedAt'] as Timestamp?)?.toDate().toString().split(" ")[0] ?? 'N/A'}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      print('Exchange request sent for item: ${widget.itemId}');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0C969C),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                    child: Text('Request Exchange', style: TextStyle(color: Colors.white)),
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
