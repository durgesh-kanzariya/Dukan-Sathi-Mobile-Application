import '../entities/shopkeeper_order_entity.dart';
import '../entities/inventory_product_entity.dart';

/// Contract interface for Shopkeeper Inventory, Orders, & Atomic Scan Verification.
abstract class IShopkeeperRepository {
  Stream<List<ShopkeeperOrderEntity>> getShopOrdersStream(String shopId);
  Stream<List<InventoryProductEntity>> getShopProductsStream(String shopId);

  Future<void> updateOrderStatus(String orderId, String newStatus);
  Future<void> addProduct(String shopId, Map<String, dynamic> productData);
  Future<void> updateProduct(String shopId, String productId, Map<String, dynamic> productData);
  Future<void> deleteProduct(String shopId, String productId);

  /// Executes atomic Firestore Transaction: verifies pickup code PIN, sets order status to completed, and decrements variant inventory stock safely.
  Future<ShopkeeperOrderEntity> verifyAndCompleteOrderWithScan({
    required String shopId,
    required String pickupCodeOrOrderId,
  });
}
