import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/confirmed_item_model.dart';
import 'item_detail_screen.dart';

class AllItemsScreen extends StatefulWidget {
  const AllItemsScreen({Key? key}) : super(key: key);

  @override
  _AllItemsScreenState createState() => _AllItemsScreenState();
}

class _AllItemsScreenState extends State<AllItemsScreen> {
  late Future<List<ConfirmedItem>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _itemsFuture = _fetchItems();
  }

  Future<List<ConfirmedItem>> _fetchItems() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('confirmed_items')
          .orderBy('confirmedAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ConfirmedItem.fromFirestore(doc))
          .toList();
    } catch (e) {
      print("Error fetching items: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pushReplacementNamed('/home'),
        ),
        title: Text(
          'All Items',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF0C969C),
      ),
      body: FutureBuilder<List<ConfirmedItem>>(
        future: _itemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Failed to load items: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final items = snapshot.data!;
            return GridView.count(
              childAspectRatio: 0.68,
              crossAxisCount: 2,
              padding: EdgeInsets.all(10),
              children: items.map((item) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ItemDetailScreen(itemId: item.id!),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.8),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.favorite_border,
                                  color: Colors.red, size: 18),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.zero, bottom: Radius.circular(15)),
                            child: item.images.isNotEmpty
                                ? Image.network(
                                    item.images[0],
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    height: 100,
                                    color: Colors.grey[300],
                                    child: Icon(Icons.image,
                                        size: 50, color: Colors.grey[600]),
                                  ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.itemName,
                                style: TextStyle(
                                  color: Color.fromARGB(255, 2, 42, 44),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                item.category,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "Rating: ${item.rating.toString()} ⭐",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          } else {
            return Center(child: Text('No items available'));
          }
        },
      ),
    );
  }
}
