import 'package:flutter/material.dart';

import 'login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0AB0A9),
          primary: const Color(0xFF0AB0A9),
        ),
      ),
      home: const RegistrationScreen(),
    );
  }
}

class GoogleFonts {
  static poppinsTextTheme() {}
}

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 232, 238, 238),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0C969C)),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
          },
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 232, 238, 238),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                Center(
                  child: Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                _buildTextField('Full Name', false),
                const SizedBox(height: 16),
                _buildTextField('Address', false),
                const SizedBox(height: 16),
                _buildTextField('E-Mail', false),
                const SizedBox(height: 16),
                _buildTextField('Password', true),
                const SizedBox(height: 16),
                _buildTextField('Confirm Password', true),
                const SizedBox(height: 30),
                _buildSignUpButton(context),
                const SizedBox(height: 20),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Text(
                      'Already have an account',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'Or continue with',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildSocialButtons(context),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, bool isPassword) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF0AB0A9),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            obscureText: isPassword,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: InputBorder.none,
              hintText: label,
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Add sign up functionality here
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFF0AB0A9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            'Sign up',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialButton('G', Colors.white),
        const SizedBox(width: 16),
        _buildSocialButton('f', Colors.white),
        const SizedBox(width: 16),
        _buildSocialButton('', Colors.white, isApple: true),
      ],
    );
  }

  Widget _buildSocialButton(String label, Color color, {bool isApple = false}) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: const Color(0xFF0AB0A9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: isApple
            ? const Icon(Icons.apple, color: Colors.white, size: 24)
            : Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
