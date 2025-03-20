import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:barza_app/models/profile_model.dart';
import 'package:barza_app/services/profile_service.dart';
import 'package:image_picker/image_picker.dart';
import 'buy_starts_page.dart'; // Import the BuyStarsPage
import '../widgets/bottom_navigationbar.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _userProfileService = UserProfileService();
  UserProfile? _userProfile;
  bool _isLoading = true;
  Map<String, bool> _isEditing = {
    'name': false,
    'phone': false,
    'address': false,
    'location': false,
  };
  int _ratingStars = 7; // Default rating

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

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
        _nameController.text = profile?.fullName ?? '';
        _phoneController.text = profile?.phoneNumber ?? '';
        _addressController.text = profile?.address ?? '';
        _locationController.text = profile?.location ?? '';
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

  Future<void> _pickImage() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      // User is not logged in, show a message or navigate to login
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please log in to update your profile photo.')),
      );
      // Optionally navigate to the login screen:
      // Navigator.of(context).pushReplacementNamed('/login');
      return; // Exit the method
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _isLoading = true;
      });
      try {
        await _userProfileService.updateProfilePhoto(File(pickedFile.path));
        _fetchUserProfile(); // Refresh profile after update
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading image: $e')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _updateProfile() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await _userProfileService.updateUserProfile(
        fullName: _nameController.text,
        phoneNumber: _phoneController.text,
        address: _addressController.text,
        location: _locationController.text,
      );
      _fetchUserProfile();
      setState(() {
        _isEditing = {
          'name': false,
          'phone': false,
          'address': false,
          'location': false,
        };
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
      setState(() {
        _isLoading = false;
      });
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
            Navigator.of(context).pushReplacementNamed('/profile');
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
                        GestureDetector(
                          onTap: _pickImage,
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

                    // Username and Stars
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _isEditing['name']!
                                ? Expanded(
                                    child: TextField(
                                      controller: _nameController,
                                      decoration: InputDecoration(
                                        hintText: 'Enter your name',
                                      ),
                                    ),
                                  )
                                : Text(
                                    _userProfile?.fullName ?? 'User',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.teal),
                              onPressed: () {
                                setState(() {
                                  _isEditing['name'] = true;
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
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

                    SizedBox(height: 30),

                    // Personal Information
                    _buildInfoItem(
                      context,
                      'Your Email',
                      _userProfile?.email ?? '',
                      Icons.email,
                      editable: false,
                    ),
                    _buildInfoItem(
                      context,
                      'Phone Number',
                      _phoneController.text,
                      Icons.phone,
                      controller: _phoneController,
                      editingKey: 'phone',
                    ),
                    _buildInfoItem(
                      context,
                      'Address',
                      _addressController.text,
                      Icons.home,
                      controller: _addressController,
                      editingKey: 'address',
                    ),
                    _buildInfoItem(
                      context,
                      'Location',
                      _locationController.text,
                      Icons.location_on,
                      controller: _locationController,
                      editingKey: 'location',
                    ),

                    // Update Button
                    if (_isEditing.containsValue(true))
                      Container(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _updateProfile,
                          child: Text(
                            'Update',
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

                    // Buy Stars Button
                    SizedBox(height: 20),
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
                          'Buy Stars',
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
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    String title,
    String value,
    IconData iconData, {
    bool editable = true,
    TextEditingController? controller,
    String? editingKey,
  }) {
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
        Row(
          children: [
            Expanded(
              child: Container(
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
                      child: editable && _isEditing[editingKey]!
                          ? TextField(
                              controller: controller,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter $title',
                              ),
                            )
                          : Text(
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
            ),
            if (editable)
              IconButton(
                icon: Icon(Icons.edit, color: Colors.teal),
                onPressed: () {
                  setState(() {
                    _isEditing[editingKey!] = true;
                  });
                },
              ),
          ],
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
