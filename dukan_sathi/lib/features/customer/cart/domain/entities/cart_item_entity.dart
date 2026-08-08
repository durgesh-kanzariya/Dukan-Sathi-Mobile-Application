import 'package:flutter/foundation.dart';

/// Pure domain entity representing an item in the customer's cart.
@immutable
class CartItemEntity {
  final String productId;
  final String name;
  final String variant;
  final double price;
  final int quantity;
  final String imageUrl;
  final String shopId;
  final String shopName;

  const CartItemEntity({
    required this.productId,
    required this.name,
    required this.variant,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    required this.shopId,
    required this.shopName,
  });

  String get productName => name;
  double get totalPrice => price * quantity;

  CartItemEntity copyWith({
    int? quantity,
  }) {
    return CartItemEntity(
      productId: productId,
      name: name,
      variant: variant,
      price: price,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl,
      shopId: shopId,
      shopName: shopName,
    );
  }
}
