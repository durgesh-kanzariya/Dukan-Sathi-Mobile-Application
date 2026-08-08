import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/customer_order_entity.dart';
import '../../domain/repositories/i_customer_order_repository.dart';
import '../datasources/customer_order_remote_data_source.dart';

class CustomerOrderRepositoryImpl implements ICustomerOrderRepository {
  final ICustomerOrderRemoteDataSource _remoteDataSource;

  CustomerOrderRepositoryImpl(this._remoteDataSource);

  @override
  Stream<List<CustomerOrderEntity>> getActiveOrdersStream() {
    return _remoteDataSource.getActiveOrdersStream().map(
          (models) => models.map((m) => m.toEntity()).toList(),
        );
  }

  @override
  Stream<List<CustomerOrderEntity>> getOrderHistoryStream() {
    return _remoteDataSource.getOrderHistoryStream().map(
          (models) => models.map((m) => m.toEntity()).toList(),
        );
  }

  @override
  Future<CustomerOrderEntity?> getOrderById(String orderId) async {
    final model = await _remoteDataSource.getOrderById(orderId);
    return model?.toEntity();
  }
}

// Riverpod Providers for Customer Orders Data & Repository
final customerOrderRemoteDataSourceProvider = Provider<ICustomerOrderRemoteDataSource>((ref) {
  return CustomerOrderRemoteDataSourceImpl();
});

final customerOrderRepositoryProvider = Provider<ICustomerOrderRepository>((ref) {
  final dataSource = ref.watch(customerOrderRemoteDataSourceProvider);
  return CustomerOrderRepositoryImpl(dataSource);
});
