import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../customer/orders/data/models/order_item_model.dart';
import '../../domain/entities/shopkeeper_order_entity.dart';

class ShopkeeperOrderModel extends ShopkeeperOrderEntity {
  const ShopkeeperOrderModel({
    required super.id,
    required super.customerId,
    super.customerName,
    super.customerPhone,
    required super.shopId,
    required super.shopName,
    required super.status,
    required super.totalPrice,
    required super.createdAt,
    super.completedAt,
    required super.pickupCode,
    required super.items,
  });

  factory ShopkeeperOrderModel.fromDocument(DocumentSnapshot doc) {
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

    return ShopkeeperOrderModel(
      id: doc.id,
      customerId: data['customerId'] ?? '',
      customerName: data['customerName'] as String?,
      customerPhone: data['customerPhone'] as String?,
      shopId: data['shopId'] ?? '',
      shopName: data['shopName'] ?? 'Merchant Shop',
      status: data['status'] ?? 'pending',
      totalPrice: parsedTotal,
      createdAt: parsedCreatedAt,
      completedAt: parsedCompletedAt,
      pickupCode: data['pickupCode'] ?? '',
      items: itemsList,
    );
  }

  ShopkeeperOrderEntity toEntity() {
    return ShopkeeperOrderEntity(
      id: id,
      customerId: customerId,
      customerName: customerName,
      customerPhone: customerPhone,
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
