import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/quick_list_item_entity.dart';

class QuickListItemModel extends QuickListItemEntity {
  const QuickListItemModel({
    required super.productId,
    required super.productName,
    required super.imageUrl,
    required super.shopId,
    required super.shopName,
    required super.variant,
    required super.price,
    required super.quantity,
    required super.addedAt,
  });

  factory QuickListItemModel.fromEntity(QuickListItemEntity entity) {
    return QuickListItemModel(
      productId: entity.productId,
      productName: entity.productName,
      imageUrl: entity.imageUrl,
      shopId: entity.shopId,
      shopName: entity.shopName,
      variant: entity.variant,
      price: entity.price,
      quantity: entity.quantity,
      addedAt: entity.addedAt,
    );
  }

  factory QuickListItemModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    DateTime parsedAddedAt;
    if (data['addedAt'] is Timestamp) {
      parsedAddedAt = (data['addedAt'] as Timestamp).toDate();
    } else {
      parsedAddedAt = DateTime.now();
    }

    double parseDouble(dynamic val) {
      if (val is num) return val.toDouble();
      if (val is String) return double.tryParse(val) ?? 0.0;
      return 0.0;
    }

    return QuickListItemModel(
      productId: (data['productId'] ?? doc.id).toString(),
      productName: (data['productName'] ?? '').toString(),
      imageUrl: (data['imageUrl'] ?? '').toString(),
      shopId: (data['shopId'] ?? '').toString(),
      shopName: (data['shopName'] ?? '').toString(),
      variant: (data['variant'] ?? 'Standard').toString(),
      price: parseDouble(data['price'] ?? data['sellPrice']),
      quantity: (data['quantity'] as num?)?.toInt() ?? 1,
      addedAt: parsedAddedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'imageUrl': imageUrl,
      'shopId': shopId,
      'shopName': shopName,
      'variant': variant,
      'price': price,
      'quantity': quantity,
      'addedAt': Timestamp.fromDate(addedAt),
    };
  }

  QuickListItemEntity toEntity() {
    return QuickListItemEntity(
      productId: productId,
      productName: productName,
      imageUrl: imageUrl,
      shopId: shopId,
      shopName: shopName,
      variant: variant,
      price: price,
      quantity: quantity,
      addedAt: addedAt,
    );
  }
}
