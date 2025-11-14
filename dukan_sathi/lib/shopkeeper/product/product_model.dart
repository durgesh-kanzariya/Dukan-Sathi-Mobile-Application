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
  // Your sample data uses 'productName', your old model uses 'name'
  // I will use 'productName' to match your sample data.
  final String productName;
  final String imageUrl;
  final String description; // From your sample data
  final List<ProductVariant> variants;

  bool get isSoldOut => variants.every((variant) => variant.stock == 0);

  double get lowestPrice {
    if (variants.isEmpty) return 0.0;
    // Your sample data has 'price' at the top level, but your
    // model has it in the variants. I'll use the variants.
    return variants.map((v) => v.sellPrice).reduce((a, b) => a < b ? a : b);
  }

  const Product({
    required this.id,
    required this.productName,
    required this.imageUrl,
    required this.description,
    required this.variants,
  });

  factory Product.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snap) {
    final data = snap.data() ?? {};

    final variantData = data['variants'] as List<dynamic>? ?? [];

    // --- THIS IS THE FIX ---
    // We will safely parse the variants and skip any bad ones.
    final List<ProductVariant> parsedVariants = [];
    for (final v in variantData) {
      // Check if the item 'v' is actually a map
      if (v is Map<String, dynamic>) {
        try {
          // Try to parse it
          parsedVariants.add(ProductVariant.fromMap(v));
        } catch (e) {
          // If parsing fails, print an error but don't crash
          print('Failed to parse variant for product ${snap.id}: $e');
        }
      } else {
        // If 'v' is a String or something else, log it and skip
        print(
          'Skipping invalid variant data for product ${snap.id}. Expected Map, got ${v.runtimeType}',
        );
      }
    }
    // --- END OF FIX ---

    return Product(
      id: snap.id,
      productName: data['productName'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      description: data['description'] ?? '',
      variants: parsedVariants, // Use the safely parsed list
    );
  }
}
