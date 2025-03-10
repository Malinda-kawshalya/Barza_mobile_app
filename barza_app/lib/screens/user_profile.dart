import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:barza_app/models/profile_model.dart';
import 'package:barza_app/services/profile_service.dart';
import '../widgets/bottom_navigationbar.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _userProfileService = UserProfileService();
  UserProfile? _userProfile;
  bool _isLoading = true;
  String _username = 'User4102'; // Default username
  int _ratingStars = 7; // Default rating

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final profile = await _userProfileService.fetchUserProfile();
      setState(() {
        _userProfile = profile;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading profile: $e')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE0F7F3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.teal),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/home');
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.teal),
            onPressed: () {
              // Navigate to settings screen
              // Navigator.of(context).pushNamed('/settings');
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.teal))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    // Profile avatar with edit button
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[300],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.person,
                              size: 80,
                              color: Colors.pink,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Add functionality to edit profile picture
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.orange,
                            ),
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),

                    // Username
                    Text(
                      _username,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // Stars/Rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _ratingStars,
                        (index) =>
                            Icon(Icons.star, color: Colors.amber, size: 20),
                      ),
                    ),
                    SizedBox(height: 30),

                    // Personal Information
                    _buildInfoItem(
                      context,
                      'Your Email',
                      _userProfile?.email ?? '',
                      Icons.email,
                    ),
                    _buildInfoItem(
                      context,
                      'Phone Number',
                      _userProfile?.phoneNumber ?? '',
                      Icons.phone,
                    ),
                    _buildInfoItem(
                      context,
                      'Address',
                      _userProfile?.address ?? '',
                      Icons.email,
                    ),
                    _buildInfoItem(
                      context,
                      'Location',
                      _userProfile?.location ?? '',
                      Icons.location_on,
                    ),

                    // Logout Button
                    SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _signOut,
                        child: Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 4, // Highlight 'Home'
        onItemTapped: (index) => _navigateToPage(context, index),
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    String title,
    String value,
    IconData iconData,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  iconData,
                  color: Colors.teal,
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    color: Colors.teal,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}

void _navigateToPage(BuildContext context, int index) {
  String routeName = '';

  if (index == 0) {
    routeName = '/home';
  } else if (index == 1) {
    routeName = '/category';
  } else if (index == 2) {
    routeName = '/additem';
  } else if (index == 3) {
    routeName = '/wishlist';
  } else if (index == 4) {
    routeName = '/userprofile';
  }

  if (ModalRoute.of(context)?.settings.name != routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }
}
