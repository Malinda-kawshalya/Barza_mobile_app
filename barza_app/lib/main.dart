import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:barza_app/services/routes/routes.dart';


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
      initialRoute: AppRoutes.home,
      routes: AppRoutes.routes,
        
      
    );
  }
}
