import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

// --- ORDER ITEM MODEL ---
class OrderItem {
  final String productId;
  final String name;
  final String variant;
  final double price;
  final int quantity;
  final String imageUrl;

  const OrderItem({
    required this.productId,
    required this.name,
    required this.variant,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    // 1. ROBUST PRICE PARSING (Handles String, Int, or Double)
    double parsedPrice = 0.0;
    try {
      if (map['price'] is num) {
        parsedPrice = (map['price'] as num).toDouble();
      } else if (map['price'] is String) {
        parsedPrice = double.tryParse(map['price']) ?? 0.0;
      }
    } catch (e) {
      print("Error parsing item price: $e");
    }

    return OrderItem(
      productId: map['productId'] ?? '',
      name: map['name'] ?? map['productName'] ?? 'Unknown',
      variant: map['variant'] ?? '',
      price: parsedPrice,
      quantity: (map['qty'] ?? map['quantity'] ?? 1).toInt(),
      imageUrl: map['imageUrl'] ?? '',
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

  String get formattedDate {
    DateTime date = createdAt.toDate();
    return DateFormat('dd/MM/yyyy').format(date);
  }

  factory OrderModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snap) {
    final data = snap.data() ?? {};
    final itemData = data['items'] as List<dynamic>? ?? [];

    // Convert items first
    List<OrderItem> parsedItems = itemData
        .map((item) => OrderItem.fromMap(item))
        .toList();

    // 2. SMART TOTAL CALCULATION
    double finalTotal = 0.0;

    // First, try to get the total directly from the database
    if (data['totalPrice'] is num) {
      finalTotal = (data['totalPrice'] as num).toDouble();
    } else if (data['totalPrice'] is String) {
      finalTotal = double.tryParse(data['totalPrice']) ?? 0.0;
    }

    // FIX: If DB says 0 (because of old bug), calculate it manually from the items
    if (finalTotal == 0.0 && parsedItems.isNotEmpty) {
      for (var item in parsedItems) {
        finalTotal += (item.price * item.quantity);
      }
    }

    return OrderModel(
      id: snap.id,
      customerId: data['customerId'] ?? '',
      shopId: data['shopId'] ?? '',
      shopName: data['shopName'] ?? 'Unknown Shop',
      status: data['status'] ?? 'pending',
      totalPrice: finalTotal, // Now contains the corrected total
      createdAt: data['createdAt'] ?? Timestamp.now(),
      pickupCode: data['pickupCode'] ?? '',
      items: parsedItems,
    );
  }
}
