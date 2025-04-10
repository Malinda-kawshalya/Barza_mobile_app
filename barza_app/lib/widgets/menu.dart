import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF0C969C),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'BarZar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                Text(
                  'Welcome! ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          ListTile(
            leading: Icon(Icons.category),
            title: Text('Categories'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/category');
            },
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Add Item'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/additem');
            },
          ),
          ListTile(
            leading: Icon(Icons.chat),
            title: Text('Chats'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/chatlist');
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/userprofile');
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/settings');
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () async {
              Navigator.pop(context); // Close the current drawer or screen

              // Implement logout functionality by calling the imported top-level function
              try {
                await AuthService().signOut(); // Create an instance to call the method
                Navigator.pushReplacementNamed(context, '/login'); // Navigate to login screen
              } catch (e) {
                print("Error signing out: $e");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error during logout. Please try again.')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}