import 'package:flutter/foundation.dart';

/// Pure domain entity representing a merchant shop.
@immutable
class ShopEntity {
  final String id;
  final String shopName;
  final String address;
  final String ownerId;
  final String? imageUrl;
  final String? description;
  final String? contact;
  final String openTime;
  final String closeTime;

  const ShopEntity({
    required this.id,
    required this.shopName,
    required this.address,
    required this.ownerId,
    this.imageUrl,
    this.description,
    this.contact,
    required this.openTime,
    required this.closeTime,
  });

  bool get isOpen => true;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShopEntity && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
