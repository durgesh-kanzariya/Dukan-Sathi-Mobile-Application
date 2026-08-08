import '../entities/customer_order_entity.dart';

/// Repository contract interface for Customer Orders.
abstract class ICustomerOrderRepository {
  Stream<List<CustomerOrderEntity>> getActiveOrdersStream();
  Stream<List<CustomerOrderEntity>> getOrderHistoryStream();
  Future<CustomerOrderEntity?> getOrderById(String orderId);
}
