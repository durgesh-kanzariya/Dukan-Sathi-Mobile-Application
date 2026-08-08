import '../../domain/entities/order_item_entity.dart';

class OrderItemModel extends OrderItemEntity {
  const OrderItemModel({
    required super.productId,
    required super.productName,
    required super.variant,
    required super.price,
    required super.quantity,
    required super.imageUrl,
  });

  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    double parseDouble(dynamic val) {
      if (val is num) return val.toDouble();
      if (val is String) return double.tryParse(val) ?? 0.0;
      return 0.0;
    }

    int parseInt(dynamic val) {
      if (val is num) return val.toInt();
      if (val is String) return int.tryParse(val) ?? 1;
      return 1;
    }

    final name = (map['productName'] as String?)?.isNotEmpty == true
        ? map['productName'] as String
        : ((map['name'] as String?)?.isNotEmpty == true ? map['name'] as String : 'Grocery Item');

    return OrderItemModel(
      productId: map['productId'] ?? '',
      productName: name,
      variant: map['variant'] ?? 'Standard',
      price: parseDouble(map['price']),
      quantity: parseInt(map['quantity']),
      imageUrl: map['imageUrl'] ?? (map['image'] ?? ''),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'variant': variant,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
  }

  OrderItemEntity toEntity() {
    return OrderItemEntity(
      productId: productId,
      productName: productName,
      variant: variant,
      price: price,
      quantity: quantity,
      imageUrl: imageUrl,
    );
  }
}
