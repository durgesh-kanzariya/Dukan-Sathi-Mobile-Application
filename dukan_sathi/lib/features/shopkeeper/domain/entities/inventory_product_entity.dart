import 'package:flutter/foundation.dart';
import '../../../customer/discovery/domain/entities/product_variant_entity.dart';

/// Pure domain entity representing a product in the shopkeeper's inventory.
@immutable
class InventoryProductEntity {
  final String id;
  final String shopId;
  final String productName;
  final String description;
  final String imageUrl;
  final String category;
  final List<ProductVariantEntity> variants;
  final DateTime createdAt;

  const InventoryProductEntity({
    required this.id,
    required this.shopId,
    required this.productName,
    required this.description,
    required this.imageUrl,
    this.category = 'General Store',
    required this.variants,
    required this.createdAt,
  });

  /// Minimum price among variants
  double get minPrice {
    if (variants.isEmpty) return 0.0;
    return variants.map((v) => v.sellPrice).reduce((a, b) => a < b ? a : b);
  }

  /// Total sum of stock across all variants
  int get totalStock => variants.fold(0, (sum, v) => sum + v.stock);

  /// Low stock warning indicator (stock < 5)
  bool get isLowStock => totalStock > 0 && totalStock <= 5;

  /// Out of stock indicator
  bool get isOutOfStock => totalStock <= 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InventoryProductEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          shopId == other.shopId;

  @override
  int get hashCode => id.hashCode ^ shopId.hashCode;
}
