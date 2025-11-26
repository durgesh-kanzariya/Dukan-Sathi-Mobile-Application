import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

// --- ORDER ITEM MODEL ---
class OrderItem {
  final String productId;
  final String name;      // merged 'productName' and 'name'
  final String variant;
  final double price;
  final int quantity;
  final String imageUrl;  // Added this so customers can see images

  const OrderItem({
    required this.productId,
    required this.name,
    required this.variant,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  // Create from Firestore Map
  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId'] ?? '',
      name: map['name'] ?? map['productName'] ?? 'Unknown',
      variant: map['variant'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      quantity: (map['qty'] ?? map['quantity'] ?? 1).toInt(),
      imageUrl: map['imageUrl'] ?? 'assets/imgs/image.png',
    );
  }
}

// --- MAIN ORDER MODEL ---
class OrderModel {
  final String id;
  final String customerId;
  final String shopId;
  final String shopName;
  final String status;
  final double totalPrice;
  final Timestamp createdAt;
  final String pickupCode;
  final List<OrderItem> items;
  
  // Extra fields for UI (not necessarily in DB)
  String? shopAddress; 

  OrderModel({
    required this.id,
    required this.customerId,
    required this.shopId,
    required this.shopName,
    required this.status,
    required this.totalPrice,
    required this.createdAt,
    required this.pickupCode,
    required this.items,
    this.shopAddress,
  });

  // Helper to get formatted date string (e.g. "26/11/2025")
  String get formattedDate {
    DateTime date = createdAt.toDate();
    return DateFormat('dd/MM/yyyy').format(date);
  }

  // Create from Firestore Document
  factory OrderModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snap) {
    final data = snap.data() ?? {};
    final itemData = data['items'] as List<dynamic>? ?? [];

    return OrderModel(
      id: snap.id,
      customerId: data['customerId'] ?? '',
      shopId: data['shopId'] ?? '',
      shopName: data['shopName'] ?? 'Unknown Shop',
      status: data['status'] ?? 'pending',
      totalPrice: (data['totalPrice'] ?? 0.0).toDouble(),
      createdAt: data['createdAt'] ?? Timestamp.now(),
      pickupCode: data['pickupCode'] ?? '',
      items: itemData.map((item) => OrderItem.fromMap(item)).toList(),
    );
  }
}