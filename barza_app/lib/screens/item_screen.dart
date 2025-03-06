import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/item_service.dart';
import '../models/item_model.dart';

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
  final TextEditingController _reasonForBarterController = TextEditingController();
  final TextEditingController _preferredExchangeController = TextEditingController();
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
    'Electronics', 'Clothing', 'Home Appliances', 
    'Books', 'Sports Equipment', 'Furniture', 
    'Collectibles', 'Other'
  ];

  final List<String> _conditions = [
    'New', 'Like New', 'Good', 'Fair', 'Needs Repair'
  ];

  final List<String> _usageDurations = [
    'Less than 6 months', '6-12 months', '1-2 years', '2+ years'
  ];

  final List<String> _contactMethods = [
    'Chat Only', 'Phone Number', 'Email'
  ];

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
    if (_images.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please upload at least 3 images'),
          backgroundColor: Colors.red,
        ),
      );
      return;
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
            backgroundColor: Colors.green,
          ),
        );
        _resetForm();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add item'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
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
      appBar: AppBar(
        title: Text('Add Barter Item'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
        Navigator.of(context).pushReplacementNamed('/home');
          },
        ),
      ),
      body: _isLoading 
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Item Name
                  TextFormField(
                    controller: _itemNameController,
                    decoration: InputDecoration(
                      labelText: 'Item Name',
                      border: OutlineInputBorder(),
                    ),
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
                    decoration: InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
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
                    decoration: InputDecoration(
                      labelText: 'Item Condition',
                      border: OutlineInputBorder(),
                    ),
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
                  SizedBox(height: 16),

                  // Brand
                  TextFormField(
                    controller: _brandController,
                    decoration: InputDecoration(
                      labelText: 'Brand/Manufacturer (Optional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Description
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Detailed Description',
                      border: OutlineInputBorder(),
                    ),
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
                    decoration: InputDecoration(
                      labelText: 'Usage Duration',
                      border: OutlineInputBorder(),
                    ),
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
                    decoration: InputDecoration(
                      labelText: 'Reason for Bartering (Optional)',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  SizedBox(height: 16),

                  // Image Upload Section
                  Text(
                    'Upload Photos (3-6 images required)',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  ElevatedButton.icon(
                    onPressed: _pickImages,
                    icon: Icon(Icons.photo_library),
                    label: Text('Select Images'),
                  ),
                  SizedBox(height: 8),
                  _images.isNotEmpty
                    ? Text('${_images.length} image(s) selected')
                    : Text('No images selected', style: TextStyle(color: Colors.red)),
                  
                  // Video Upload
                  SizedBox(height: 16),
                  Text(
                    'Upload Video (Optional)',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  ElevatedButton.icon(
                    onPressed: _pickVideo,
                    icon: Icon(Icons.video_call),
                    label: Text('Select Video'),
                  ),
                  SizedBox(height: 8),
                  _videoFile != null
                    ? Text('Video selected')
                    : Text('No video selected', style: TextStyle(color: Colors.grey)),
                  
                  // Preferred Exchange
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _preferredExchangeController,
                    decoration: InputDecoration(
                      labelText: 'Preferred Exchange Item',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please describe your preferred exchange item';
                      }
                      return null;
                    },
                  ),

                  // Multiple Offers Switch
                  SizedBox(height: 16),
                  SwitchListTile(
                    title: Text('Willing to Accept Multiple Offers'),
                    value: _willingToAcceptMultipleOffers,
                    onChanged: (bool value) {
                      setState(() {
                        _willingToAcceptMultipleOffers = value;
                      });
                    },
                  ),

                  // Exchange Location
                  TextFormField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      labelText: 'Exchange Location',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please provide exchange location';
                      }
                      return null;
                    },
                  ),

                  // Contact Method
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Contact Method',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedContactMethod,
                    items: _contactMethods.map((method) {
                      return DropdownMenuItem(
                        value: method,
                        child: Text(method),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedContactMethod = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a contact method';
                      }
                      return null;
                    },
                  ),

                  // Show Contact Info Switch
                  SwitchListTile(
                    title: Text('Show Contact Information'),
                    value: _showContactInformation,
                    onChanged: (bool value) {
                      setState(() {
                        _showContactInformation = value;
                      });
                    },
                  ),

                  // Submit Button
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Add Barter Item'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                ],
              ),
            ),
          ),
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