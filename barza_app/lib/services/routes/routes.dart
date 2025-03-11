import 'package:flutter/material.dart';
import '/screens/login_page.dart';
import '/screens/signup_page.dart';
import '/screens/home_screen.dart'; 
import '/screens/add_item_screen.dart';
import '/screens/user_profile.dart';
import '/screens/category_screen.dart';
import '/screens/settings_page.dart';
import '/screens/notification_screen.dart';
//import '/screens/wishlist_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home'; 
  static const String additem = '/additem';
  static const String userprofile = '/userprofile';
  static const String category = '/category';
  static const String wishlist = '/wishlist';
  static const String cart = '/cart';
  static const String settings = '/settings';
  static const String notification = '/notifications';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => LoginPage(),
    register: (context) => RegistrationScreen(),
    home: (context) => HomeScreen(), 
    additem: (context) => AddItemScreen(),
    userprofile: (context) => UserProfileScreen(),
    category: (context) => CategoryScreen(),
    settings: (context) => SettingsPage(),
    notification: (context) => NotificationsScreen()
    //wishlist: (context) => WishlistScreen(),
  };
}