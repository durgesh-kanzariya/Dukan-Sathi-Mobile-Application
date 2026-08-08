import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/shop_entity.dart';

class ShopModel extends ShopEntity {
  const ShopModel({
    required super.id,
    required super.shopName,
    required super.address,
    required super.ownerId,
    super.imageUrl,
    super.description,
    super.contact,
    required super.openTime,
    required super.closeTime,
  });

  factory ShopModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return ShopModel(
      id: doc.id,
      shopName: data['shopName'] ?? '',
      address: data['address'] ?? '',
      ownerId: data['ownerId'] ?? '',
      imageUrl: data['imageUrl'] as String?,
      description: data['description'] as String?,
      contact: data['contact'] as String?,
      openTime: data['openTime'] ?? '9:00 AM',
      closeTime: data['closeTime'] ?? '9:00 PM',
    );
  }

  ShopEntity toEntity() {
    return ShopEntity(
      id: id,
      shopName: shopName,
      address: address,
      ownerId: ownerId,
      imageUrl: imageUrl,
      description: description,
      contact: contact,
      openTime: openTime,
      closeTime: closeTime,
    );
  }
}
