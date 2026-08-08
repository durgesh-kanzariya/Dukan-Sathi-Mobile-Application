import '../entities/cart_item_entity.dart';

/// Contract interface for Multi-Shop Cart and Checkout operations.
abstract class ICartRepository {
  Future<List<String>> placeMultiShopOrders(List<CartItemEntity> items);
}
