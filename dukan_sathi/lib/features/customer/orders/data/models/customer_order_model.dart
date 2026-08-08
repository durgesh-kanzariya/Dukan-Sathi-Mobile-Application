import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/customer_order_entity.dart';
import 'order_item_model.dart';

class CustomerOrderModel extends CustomerOrderEntity {
  const CustomerOrderModel({
    required super.id,
    required super.customerId,
    required super.shopId,
    required super.shopName,
    required super.status,
    required super.totalPrice,
    required super.createdAt,
    super.completedAt,
    required super.pickupCode,
    required super.items,
  });

  factory CustomerOrderModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    final rawItems = data['items'] as List<dynamic>? ?? [];
    final itemsList = rawItems
        .map((item) => OrderItemModel.fromMap(item as Map<String, dynamic>).toEntity())
        .toList();

    DateTime parsedCreatedAt;
    if (data['createdAt'] is Timestamp) {
      parsedCreatedAt = (data['createdAt'] as Timestamp).toDate();
    } else {
      parsedCreatedAt = DateTime.now();
    }

    DateTime? parsedCompletedAt;
    if (data['completedAt'] is Timestamp) {
      parsedCompletedAt = (data['completedAt'] as Timestamp).toDate();
    }

    double parsedTotal = 0.0;
    if (data['totalPrice'] is num) {
      parsedTotal = (data['totalPrice'] as num).toDouble();
    } else if (data['totalPrice'] is String) {
      parsedTotal = double.tryParse(data['totalPrice']) ?? 0.0;
    }

    if (parsedTotal == 0.0 && itemsList.isNotEmpty) {
      for (var item in itemsList) {
        parsedTotal += item.itemTotal;
      }
    }

    return CustomerOrderModel(
      id: doc.id,
      customerId: data['customerId'] ?? '',
      shopId: data['shopId'] ?? '',
      shopName: data['shopName'] ?? 'Local Shop',
      status: data['status'] ?? 'pending',
      totalPrice: parsedTotal,
      createdAt: parsedCreatedAt,
      completedAt: parsedCompletedAt,
      pickupCode: data['pickupCode'] ?? '',
      items: itemsList,
    );
  }

  CustomerOrderEntity toEntity() {
    return CustomerOrderEntity(
      id: id,
      customerId: customerId,
      shopId: shopId,
      shopName: shopName,
      status: status,
      totalPrice: totalPrice,
      createdAt: createdAt,
      completedAt: completedAt,
      pickupCode: pickupCode,
      items: items,
    );
  }
}
