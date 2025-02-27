import 'package:flutter/material.dart';
import 'screens/login_page.dart';
import 'screens/helpCenter_page.dart';
import 'screens/get_started.dart';

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
        primaryColor: Color(0xFF0C969C),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => GetStartedPage(),
        '/login': (context) => LoginPage(),
        '/help-center': (context) => HelpCenterPage(),
      },
    );
  }
}
