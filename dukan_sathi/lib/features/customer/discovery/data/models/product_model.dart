import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/product_entity.dart';
import 'product_variant_model.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.shopId,
    required super.productName,
    required super.description,
    required super.imageUrl,
    required super.variants,
    required super.createdAt,
  });

  factory ProductModel.fromDocument(DocumentSnapshot doc) {
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

    return ProductModel(
      id: doc.id,
      shopId: data['shopId'] ?? '',
      productName: (data['productName'] ?? data['name'] ?? 'Product').toString(),
      description: (data['description'] ?? '').toString(),
      imageUrl: (data['imageUrl'] ?? '').toString(),
      variants: variantsList,
      createdAt: parsedCreatedAt,
    );
  }

  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      shopId: shopId,
      productName: productName,
      description: description,
      imageUrl: imageUrl,
      variants: variants,
      createdAt: createdAt,
    );
  }
}
