import 'package:flutter/material.dart';
import '../widgets/home_appbar.dart';
import '../widgets/category.dart';
import '../widgets/items.dart';
import '../widgets/bottom_navigationbar.dart';
import '../widgets/menu.dart';
import 'category_screen.dart';
import 'all_item_screen.dart'; // Import the category screen

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
      routeName = '/userprofile';
    }

    if (ModalRoute.of(context)?.settings.name != routeName) {
      Navigator.pushReplacementNamed(context, routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppbar.buildHomeAppbar(context),
      drawer: MenuWidget(), // Add the MenuWidget as the drawer

      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 25),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 218, 230, 229),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35),
              ),
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 5),
                        height: 40,
                        width: 300,
                        child: TextFormField(
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
                      Icon(
                        Icons.search,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Categories",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      IconButton(
                        icon:
                            Icon(Icons.arrow_forward_ios, color: Colors.black),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CategoryScreen()), // Use CategoryScreen
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Category(),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Recent Items",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      IconButton(
                        icon:
                            Icon(Icons.arrow_forward_ios, color: Colors.black),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AllItemsScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Items(),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 0, // Highlight 'Home'
        onItemTapped: (index) => _navigateToPage(context, index),
      ),
    );
  }
}
