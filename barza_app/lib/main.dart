import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/login_page.dart';
import 'screens/helpCenter_page.dart';
import 'screens/get_started.dart';
import 'screens/user_profile.dart';
import 'screens/home_screen.dart';
import 'screens/item_screen.dart';
import 'screens/category_screen.dart';
import 'screens/settings_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      initialRoute: '/home',
      routes: {
        '/': (context) => GetStartedPage(),
        '/login': (context) => LoginPage(),
        '/help-center': (context) => HelpCenterPage(),
        '/user-profile': (context) => UserProfileScreen(),
        '/home': (context) => HomeScreen(),
        '/additem': (context) => AddItemScreen(),
        '/category': (context) => CategoryScreen(),
        '/settings': (context) => SettingsPage(),
      },
    );
  }
}
