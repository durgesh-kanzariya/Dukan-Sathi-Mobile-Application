import 'package:flutter/foundation.dart';

/// Pure domain entity representing a saved recurring purchase item in Quick Purchase List.
@immutable
class QuickListItemEntity {
  final String productId;
  final String productName;
  final String imageUrl;
  final String shopId;
  final String shopName;
  final String variant;
  final double price;
  final int quantity;
  final DateTime addedAt;

  const QuickListItemEntity({
    required this.productId,
    required this.productName,
    required this.imageUrl,
    required this.shopId,
    required this.shopName,
    required this.variant,
    required this.price,
    required this.quantity,
    required this.addedAt,
  });

  QuickListItemEntity copyWith({
    int? quantity,
    String? variant,
    double? price,
  }) {
    return QuickListItemEntity(
      productId: productId,
      productName: productName,
      imageUrl: imageUrl,
      shopId: shopId,
      shopName: shopName,
      variant: variant ?? this.variant,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      addedAt: addedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuickListItemEntity &&
          runtimeType == other.runtimeType &&
          productId == other.productId &&
          variant == other.variant &&
          shopId == other.shopId;

  @override
  int get hashCode => productId.hashCode ^ variant.hashCode ^ shopId.hashCode;
}
