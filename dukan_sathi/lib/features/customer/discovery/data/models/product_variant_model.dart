import '../../domain/entities/product_variant_entity.dart';

class ProductVariantModel extends ProductVariantEntity {
  const ProductVariantModel({
    required super.name,
    required super.buyPrice,
    required super.sellPrice,
    required super.stock,
  });

  factory ProductVariantModel.fromMap(Map<String, dynamic> map) {
    double parseDouble(dynamic val) {
      if (val is num) return val.toDouble();
      if (val is String) return double.tryParse(val) ?? 0.0;
      return 0.0;
    }

    int parseInt(dynamic val) {
      if (val is num) return val.toInt();
      if (val is String) return int.tryParse(val) ?? 0;
      return 0;
    }

    final priceVal = parseDouble(map['sellPrice'] ?? map['price']);

    return ProductVariantModel(
      name: (map['name'] ?? map['variant'] ?? 'Standard').toString(),
      buyPrice: parseDouble(map['buyPrice'] ?? priceVal),
      sellPrice: priceVal,
      stock: parseInt(map['stock'] ?? 50),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'buyPrice': buyPrice,
      'sellPrice': sellPrice,
      'stock': stock,
    };
  }

  ProductVariantEntity toEntity() {
    return ProductVariantEntity(
      name: name,
      buyPrice: buyPrice,
      sellPrice: sellPrice,
      stock: stock,
    );
  }
}
