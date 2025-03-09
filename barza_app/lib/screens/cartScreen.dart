import 'package:flutter/material.dart';
/*import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, String>> cartItems = [];

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  // Load cart items from SharedPreferences
  Future<void> _loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String>? cartList = prefs.getStringList('cartItems');

      if (cartList != null) {
        setState(() {
          cartItems = cartList.map((item) {
            var parts = item.split(',');
            return {
              'name': parts[0],
              'image': parts[1],
              'description': parts[2],
              'vendorName': parts[3],
              'vendorAddress': parts[4],
              'quantity': parts[5],
            };
          }).toList();
        });
      }
    } catch (e) {
      print("Error loading cart items: $e");
    }
  }

  // Remove item from cart and SharedPreferences
  Future<void> _removeFromCart(int index) async {
    final prefs = await SharedPreferences.getInstance();

    // Remove item from the list
    cartItems.removeAt(index);

    // Save updated cart list back to SharedPreferences
    List<String> updatedCartList = cartItems.map((item) {
      return '${item['name']},${item['image']},${item['description']},${item['vendorName']},${item['vendorAddress']},${item['quantity']}';
    }).toList();

    await prefs.setStringList('cartItems', updatedCartList);

    // Update the UI
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Cart')),
      body: cartItems.isEmpty
          ? const Center(child: Text('Your cart is empty!'))
          : ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          var item = cartItems[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Image.asset(item['image'] ?? '', width: 60, fit: BoxFit.contain),
              title: Text(item['name'] ?? 'Product Name'),
              subtitle: Text('${item['description']}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Qty: ${item['quantity']}'),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      // Remove item from cart when delete button is pressed
                      _removeFromCart(index);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}*/
