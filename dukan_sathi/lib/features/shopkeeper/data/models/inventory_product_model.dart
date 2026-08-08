import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../customer/discovery/data/models/product_variant_model.dart';
import '../../domain/entities/inventory_product_entity.dart';

class InventoryProductModel extends InventoryProductEntity {
  const InventoryProductModel({
    required super.id,
    required super.shopId,
    required super.productName,
    required super.description,
    required super.imageUrl,
    super.category = 'General Store',
    required super.variants,
    required super.createdAt,
  });

  factory InventoryProductModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    final rawVariants = data['variants'] as List<dynamic>? ?? [];
    final variantsList = rawVariants
        .map((v) => ProductVariantModel.fromMap(v as Map<String, dynamic>).toEntity())
        .toList();

    DateTime parsedCreatedAt;
    if (data['createdAt'] is Timestamp) {
      parsedCreatedAt = (data['createdAt'] as Timestamp).toDate();
    } else {
      parsedCreatedAt = DateTime.now();
    }

    return InventoryProductModel(
      id: doc.id,
      shopId: data['shopId'] ?? '',
      productName: data['productName'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      category: data['category'] ?? 'General Store',
      variants: variantsList,
      createdAt: parsedCreatedAt,
    );
  }

  InventoryProductEntity toEntity() {
    return InventoryProductEntity(
      id: id,
      shopId: shopId,
      productName: productName,
      description: description,
      imageUrl: imageUrl,
      category: category,
      variants: variants,
      createdAt: createdAt,
    );
  }
}
