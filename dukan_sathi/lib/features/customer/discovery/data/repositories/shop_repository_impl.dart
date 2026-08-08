import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/shop_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/i_shop_repository.dart';
import '../datasources/shop_remote_data_source.dart';

class ShopRepositoryImpl implements IShopRepository {
  final IShopRemoteDataSource _remoteDataSource;

  ShopRepositoryImpl(this._remoteDataSource);

  @override
  Stream<List<ShopEntity>> getShopsStream() {
    return _remoteDataSource.getShopsStream().map(
          (models) => models.map((m) => m.toEntity()).toList(),
        );
  }

  @override
  Stream<List<ProductEntity>> getShopProductsStream(String shopId) {
    return _remoteDataSource.getShopProductsStream(shopId).map(
          (models) => models.map((m) => m.toEntity()).toList(),
        );
  }

  @override
  Future<ProductEntity?> getProductDetails(String shopId, String productId) async {
    final model = await _remoteDataSource.getProductDetails(shopId, productId);
    return model?.toEntity();
  }

  @override
  Future<ShopEntity?> getShopById(String shopId) async {
    final model = await _remoteDataSource.getShopById(shopId);
    return model?.toEntity();
  }
}

// Riverpod Providers for Shop Discovery Data & Domain
final shopRemoteDataSourceProvider = Provider<IShopRemoteDataSource>((ref) {
  return ShopRemoteDataSourceImpl();
});

final shopRepositoryProvider = Provider<IShopRepository>((ref) {
  final dataSource = ref.watch(shopRemoteDataSourceProvider);
  return ShopRepositoryImpl(dataSource);
});
