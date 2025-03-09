import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClothingScreen extends StatelessWidget {
  Future<List<String>> _fetchImageUrls() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('barter_items')
        .where('category', isEqualTo: 'Clothing')
        .get();

    List<String> imageUrls = [];
    for (var doc in querySnapshot.docs) {
      List<String> urls = List<String>.from(doc['images']);
      if (urls.isNotEmpty) {
        imageUrls.add(urls.first); // Add only the first image URL
      }
    }
    return imageUrls;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clothing'),
      ),
      body: FutureBuilder<List<String>>(
        future: _fetchImageUrls(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No images found'));
          } else {
            final imageUrls = snapshot.data!;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                return Image.network(imageUrls[index]);
              },
            );
          }
        },
      ),
    );
  }
}