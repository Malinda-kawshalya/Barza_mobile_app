// specific_category_items_screen.dart
import 'package:flutter/material.dart';
import '../widgets/items.dart'; // Import your Items widget

class SpecificCategoryItemsScreen extends StatelessWidget {
  final String category;

  SpecificCategoryItemsScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: Items(category: category), // Pass the category here
    );
  }
}