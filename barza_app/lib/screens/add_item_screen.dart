import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/item_service.dart';
import '../models/item_model.dart';

// Custom colors for app theme
const Color primaryColor = Color(0xFF0C969C);
const Color accentColor = Color(0xFF0C969C);
const Color backgroundColor = Color(0xFFF5F5F5);
const Color cardColor = Color(0xFFFFFFFF);
const Color errorColor = Color(0xFFE57373);
const Color successColor = Color(0xFF81C784);

class AddItemScreen extends StatefulWidget {
  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  // Form Key
  final _formKey = GlobalKey<FormState>();

  // Service
  final BarterItemService _itemService = BarterItemService();

  // Controllers
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _reasonForBarterController =
      TextEditingController();
  final TextEditingController _preferredExchangeController =
      TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  // Dropdown Values
  String? _selectedCategory;
  String? _selectedCondition;
  String? _selectedUsageDuration;
  String? _selectedContactMethod;

  // Image and Video Upload
  List<File> _images = [];
  File? _videoFile;
  final ImagePicker _picker = ImagePicker();

  // Other Settings
  bool _willingToAcceptMultipleOffers = false;
  bool _showContactInformation = false;

  // Loading state
  bool _isLoading = false;

  // Dropdown Lists
  final List<String> _categories = [
    'Clothing',
    'Electronics',
    'Books',
    'Furniture',
    'Watches',
    'Software Licenses',
    'Shoes',
    'Art & Collectibles',
    'Toys',
    'Gym Equipment'
  ];

  final List<String> _conditions = [
    'New',
    'Like New',
    'Good',
    'Fair',
    'Needs Repair'
  ];

  final List<String> _usageDurations = [
    'Less than 6 months',
    '6-12 months',
    '1-2 years',
    '2+ years'
  ];

  final List<String> _contactMethods = ['Chat Only', 'Phone Number', 'Email'];

  // Image Picker Method
  Future<void> _pickImages() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage(
      imageQuality: 80,
    );

