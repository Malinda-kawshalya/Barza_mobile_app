import 'package:flutter/material.dart';
//import 'package:shared_preferences/shared_preferences.dart';
/*import 'CartScreen.dart';
import 'Product.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({Key? key, required this.product}) : super(key: key);

  Future<void> addToCart() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? cartList = prefs.getStringList('cartItems') ?? [];
    String productString = '${product.name},${product.image},${product.description},${product.vendorName},${product.vendorAddress},1';
    cartList.add(productString);
    await prefs.setStringList('cartItems', cartList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Item Details',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                height: 200,
                margin: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
                ),
                child: Image.asset(product.image, fit: BoxFit.contain),
              ),
              const SizedBox(height: 8),
              Text(
                product.description,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black87, height: 1.5),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Condition: Used', style: TextStyle(fontSize: 14, color: Colors.black54)),
                  const Spacer(),
                  Row(
                    children: List.generate(5, (index) => const Icon(Icons.star, color: Colors.amber, size: 18)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(thickness: 1, color: Colors.grey, height: 32),
              const Text('Vendor Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
              const SizedBox(height: 8),
              Text('Vendor: ${product.vendorName}', style: const TextStyle(fontSize: 14, color: Colors.black54)),
              const SizedBox(height: 8),
              Text('Address: ${product.vendorAddress}', style: const TextStyle(fontSize: 14, color: Colors.black54)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text('Send Request'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  addToCart();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product added to cart!')));
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text('Add To Cart'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/