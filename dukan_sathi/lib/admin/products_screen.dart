import 'dart:ui'; // Needed for the blur effect
import 'package:flutter/material.dart';

// --- DATA MODELS (Can be moved to their own file later) ---
class Product {
  final String name;
  final double price;
  final String imageUrl;
  final bool isSoldOut;

  const Product({
    required this.name,
    required this.price,
    required this.imageUrl,
    this.isSoldOut = false,
  });
}

// --- MOCK DATA ---
final List<Product> mockProducts = [
  const Product(
    name: 'Chocolate Cake',
    price: 50.00,
    imageUrl: 'https://placehold.co/200x200/5A3825/FFFFFF/png?text=Cake',
  ),
  const Product(
    name: 'Strawberry Cake',
    price: 40.00,
    imageUrl: 'https://placehold.co/200x200/DE3163/FFFFFF/png?text=Cake',
    isSoldOut: true,
  ),
  const Product(
    name: 'Wheat Bread',
    price: 10.00,
    imageUrl: 'https://placehold.co/200x200/AF8F6D/FFFFFF/png?text=Bread',
  ),
  const Product(
    name: 'Chocolate Pastry',
    price: 3.00,
    imageUrl: 'https://placehold.co/200x200/6F4E37/FFFFFF/png?text=Pastry',
    isSoldOut: true,
  ),
  const Product(
    name: 'Vanilla Muffin',
    price: 5.00,
    imageUrl: 'https://placehold.co/200x200/F3E5AB/000000/png?text=Muffin',
  ),
  const Product(
    name: 'Blueberry Bagel',
    price: 8.00,
    imageUrl: 'https://placehold.co/200x200/4682B4/FFFFFF/png?text=Bagel',
  ),
  const Product(
    name: 'Croissant',
    price: 6.00,
    imageUrl: 'https://placehold.co/200x200/EDDBC7/000000/png?text=Croissant',
  ),
  const Product(
    name: 'Red Velvet Cupcake',
    price: 7.00,
    imageUrl: 'https://placehold.co/200x200/9B1C31/FFFFFF/png?text=Cupcake',
    isSoldOut: true,
  ),
];
// --- END MOCK DATA ---

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        _buildAddProductButton(),
        Expanded(child: _buildProductsList()),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
      decoration: const BoxDecoration(
        color: Color(0xFF5A7D60),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'DUKAN SATHI',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  letterSpacing: 4,
                  fontFamily: "Abel",
                ),
              ),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  color: Color(0xFF5A7D60),
                  size: 28,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Products',
            style: TextStyle(color: Colors.white70, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildAddProductButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 16.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            // TODO: Add navigation to an "Add Product" page
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFB3C5B5),
            foregroundColor: const Color(0xFF2E4431),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          child: const Text('Add product'),
        ),
      ),
    );
  }

  Widget _buildProductsList() {
    return Container(
      // CHANGE 1: The bottom margin is increased to lift the container
      // above the bottom navigation bar.
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 85),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF5A7D60).withOpacity(0.9),
            const Color(0xFFB3C5B5).withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              'Products list',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const Divider(
            color: Colors.white70,
            thickness: 1,
            height: 1,
            indent: 16,
            endIndent: 16,
          ),
          Expanded(
            child: GridView.builder(
              // CHANGE 2: The bottom padding inside the grid is reduced because
              // the container's margin is now creating the necessary space.
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              itemCount: mockProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, index) {
                return _ProductCard(product: mockProducts[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  const _ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F2EF),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                  if (product.isSoldOut) _buildSoldOutOverlay(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSoldOutOverlay() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
        child: Container(
          color: Colors.black.withOpacity(0.3),
          alignment: Alignment.center,
          child: Transform.rotate(
            angle: -0.25, // -15 degrees in radians
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.8),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                'Sold Out',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