    if (pickedFiles != null) {
      setState(() {
        _images = pickedFiles.map((file) => File(file.path)).toList();
      });
    }
  }

  // Video Picker Method
  Future<void> _pickVideo() async {
    final XFile? pickedFile = await _picker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(minutes: 2),
    );

    if (pickedFile != null) {
      setState(() {
        _videoFile = File(pickedFile.path);
      });
    }
  }

  // Submit Form
  Future<void> _submitForm() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate image upload
    if (_images.isEmpty || _images.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please upload at least 3 images'),
          backgroundColor: errorColor,
        ),
      );
      return;
    }

    // Validate image upload
    for (var image in _images) {
      if (!await image.exists()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Image file not found: ${image.path}'),
            backgroundColor: errorColor,
          ),
        );
        return;
      }
    }

    // Set loading state
    setState(() {
      _isLoading = true;
    });

    try {
      // Add item using service
      final result = await _itemService.addBarterItem(
        itemName: _itemNameController.text.trim(),
        category: _selectedCategory!,
        condition: _selectedCondition!,
        brand: _brandController.text.trim(),
        description: _descriptionController.text.trim(),
        usageDuration: _selectedUsageDuration!,
        reasonForBarter: _reasonForBarterController.text.trim(),
        images: _images,
        videoFile: _videoFile,
        preferredExchange: _preferredExchangeController.text.trim(),
        acceptMultipleOffers: _willingToAcceptMultipleOffers,
        exchangeLocation: _locationController.text.trim(),
        contactMethod: _selectedContactMethod!,
        showContactInfo: _showContactInformation,
      );

      // Handle result
      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Item Added Successfully!'),
            backgroundColor: successColor,
          ),
        );
        _resetForm();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add item'),
            backgroundColor: errorColor,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: errorColor,
        ),
      );
    } finally {
      // Reset loading state
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Reset Form
  void _resetForm() {
    _formKey.currentState?.reset();
    _itemNameController.clear();
    _brandController.clear();
    _descriptionController.clear();
    _reasonForBarterController.clear();
    _preferredExchangeController.clear();
    _locationController.clear();

    setState(() {
      _selectedCategory = null;
      _selectedCondition = null;
      _selectedUsageDuration = null;
      _selectedContactMethod = null;
      _images.clear();
      _videoFile = null;
      _willingToAcceptMultipleOffers = false;
      _showContactInformation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Add Barter Item',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/home');
          },
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: accentColor))
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header Card
                    Card(
                      elevation: 2,
                      color: cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Icon(Icons.swap_horiz,
                                size: 40, color: accentColor),
                            SizedBox(height: 8),
                            Text(
                              'Create a new barter listing',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Add details about your item to find the perfect exchange',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Item Basic Info Section
                    _buildSectionTitle('Basic Information'),
                    Card(
                      elevation: 1,
                      color: cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            // Item Name
                            TextFormField(
                              controller: _itemNameController,
                              decoration: _inputDecoration(
                                  'Item Name', Icons.inventory_2),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter item name';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16),

                            // Category Dropdown
                            DropdownButtonFormField<String>(
                              decoration:
                                  _inputDecoration('Category', Icons.category),
                              value: _selectedCategory,
                              items: _categories.map((category) {
                                return DropdownMenuItem(
                                  value: category,
                                  child: Text(category),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedCategory = value;
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select a category';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16),

                            // Condition Dropdown
                            DropdownButtonFormField<String>(
                              decoration: _inputDecoration(
                                  'Item Condition', Icons.star_rate),
                              value: _selectedCondition,
                              items: _conditions.map((condition) {
                                return DropdownMenuItem(
                                  value: condition,
                                  child: Text(condition),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedCondition = value;
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select item condition';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Item Details Section
                    _buildSectionTitle('Item Details'),
                    Card(
                      elevation: 1,
                      color: cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            // Brand
                            TextFormField(
                              controller: _brandController,
                              decoration: _inputDecoration(
                                  'Brand/Manufacturer (Optional)',
                                  Icons.business),
                            ),
                            SizedBox(height: 16),

                            // Description
                            TextFormField(
                              controller: _descriptionController,
                              decoration: _inputDecoration(
                                  'Detailed Description', Icons.description),
                              maxLines: 3,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please provide item description';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16),

                            // Usage Duration
                            DropdownButtonFormField<String>(
                              decoration: _inputDecoration(
                                  'Usage Duration', Icons.access_time),
                              value: _selectedUsageDuration,
                              items: _usageDurations.map((duration) {
                                return DropdownMenuItem(
                                  value: duration,
                                  child: Text(duration),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedUsageDuration = value;
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select usage duration';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16),

                            // Reason for Barter
                            TextFormField(
                              controller: _reasonForBarterController,
                              decoration: _inputDecoration(
                                  'Reason for Bartering (Optional)',
                                  Icons.swap_vert),
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Image Upload Section
                    _buildSectionTitle('Photos'),
                    Card(
                      elevation: 1,
                      color: cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(
                              'Upload Photos (3-6 images required)',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed: _pickImages,
                              icon: Icon(Icons.photo_library),
                              label: Text(
                                'Select Images',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accentColor,
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            SizedBox(height: 12),
                            if (_images.isNotEmpty)
                              Container(
                                height: 100,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _images.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.only(right: 8),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          _images[index],
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            else
                              Text(
                                'No images selected',
                                style: TextStyle(color: errorColor),
                              ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24),

                    // Submit Button
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Text(
                          'ADD BARTER ITEM',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }

  // Helper method for section titles
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
      ),
    );
  }

  // Helper method for input decoration
  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: accentColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: accentColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: errorColor),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

  @override
  void dispose() {
    // Dispose controllers
    _itemNameController.dispose();
    _brandController.dispose();
    _descriptionController.dispose();
    _reasonForBarterController.dispose();
    _preferredExchangeController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}
