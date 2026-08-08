import 'package:flutter/foundation.dart';
import 'cart_item_entity.dart';

/// Pure domain entity representing cart items grouped under a specific merchant shop.
@immutable
class ShopGroupCartEntity {
  final String shopId;
  final String shopName;
  final List<CartItemEntity> items;

  const ShopGroupCartEntity({
    required this.shopId,
    required this.shopName,
    required this.items,
  });

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);
}
