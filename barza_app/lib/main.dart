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
import 'screens/clothing_screen.dart';
import 'screens/electronics_screen.dart';
import 'screens/books_screen.dart';
import 'screens/furniture_screen.dart';
import 'screens/watches_screen.dart';
import 'screens/software_licenses_screen.dart';
import 'screens/shoes_screen.dart';
import 'screens/art_collectibles_screen.dart';
import 'screens/toys_screen.dart';
import 'screens/gym_equipment_screen.dart';

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
        '/clothing': (context) => ClothingScreen(),
        '/electronics': (context) => ElectronicsScreen(),
        '/books': (context) => BooksScreen(),
        '/furniture': (context) => FurnitureScreen(),
        '/watches': (context) => WatchesScreen(),
        '/software-licenses': (context) => SoftwareLicensesScreen(),
        '/shoes': (context) => ShoesScreen(),
        '/art-collectibles': (context) => ArtCollectiblesScreen(),
        '/toys': (context) => ToysScreen(),
        '/gym-equipment': (context) => GymEquipmentScreen(),
      },
    );
  }
}
