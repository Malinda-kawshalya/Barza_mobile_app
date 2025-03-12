import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class BuyStarsPage extends StatefulWidget {
  const BuyStarsPage({Key? key}) : super(key: key);

  @override
  _BuyStarsPageState createState() => _BuyStarsPageState();
}

class _BuyStarsPageState extends State<BuyStarsPage> {
  final _formKey = GlobalKey<FormState>();
  final _starsController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  int _selectedPackage = 100; // Default package size

  // Star packages
  final List<Map<String, dynamic>> _starPackages = [
    {'amount': 100, 'price': '\$0.99', 'popular': false},
    {'amount': 500, 'price': '\$3.99', 'popular': true},
    {'amount': 1000, 'price': '\$6.99', 'popular': false},
    {'amount': 5000, 'price': '\$29.99', 'popular': false},
  ];

  Future<void> _buyStars() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      int stars = _selectedPackage;

      // Update the user's stars in Firestore
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(userRef);
        if (!snapshot.exists) {
          throw Exception('User does not exist');
        }

        int currentStars = snapshot['stars'] ?? 0;
        transaction.update(userRef, {'stars': currentStars + stars});
      });

      // Store purchase details in Firestore
      await FirebaseFirestore.instance.collection('star_purchases').add({
        'userId': user.uid,
        'starsPurchased': stars,
        'price': _starPackages
            .firstWhere((package) => package['amount'] == stars)['price'],
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Simulate purchase delay
      await Future.delayed(const Duration(milliseconds: 800));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text('$stars stars purchased successfully!'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _starsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buy Stars', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF0C969C),
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header section
              Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Color(0xFF0C969C).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.stars_rounded,
                      size: 60,
                      color: Color(0xFFFFC107),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Purchase Stars',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'Stars can be used to unlock premium content and features',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              if (_errorMessage != null)
                Container(
                  margin: EdgeInsets.only(top: 16),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red.shade800),
                        ),
                      ),
                    ],
                  ),
                ),

              SizedBox(height: 24),
              Text(
                'Choose a Package',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),

              // Package selection
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: _starPackages.length,
                  itemBuilder: (context, index) {
                    final package = _starPackages[index];
                    final bool isSelected =
                        package['amount'] == _selectedPackage;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedPackage = package['amount'];
                        });
                      },
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? Color(0xFF0C969C)
                                    : Colors.grey.shade300,
                                width: isSelected ? 2 : 1,
                              ),
                              color: isSelected
                                  ? Color(0xFF0C969C).withOpacity(0.1)
                                  : Colors.white,
                            ),
                            padding: EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.star, color: Color(0xFFFFC107)),
                                    SizedBox(width: 4),
                                    Text(
                                      '${package['amount']}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text(
                                  package['price'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: isSelected
                                        ? Color(0xFF0C969C)
                                        : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (package['popular'])
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(12),
                                    bottomLeft: Radius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  'BEST DEAL',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          if (isSelected)
                            Positioned(
                              top: 10,
                              left: 10,
                              child: Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF0C969C),
                                ),
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _buyStars,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0C969C),
                  padding: EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: _isLoading
                    ? SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Purchase ${_selectedPackage} Stars',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
