import 'package:flutter/material.dart';

class Category extends StatelessWidget {
  final Function(String) onCategoryTap;

  Category({required this.onCategoryTap});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding:
          EdgeInsets.symmetric(horizontal: 10), // Add padding to the whole row
      child: Row(
        children: [
          _buildCategoryItem(
              context, 'assets/images/electronics.png', 'Electronics'),
          _buildCategoryItem(context, 'assets/images/cloths.png', 'Clothing'),
          _buildCategoryItem(context, 'assets/images/books.png', 'Books'),
          _buildCategoryItem(
              context, 'assets/images/furnitures.png', 'Furniture'),
          _buildCategoryItem(context, 'assets/images/sports.png', 'Sports'),
          _buildCategoryItem(context, 'assets/images/toys.png', 'Toys'),
          _buildCategoryItem(
              context, 'assets/images/accessories.png', 'Accessories'),
          /*_buildCategoryItem(context, 'assets/images/others.png', 'Others'),*/
        ],
      ),
    );
  }

  Widget _buildCategoryItem(
      BuildContext context, String imagePath, String categoryName) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: 8), // Reduced horizontal margin
      width: 100, // Fixed width for consistent sizing
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255), // White background
        borderRadius: BorderRadius.circular(15), // More rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8), // Subtle shadow
            spreadRadius: 1,
            blurRadius: 7,
            offset: Offset(0, 5), // changes position of shadow
          ),
        ],
      ),
      child: InkWell(
        // Make the container tappable
        onTap: () {
          onCategoryTap(
              categoryName); // Use the callback to handle category tap
        },
        child: Padding(
          padding:
              const EdgeInsets.all(4.0), // Add padding inside the container
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                height: 70,
                width: 80,
                fit: BoxFit
                    .contain, // Ensure the image fits within the container
              ),
              SizedBox(height: 10), // Add spacing between image and text
              Text(
                categoryName,
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0), // Consistent text color
                  fontSize: 16, // Reduced font size
                  fontWeight: FontWeight.w600, // Semi-bold font weight
                ),
                textAlign: TextAlign.center, // Center the text
              ),
            ],
          ),
        ),
      ),
    );
  }
}
