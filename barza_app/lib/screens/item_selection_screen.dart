import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemSelectionScreen extends StatelessWidget {
  final List<DocumentSnapshot> items;
  final Function(String) onItemSelected;

  ItemSelectionScreen({required this.items, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Item to Offer'),
        backgroundColor: Color(0xFF0C969C),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: items.length,
        itemBuilder: (context, index) {
          var itemData = items[index].data() as Map<String, dynamic>;
          List<dynamic> images = itemData['images'] ?? [];

          return Card(
            elevation: 2,
            margin: EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(12),
              leading: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: images.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(images[0]),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: images.isEmpty
                    ? Icon(Icons.image, color: Colors.grey)
                    : null,
              ),
              title: Text(
                itemData['itemName'] ?? 'Unknown Item',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(itemData['category'] ?? 'N/A'),
              onTap: () {
                onItemSelected(items[index].id);
              },
            ),
          );
        },
      ),
    );
  }

  
}
