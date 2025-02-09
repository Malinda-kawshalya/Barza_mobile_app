import 'package:flutter/material.dart';
import 'login_page.dart';
import 'helpCenter_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      theme: ThemeData(
        primaryColor: Color(0xFF0C969C), // Primary theme color
      ),
      initialRoute: '/login', // Set Login Page as the first screen
      routes: {
        '/login': (context) => LoginPage(), // Login Page route
        '/help-center': (context) => HelpCenterPage(), // Help Center Page route
      },
    );
  }
}
