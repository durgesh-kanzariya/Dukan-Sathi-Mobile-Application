import 'package:cloud_firestore/cloud_firestore.dart';

// This model is for one item *inside* an order
class OrderItem {
  final String productName;
  final int quantity;
  final double price;
  final String variant;

  OrderItem({
    required this.productName,
    required this.quantity,
    required this.price,
    required this.variant,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productName: map['productName'] ?? '',
      quantity: (map['quantity'] ?? 0).toInt(),
      price: (map['price'] ?? 0.0).toDouble(),
      variant: map['variant'] ?? '',
    );
  }
}

// This is the main Order model
class Order {
  final String id;
  final String customerId;
  final String shopId;
  final String shopName;
  final String status;
  final double totalPrice;
  final Timestamp createdAt;
  final String pickupCode;
  final List<OrderItem> items;
  // You can add customerName here if you decide to denormalize it
  // final String customerName;

  Order({
    required this.id,
    required this.customerId,
    required this.shopId,
    required this.shopName,
    required this.status,
    required this.totalPrice,
    required this.createdAt,
    required this.pickupCode,
    required this.items,
  });

  factory Order.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snap) {
    final data = snap.data() ?? {};
    final itemData = data['items'] as List<dynamic>? ?? [];

    return Order(
      id: snap.id,
      customerId: data['customerId'] ?? '',
      shopId: data['shopId'] ?? '',
      shopName: data['shopName'] ?? '',
      status: data['status'] ?? 'unknown',
      totalPrice: (data['totalPrice'] ?? 0.0).toDouble(),
      createdAt: data['createdAt'] ?? Timestamp.now(),
      pickupCode: data['pickupCode'] ?? '',
      items: itemData.map((item) => OrderItem.fromMap(item)).toList(),
    );
  }
}
