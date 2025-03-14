import 'package:flutter/material.dart';
import '/screens/login_page.dart';
import '/screens/signup_page.dart';
import '/screens/home_screen.dart';
import '/screens/add_item_screen.dart';
import '/screens/user_profile.dart';
import '/screens/category_screen.dart';
import '/screens/settings_page.dart';
import '/screens/notification_screen.dart';
import '/screens/all_item_screen.dart';
import '/screens/feedback_form.dart';
import '/screens/password_security.dart';
import '/screens/privacy_permissions.dart';
import '/screens/buy_starts_page.dart';
import '/screens/chatList_screen.dart';
import '/screens/call_now_page.dart';
import '/screens/send_email.dart';
import '/screens/profile.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String additem = '/additem';
  static const String userprofile = '/userprofile';
  static const String profile = '/profile';
  static const String category = '/category';
  static const String wishlist = '/wishlist';
  static const String cart = '/cart';
  static const String settings = '/settings';
  static const String notification = '/notifications';
  static const String allitems = '/allitems';
  static const String feedback = '/feedback';
  static const String passwordsecurity = '/passwordsecurity';
  static const String privacypermissions = '/privacypermissions';
  static const String buystars = '/buystars';
  static const String chatlist = '/chatlist';
  static const String callnow = '/callnow';
  static const String sendemail = '/sendemail';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => LoginPage(),
    register: (context) => RegistrationScreen(),
    home: (context) => HomeScreen(),
    additem: (context) => AddItemScreen(),
    userprofile: (context) => UserProfileScreen(),
    profile: (context) => ProfileScreen(),
    category: (context) => CategoryScreen(),
    settings: (context) => SettingsPage(),
    notification: (context) => NotificationsScreen(),
    allitems: (context) => AllItemsScreen(),
    feedback: (context) => FeedbackForm(),
    passwordsecurity: (context) => PasswordSecurityPage(),
    privacypermissions: (context) => PrivacyPermissionsScreen(),
    buystars: (context) => BuyStarsPage(),
    chatlist: (context) => ChatListScreen(),
    callnow: (context) => CallPage(),
    sendemail: (context) => SendEmailPage(),
  };
}
