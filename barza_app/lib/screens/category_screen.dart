import 'package:flutter/material.dart';
import '../widgets/bottom_navigationbar.dart'; // Import the CustomBottomNavBar

class CategoryScreen extends StatefulWidget {
  CategoryScreen({super.key});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final List<Map<String, String>> categories = [
    {"name": "Cloths", "image": "assets/category/category of Cloths.jpg"},
    {"name": "Electronics", "image": "assets/category/category of electronic.png"},
    {"name": "Books", "image": "assets/category/category of books.png"},
    {"name": "Furniture", "image": "assets/category/category of furniture.png"},
    {"name": "Watches", "image": "assets/category/category of Watch.jpg"},
    {"name": "Software licenses", "image": "assets/category/category of software.png"},
    {"name": "Shoes", "image": "assets/category/category of shoes.png"},
    {"name": "Art & Collectibles", "image": "assets/category/category of Art & Collectibles.png"},
    {"name": "Toys", "image": "assets/category/category of Toys.png"},
    {"name": "Gym Equipment", "image": "assets/category/category of Gym Equipment.png"},
    {"name": "Toys", "image": "assets/category/category of Toys.png"},
    
  ];

  late List<Map<String, String>> filteredCategories;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredCategories = categories;
    searchController.addListener(_filterCategories);
  }

  @override
  void dispose() {
    searchController.removeListener(_filterCategories);
    searchController.dispose();
    super.dispose();
  }

  void _filterCategories() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredCategories = categories.where((category) {
        return category['name']!.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _navigateToPage(BuildContext context, int index) {
    String routeName = '';

    if (index == 0) {
      routeName = '/home';
    } else if (index == 1) {
      routeName = '/category';
    } else if (index == 2) {
      routeName = '/additem';
    } else if (index == 3) {
      routeName = '/wishlist';
    } else if (index == 4) {
      routeName = '/user-profile';
    }

    if (ModalRoute.of(context)?.settings.name != routeName) {
      Navigator.pushReplacementNamed(context, routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
        title: Text(
          'Category',
          style: TextStyle(
            color: Colors.teal,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Find Any Category',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 10),
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search more Category ...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.9,
                ),
                itemCount: filteredCategories.length,
                itemBuilder: (context, index) {
                  return CategoryCard(
                    imageUrl: filteredCategories[index]['image']!,
                    title: filteredCategories[index]['name']!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 1, // Highlight 'Category'
        onItemTapped: (index) => _navigateToPage(context, index),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String imageUrl;
  final String title;

  const CategoryCard({required this.imageUrl, required this.title});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: [
          Image.asset(imageUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover),
          Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.1),
                  Colors.black.withOpacity(0.6)
                ],
              ),
            ),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
