import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/cart_item_entity.dart';
import '../../domain/entities/shop_group_cart_entity.dart';

class CartNotifier extends Notifier<List<CartItemEntity>> {
  @override
  List<CartItemEntity> build() {
    return [];
  }

  /// Add item or increment quantity if item with same productId & variant exists
  void addItem(CartItemEntity newItem) {
    final existingIndex = state.indexWhere(
      (item) => item.productId == newItem.productId && item.variant == newItem.variant,
    );

    if (existingIndex != -1) {
      final existing = state[existingIndex];
      final updatedList = List<CartItemEntity>.from(state);
      updatedList[existingIndex] = existing.copyWith(
        quantity: existing.quantity + newItem.quantity,
      );
      state = updatedList;
    } else {
      state = [...state, newItem];
    }
  }

  /// Update item quantity
  void updateQuantity(String productId, String variant, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(productId, variant);
      return;
    }

    state = [
      for (final item in state)
        if (item.productId == productId && item.variant == variant)
          item.copyWith(quantity: newQuantity)
        else
          item,
    ];
  }

  /// Remove specific variant item from cart
  void removeItem(String productId, String variant) {
    state = state.where((item) => !(item.productId == productId && item.variant == variant)).toList();
  }

  /// Clear entire cart
  void clearCart() {
    state = [];
  }
}

/// Global Riverpod Cart Notifier Provider
final cleanCartNotifierProvider = NotifierProvider<CartNotifier, List<CartItemEntity>>(CartNotifier.new);

/// Computed Provider grouping cart items by shop ID
final groupedCartItemsProvider = Provider<List<ShopGroupCartEntity>>((ref) {
  final cartItems = ref.watch(cleanCartNotifierProvider);

  final Map<String, List<CartItemEntity>> groups = {};
  final Map<String, String> shopNames = {};

  for (var item in cartItems) {
    if (!groups.containsKey(item.shopId)) {
      groups[item.shopId] = [];
      shopNames[item.shopId] = item.shopName;
    }
    groups[item.shopId]!.add(item);
  }

  return groups.entries.map((entry) {
    return ShopGroupCartEntity(
      shopId: entry.key,
      shopName: shopNames[entry.key] ?? 'Local Shop',
      items: entry.value,
    );
  }).toList();
});

/// Computed Grand Total Provider across all items in cart
final cartGrandTotalProvider = Provider<double>((ref) {
  final cartItems = ref.watch(cleanCartNotifierProvider);
  return cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
});

/// Computed Total Item Count Provider across all items in cart
final cartItemCountProvider = Provider<int>((ref) {
  final cartItems = ref.watch(cleanCartNotifierProvider);
  return cartItems.fold(0, (sum, item) => sum + item.quantity);
});
