import 'package:flutter/foundation.dart';
import 'order_item_entity.dart';

/// Pure domain entity representing a Customer Order.
@immutable
class CustomerOrderEntity {
  final String id;
  final String customerId;
  final String shopId;
  final String shopName;
  final String status;
  final double totalPrice;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String pickupCode;
  final List<OrderItemEntity> items;

  const CustomerOrderEntity({
    required this.id,
    required this.customerId,
    required this.shopId,
    required this.shopName,
    required this.status,
    required this.totalPrice,
    required this.createdAt,
    this.completedAt,
    required this.pickupCode,
    required this.items,
  });

  String get pickupPin => pickupCode;

  bool get isActive =>
      status == 'pending' ||
      status == 'accepted' ||
      status == 'preparing' ||
      status == 'ready_for_pickup' ||
      status == 'ready';

  bool get isReadyForPickup => status == 'ready_for_pickup' || status == 'ready';
  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';
  bool get isRejected => status == 'rejected' || status == 'declined';
}
