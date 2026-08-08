import 'package:flutter/foundation.dart';

/// Pure domain entity representing a product variant item.
@immutable
class ProductVariantEntity {
  final String name;
  final double buyPrice;
  final double sellPrice;
  final int stock;

  const ProductVariantEntity({
    required this.name,
    required this.buyPrice,
    required this.sellPrice,
    required this.stock,
  });

  bool get isOutOfStock => stock <= 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductVariantEntity &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          sellPrice == other.sellPrice &&
          stock == other.stock;

  @override
  int get hashCode => name.hashCode ^ sellPrice.hashCode ^ stock.hashCode;
}
