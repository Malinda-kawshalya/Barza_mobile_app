// categories_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/src/painting/border_radius.dart';
import '../widgets/bottom_navigationbar.dart';
import 'category_items_screen.dart'; // Import the new screen

class CategoryScreen extends StatefulWidget {
  CategoryScreen({super.key});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final List<Map<String, String>> categories = [
    {"name": "Clothing", "image": "assets/category/category of Cloths.jpg"},
    {
      "name": "Electronics",
      "image": "assets/category/category of electronic.png"
    },
    {"name": "Books", "image": "assets/category/category of books.png"},
    {"name": "Furniture", "image": "assets/category/category of furniture.png"},
    {"name": "Sports Items", "image": "assets/category/category of Sport.png"},
    {
      "name": "Software licenses",
      "image": "assets/category/category of software.png"
    },
    {
      "name": "Accessories",
      "image": "assets/category/category of Accessories.png"
    },
    {
      "name": "Art & Collectibles",
      "image": "assets/category/category of Art & Collectibles.png"
    },
    {"name": "Toys", "image": "assets/category/category of Toys.png"},
    {
      "name": "Gym Equipment",
      "image": "assets/category/category of Gym Equipment.png"
    },
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

  void _navigateToCategory(String categoryName) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              SpecificCategoryItemsScreen(category: categoryName)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 218, 230, 229),
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        backgroundColor: const Color(0xFF0C969C),
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
            color: Colors.white,
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
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              padding: EdgeInsets.symmetric(horizontal: 15),
              height: 50,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: "Search for items",
                        hintStyle: TextStyle(
                          color: const Color.fromARGB(255, 170, 167, 167),
                        ),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // This allows tapping the search icon to clear focus
                      FocusScope.of(context).unfocus();
                    },
                    child: Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.8,
                ),
                itemCount: filteredCategories.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () =>
                        _navigateToCategory(filteredCategories[index]['name']!),
                    child: CategoryCard(
                      imageUrl: filteredCategories[index]['image']!,
                      title: filteredCategories[index]['name']!,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 1,
        onItemTapped: (index) => _navigateToPage(context, index),
      ),
    );
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
      routeName = '/allitems';
    } else if (index == 4) {
      routeName = '/profile';
    }

    if (ModalRoute.of(context)?.settings.name != routeName) {
      Navigator.pushReplacementNamed(context, routeName);
    }
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
          Image.asset(
            imageUrl,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey,
                child: Center(
                  child: Icon(
                    Icons.broken_image,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              );
            },
          ),
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
