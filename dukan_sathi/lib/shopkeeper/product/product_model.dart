import 'package:cloud_firestore/cloud_firestore.dart';

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

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'buyPrice': buyPrice,
      'sellPrice': sellPrice,
      'stock': stock,
    };
  }

  factory ProductVariant.fromMap(Map<String, dynamic> map) {
    return ProductVariant(
      name: map['name'] ?? '',
      buyPrice: (map['buyPrice'] ?? 0.0).toDouble(),
      sellPrice: (map['sellPrice'] ?? 0.0).toDouble(),
      stock: map['stock'] ?? 0,
    );
  }
}

class Product {
  final String id;
  final String shopId; // <--- 1. NEW FIELD ADDED
  final String productName;
  final String imageUrl;
  final String description;
  final List<ProductVariant> variants;

  bool get isSoldOut => variants.every((variant) => variant.stock == 0);

  double get lowestPrice {
    if (variants.isEmpty) return 0.0;
    return variants.map((v) => v.sellPrice).reduce((a, b) => a < b ? a : b);
  }

  const Product({
    required this.id,
    required this.shopId, // <--- 2. ADDED TO CONSTRUCTOR
    required this.productName,
    required this.imageUrl,
    required this.description,
    required this.variants,
  });

  factory Product.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snap) {
    final data = snap.data() ?? {};

    final variantData = data['variants'] as List<dynamic>? ?? [];

    // Safely parse variants
    final List<ProductVariant> parsedVariants = [];
    for (final v in variantData) {
      if (v is Map<String, dynamic>) {
        try {
          parsedVariants.add(ProductVariant.fromMap(v));
        } catch (e) {
          print('Failed to parse variant for product ${snap.id}: $e');
        }
      }
    }

    return Product(
      id: snap.id,
      // --- 3. THE MAGIC FIX ---
      // If 'shopId' exists in data, use it.
      // If NOT (old products), grab it from the database path: shops/{SHOP_ID}/products
      shopId: data['shopId'] ?? snap.reference.parent.parent?.id ?? '',
      productName: data['productName'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      description: data['description'] ?? '',
      variants: parsedVariants,
    );
  }
}
