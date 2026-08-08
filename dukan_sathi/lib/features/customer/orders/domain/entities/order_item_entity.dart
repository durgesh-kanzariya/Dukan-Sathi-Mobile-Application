import 'package:flutter/foundation.dart';

/// Pure domain entity representing an item inside a customer order.
@immutable
class OrderItemEntity {
  final String productId;
  final String productName;
  final String variant;
  final double price;
  final int quantity;
  final String imageUrl;

  const OrderItemEntity({
    required this.productId,
    required this.productName,
    required this.variant,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  String get name => productName;

  double get itemTotal => price * quantity;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderItemEntity &&
          runtimeType == other.runtimeType &&
          productId == other.productId &&
          variant == other.variant;

  @override
  int get hashCode => productId.hashCode ^ variant.hashCode;
}
