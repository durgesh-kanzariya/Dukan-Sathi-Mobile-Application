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

  // Convert a ProductVariant instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'buyPrice': buyPrice,
      'sellPrice': sellPrice,
      'stock': stock,
    };
  }

  // Create a ProductVariant instance from a Map
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
  final String id; // Document ID from Firestore
  final String name;
  final String imageUrl;
  final List<ProductVariant> variants;

  // Calculated property for isSoldOut
  bool get isSoldOut => variants.every((variant) => variant.stock == 0);

  // Calculated property for lowest price
  double get lowestPrice {
    if (variants.isEmpty) return 0.0;
    return variants.map((v) => v.sellPrice).reduce((a, b) => a < b ? a : b);
  }

  const Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.variants,
  });

  // Convert a Product instance to a Map for Firestore
  // Note: We don't save 'id' as a field, it's the document ID.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      // Convert list of variants to a list of maps
      'variants': variants.map((variant) => variant.toMap()).toList(),
      'createdAt':
          FieldValue.serverTimestamp(), // Good practice to timestamp
    };
  }

  // Create a Product instance from a Firestore DocumentSnapshot
  factory Product.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snap) {
    final data = snap.data() ?? {};
    final variantMaps = data['variants'] as List<dynamic>? ?? [];

    return Product(
      id: snap.id, // Get the document ID
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      variants: variantMaps
          .map((variantMap) =>
              ProductVariant.fromMap(variantMap as Map<String, dynamic>))
          .toList(),
    );
  }
}

