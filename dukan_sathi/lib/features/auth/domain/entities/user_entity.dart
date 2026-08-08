import 'package:flutter/foundation.dart';

/// Pure domain entity representing an authenticated Dukan Sathi user.
@immutable
class UserEntity {
  final String uid;
  final String name;
  final String email;
  final String role; // 'customer' | 'shopkeeper'
  final String? phone;
  final String? imageUrl;
  final DateTime createdAt;

  const UserEntity({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    this.phone,
    this.imageUrl,
    required this.createdAt,
  });

  bool get isCustomer => role == 'customer';
  bool get isShopkeeper => role == 'shopkeeper';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          name == other.name &&
          email == other.email &&
          role == other.role &&
          phone == other.phone &&
          imageUrl == other.imageUrl &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      uid.hashCode ^
      name.hashCode ^
      email.hashCode ^
      role.hashCode ^
      phone.hashCode ^
      imageUrl.hashCode ^
      createdAt.hashCode;
}
