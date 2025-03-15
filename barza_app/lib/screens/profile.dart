import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:barza_app/models/profile_model.dart';
import 'package:barza_app/services/profile_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import './buy_starts_page.dart'; // Import the BuyStarsPage
import '../widgets/bottom_navigationbar.dart';
import 'user_profile.dart'; // Import the UserProfileScreen
import 'listing_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _userProfileService = UserProfileService();
  UserProfile? _userProfile;
  bool _isLoading = true;
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
              Navigator.of(context).pushNamed('/settings');
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
                    // Profile avatar and user info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[300],
                          ),
                          child: Center(
                            child: _userProfile?.profileImageUrl != null
                                ? CircleAvatar(
                                    radius: 50,
                                    backgroundImage: NetworkImage(
                                        _userProfile!.profileImageUrl!),
                                  )
                                : Icon(
                                    Icons.person,
                                    size: 80,
                                    color: Colors.pink,
                                  ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UserProfileScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  _userProfile?.fullName ??
                                      'User', // Display fullName
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                _userProfile?.email ?? 'xxx@gmail.com',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 5),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UserProfileScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Edit Profile',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.teal,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              // Rating stars
                               Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 24),
                            SizedBox(width: 5),
                            Text(
                              '${_userProfile?.stars ?? 0} Stars', // Display the user's stars
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                          ],
                        ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),

                    // Total Exchanges
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Total Exchanges >',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),

                    // Exchanges and Listings
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildProfileOption(
                          context,
                          'Exchanges',
                          Icons.swap_horiz,
                          Colors.teal,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserListingsScreen(),
                              ),
                            );
                          },
                          child: _buildProfileOption(
                            context,
                            'Listings',
                            Icons.list,
                            Colors.teal,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // History, Wish List, Coupons, Cards
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildProfileOption(
                          context,
                          'History',
                          Icons.history,
                          Colors.teal,
                        ),
                        _buildProfileOption(
                          context,
                          'Wish List',
                          Icons.favorite_border,
                          Colors.teal,
                        ),
                        _buildProfileOption(
                          context,
                          'Coupons',
                          Icons.card_giftcard,
                          Colors.teal,
                        ),
                        _buildProfileOption(
                          context,
                          'Cards',
                          Icons.credit_card,
                          Colors.teal,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Buy More Stars Button
                    Container(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BuyStarsPage(),
                            ),
                          );
                        },
                        child: Text(
                          'BUY MORE STARS >',
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
                    SizedBox(height: 20),

                    // Help Center
                    Container(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to Help Center
                        },
                        child: Text(
                          'Help Center\nNeed Help? Talk to us',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
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
        selectedIndex: 4, // Highlight 'Profile'
        onItemTapped: (index) => _navigateToPage(context, index),
      ),
    );
  }

  Widget _buildProfileOption(
    BuildContext context,
    String title,
    IconData iconData,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            iconData,
            color: color,
            size: 30,
          ),
        ),
        SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
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
    routeName = '/allitems';
  } else if (index == 4) {
    routeName = '/profile';
  }

  if (ModalRoute.of(context)?.settings.name != routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }
}
