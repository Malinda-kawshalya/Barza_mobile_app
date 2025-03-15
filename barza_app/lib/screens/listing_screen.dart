import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/confirmed_item_model.dart';
import 'item_detail_screen.dart';

class UserListingsScreen extends StatefulWidget {
  @override
  _UserListingsScreenState createState() => _UserListingsScreenState();
}

class _UserListingsScreenState extends State<UserListingsScreen> {
  late Future<List<ConfirmedItem>> _listingsFuture;

  @override
  void initState() {
    super.initState();
    _listingsFuture = _fetchUserListings();
  }

  Future<List<ConfirmedItem>> _fetchUserListings() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('confirmed_items')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .get();

      return snapshot.docs
          .map((doc) => ConfirmedItem.fromFirestore(doc))
          .toList();
    } catch (e) {
      print("Error fetching listings: $e");
      return [];
    }
  }

  Future<void> _deleteListing(String itemId) async {
    try {
      await FirebaseFirestore.instance
          .collection('confirmed_items')
          .doc(itemId)
          .delete();
      setState(() {
        _listingsFuture = _fetchUserListings(); // Refresh the listings
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Listing deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting listing: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Listings'),
        backgroundColor: Color(0xFF0C969C),
      ),
      body: FutureBuilder<List<ConfirmedItem>>(
        future: _listingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Failed to load listings: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.all(10),
              children: snapshot.data!.map((item) {
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
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _deleteListing(item.id!);
                                },
                              ),
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
            return Center(child: Text('No listings available'));
          }
        },
      ),
    );
  }
}
