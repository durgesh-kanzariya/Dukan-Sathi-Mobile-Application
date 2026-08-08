import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/inventory_product_entity.dart';
import '../../domain/entities/shopkeeper_order_entity.dart';
import '../../domain/repositories/i_shopkeeper_repository.dart';
import '../datasources/shopkeeper_remote_data_source.dart';

class ShopkeeperRepositoryImpl implements IShopkeeperRepository {
  final IShopkeeperRemoteDataSource _remoteDataSource;

  ShopkeeperRepositoryImpl(this._remoteDataSource);

  @override
  Stream<List<ShopkeeperOrderEntity>> getShopOrdersStream(String shopId) {
    return _remoteDataSource.getShopOrdersStream(shopId).map(
          (models) => models.map((m) => m.toEntity()).toList(),
        );
  }

  @override
  Stream<List<InventoryProductEntity>> getShopProductsStream(String shopId) {
    return _remoteDataSource.getShopProductsStream(shopId).map(
          (models) => models.map((m) => m.toEntity()).toList(),
        );
  }

  @override
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    await _remoteDataSource.updateOrderStatus(orderId, newStatus);
  }

  @override
  Future<void> addProduct(String shopId, Map<String, dynamic> productData) async {
    await _remoteDataSource.addProduct(shopId, productData);
  }

  @override
  Future<void> updateProduct(String shopId, String productId, Map<String, dynamic> productData) async {
    await _remoteDataSource.updateProduct(shopId, productId, productData);
  }

  @override
  Future<void> deleteProduct(String shopId, String productId) async {
    await _remoteDataSource.deleteProduct(shopId, productId);
  }

  @override
  Future<ShopkeeperOrderEntity> verifyAndCompleteOrderWithScan({
    required String shopId,
    required String pickupCodeOrOrderId,
  }) async {
    final model = await _remoteDataSource.verifyAndCompleteOrderWithScan(
      shopId: shopId,
      pickupCodeOrOrderId: pickupCodeOrOrderId,
    );
    return model.toEntity();
  }
}

// Riverpod Providers for Shopkeeper Data & Repository
final shopkeeperRemoteDataSourceProvider = Provider<IShopkeeperRemoteDataSource>((ref) {
  return ShopkeeperRemoteDataSourceImpl();
});

final shopkeeperRepositoryProvider = Provider<IShopkeeperRepository>((ref) {
  final dataSource = ref.watch(shopkeeperRemoteDataSourceProvider);
  return ShopkeeperRepositoryImpl(dataSource);
});
