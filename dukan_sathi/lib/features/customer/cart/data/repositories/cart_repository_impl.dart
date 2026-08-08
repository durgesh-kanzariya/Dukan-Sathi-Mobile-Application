import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/cart_item_entity.dart';
import '../../domain/repositories/i_cart_repository.dart';
import '../datasources/cart_remote_data_source.dart';

class CartRepositoryImpl implements ICartRepository {
  final ICartRemoteDataSource _remoteDataSource;

  CartRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<String>> placeMultiShopOrders(List<CartItemEntity> items) async {
    return await _remoteDataSource.placeMultiShopOrders(items);
  }
}

// Riverpod Providers for Cart Data & Repository
final cartRemoteDataSourceProvider = Provider<ICartRemoteDataSource>((ref) {
  return CartRemoteDataSourceImpl();
});

final cartRepositoryProvider = Provider<ICartRepository>((ref) {
  final dataSource = ref.watch(cartRemoteDataSourceProvider);
  return CartRepositoryImpl(dataSource);
});
