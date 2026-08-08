import 'package:flutter/foundation.dart';
import 'product_variant_entity.dart';

/// Pure domain entity representing a product in a shop.
@immutable
class ProductEntity {
  final String id;
  final String shopId;
  final String productName;
  final String description;
  final String imageUrl;
  final List<ProductVariantEntity> variants;
  final DateTime createdAt;

  const ProductEntity({
    required this.id,
    required this.shopId,
    required this.productName,
    required this.description,
    required this.imageUrl,
    required this.variants,
    required this.createdAt,
  });

  /// Computes lowest selling price among all variants
  double get lowestPrice {
    if (variants.isEmpty) return 0.0;
    double minPrice = variants.first.sellPrice;
    for (var v in variants) {
      if (v.sellPrice < minPrice) minPrice = v.sellPrice;
    }
    return minPrice;
  }

  /// Returns true if all variant stock counts equal 0
  bool get isSoldOut {
    if (variants.isEmpty) return true;
    return variants.every((v) => v.stock <= 0);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          shopId == other.shopId &&
          productName == other.productName;

  @override
  int get hashCode => id.hashCode ^ shopId.hashCode ^ productName.hashCode;
}
