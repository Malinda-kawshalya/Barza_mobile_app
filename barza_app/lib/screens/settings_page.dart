import 'package:flutter/material.dart';

void main() {
  runApp(SettingsApp());
}

class SettingsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SettingsPage(),
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEAF9F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            color: Colors.teal, 
            fontSize: 24, 
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          SettingsSection(title: 'App Settings', items: [
            SettingsItem(icon: Icons.person, title: 'Personal Information', subtitle: 'Your account information'),
            SettingsItem(icon: Icons.notifications, title: 'Notifications & Chat', subtitle: 'Chat and notifications settings'),
            SettingsItem(icon: Icons.lock, title: 'Privacy & Permissions', subtitle: 'Contact, My Album and Block Contact'),
            SettingsItem(icon: Icons.storage, title: 'Data & Storage', subtitle: 'Data preferences and storage settings'),
            SettingsItem(icon: Icons.security, title: 'Password & Account', subtitle: 'Manage your Account settings'),
          ]),
          SettingsSection(title: 'More', items: [
            SettingsItem(icon: Icons.help, title: 'Help', subtitle: 'Data preferences and storage settings'),
            SettingsItem(icon: Icons.feedback, title: 'Feedback', subtitle: 'Chat and notifications settings'),
            SettingsItem(icon: Icons.info, title: 'About', subtitle: 'Version 1.2.'),
            SettingsItem(icon: Icons.share, title: 'Invite a Friend', subtitle: 'Invite a friend to make this app'),
          ]),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'My Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Wishlist'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class SettingsSection extends StatelessWidget {
  final String title;
  final List<SettingsItem> items;

  SettingsSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[700]),
          ),
        ),
        ...items,
        SizedBox(height: 16),
      ],
    );
  }
}

class SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  SettingsItem({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[600])),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () {},
    );
  }
}
