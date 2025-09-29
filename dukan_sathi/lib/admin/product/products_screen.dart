import 'dart:ui';
import 'package:dukan_sathi/admin/product/add_product_screen.dart'; // <-- 1. IMPORT the new screen
import 'package:flutter/material.dart';
import 'product_details_screen.dart';

// --- DATA MODELS ---
class ProductVariant {
  final String name;
  final double buyPrice;
  final double sellPrice;
  final int stock;

  const ProductVariant({
    required this.name,
    required this.buyPrice,
    required this.sellPrice,
    required this.stock,
  });
}

class Product {
  final String name;
  final String imageUrl;
  final bool isSoldOut;
  final List<ProductVariant> variants;

  const Product({
    required this.name,
    required this.imageUrl,
    this.isSoldOut = false,
    required this.variants,
  });

  double get lowestPrice =>
      variants.map((v) => v.sellPrice).reduce((a, b) => a < b ? a : b);
}

// --- MOCK DATA ---
final List<Product> mockProducts = [
  const Product(
    name: 'Chocolate Cake',
    imageUrl: 'https://placehold.co/400x400/5A3825/FFFFFF/png?text=Cake',
    variants: [
      ProductVariant(
        name: '1.5 KG',
        buyPrice: 50.00,
        sellPrice: 75.00,
        stock: 12,
      ),
      ProductVariant(
        name: '1 KG',
        buyPrice: 35.00,
        sellPrice: 50.00,
        stock: 20,
      ),
      ProductVariant(
        name: '500 GM',
        buyPrice: 20.00,
        sellPrice: 25.00,
        stock: 35,
      ),
    ],
  ),
  const Product(
    name: 'Strawberry Cake',
    imageUrl: 'https://placehold.co/400x400/DE3163/FFFFFF/png?text=Cake',
    isSoldOut: true,
    variants: [
      ProductVariant(name: '1 KG', buyPrice: 30.00, sellPrice: 40.00, stock: 0),
    ],
  ),
  // ... (rest of the mock data remains the same)
  const Product(
    name: 'Wheat Bread',
    imageUrl: 'https://placehold.co/400x400/AF8F6D/FFFFFF/png?text=Bread',
    variants: [
      ProductVariant(name: 'Loaf', buyPrice: 8.00, sellPrice: 10.00, stock: 50),
    ],
  ),
  const Product(
    name: 'Chocolate Pastry',
    imageUrl: 'https://placehold.co/400x400/6F4E37/FFFFFF/png?text=Pastry',
    isSoldOut: true,
    variants: [
      ProductVariant(name: 'Single', buyPrice: 2.00, sellPrice: 3.00, stock: 0),
    ],
  ),
  const Product(
    name: 'Croissant',
    imageUrl: 'https://placehold.co/400x400/D2B48C/FFFFFF/png?text=Croissant',
    variants: [
      ProductVariant(
        name: 'Single',
        buyPrice: 4.00,
        sellPrice: 6.00,
        stock: 150,
      ),
    ],
  ),
  const Product(
    name: 'Red Velvet Cupcake',
    imageUrl: 'https://placehold.co/400x400/9B1C31/FFFFFF/png?text=Cupcake',
    variants: [
      ProductVariant(
        name: 'Single',
        buyPrice: 5.00,
        sellPrice: 7.00,
        stock: 85,
      ),
      ProductVariant(
        name: 'Box of 4',
        buyPrice: 18.00,
        sellPrice: 25.00,
        stock: 20,
      ),
    ],
  ),
];

// --- WIDGETS ---

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        _buildAddProductButton(context), // <-- 2. PASS context
        Expanded(child: _buildProductsList()),
      ],
    );
  }

  Widget _buildHeader() {
    // ... (header code remains the same)
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
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w300,
              fontStyle: FontStyle.normal,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddProductButton(BuildContext context) {
    // <-- 2. RECEIVE context
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 16.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          // <-- 3. UPDATE onPressed
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddProductScreen()),
            );
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
    // ... (product list code remains the same)
    return Container(
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
            padding: EdgeInsets.symmetric(vertical: 16.0),
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
              padding: const EdgeInsets.all(16),
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
    // ... (product card code remains the same)
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(product: product),
          ),
        );
      },
      child: Container(
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
                    Image.network(product.imageUrl, fit: BoxFit.cover),
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
                      '\$${product.lowestPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSoldOutOverlay() {
    // ... (sold out overlay code remains the same)
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
        child: Container(
          color: Colors.black.withOpacity(0.3),
          alignment: Alignment.center,
          child: Transform.rotate(
            angle: -0.25,
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
