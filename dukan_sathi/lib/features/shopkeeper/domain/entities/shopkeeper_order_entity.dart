import 'package:flutter/foundation.dart';
import '../../../customer/orders/domain/entities/order_item_entity.dart';

/// Pure domain entity representing an incoming pre-order for a merchant shop.
@immutable
class ShopkeeperOrderEntity {
  final String id;
  final String customerId;
  final String? customerName;
  final String? customerPhone;
  final String shopId;
  final String shopName;
  final String status;
  final double totalPrice;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String pickupCode;
  final List<OrderItemEntity> items;

  const ShopkeeperOrderEntity({
    required this.id,
    required this.customerId,
    this.customerName,
    this.customerPhone,
    required this.shopId,
    required this.shopName,
    required this.status,
    required this.totalPrice,
    required this.createdAt,
    this.completedAt,
    required this.pickupCode,
    required this.items,
  });

  bool get isPending => status == 'pending';
  bool get isPreparing => status == 'accepted' || status == 'preparing';
  bool get isReady => status == 'ready_for_pickup' || status == 'ready';
  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShopkeeperOrderEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          status == other.status;

  @override
  int get hashCode => id.hashCode ^ status.hashCode;
}
