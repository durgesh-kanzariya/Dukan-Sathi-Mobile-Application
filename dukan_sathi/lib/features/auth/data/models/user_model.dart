import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.name,
    required super.email,
    required super.role,
    super.phone,
    super.imageUrl,
    required super.createdAt,
  });

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    DateTime parsedCreatedAt;
    if (data['createdAt'] is Timestamp) {
      parsedCreatedAt = (data['createdAt'] as Timestamp).toDate();
    } else {
      parsedCreatedAt = DateTime.now();
    }

    return UserModel(
      uid: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? 'customer',
      phone: data['phone'] as String?,
      imageUrl: data['imageUrl'] as String?,
      createdAt: parsedCreatedAt,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'phone': phone,
      'imageUrl': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      name: name,
      email: email,
      role: role,
      phone: phone,
      imageUrl: imageUrl,
      createdAt: createdAt,
    );
  }
}
