import 'package:flutter/material.dart';
//import '../screens/cart_screen.dart'; // Import the CartScreen

class HomeAppbar {
  static AppBar buildHomeAppbar(BuildContext context) {
    return AppBar(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(35),
          bottomRight: Radius.circular(35),
        ),
      ),
      backgroundColor: const Color(0xFF0C969C),
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false, // Removes the back button
      toolbarHeight: 100, // Increases the height of the AppBar
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "BarZar",
            style: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      leading: Builder( // Wrap IconButton with Builder
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.menu, color: Colors.black, size: 30),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Open the drawer
            },
          );
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.shopping_cart_checkout_outlined,
              color: Colors.black, size: 30),
          onPressed: () {
           
          },
        ),
      ],
    );
  }
}