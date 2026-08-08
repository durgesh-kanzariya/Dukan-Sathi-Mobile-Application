import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../core/utils/constants.dart';
import '../models/shop_model.dart';
import '../models/product_model.dart';

abstract class IShopRemoteDataSource {
  Stream<List<ShopModel>> getShopsStream();
  Stream<List<ProductModel>> getShopProductsStream(String shopId);
  Future<ProductModel?> getProductDetails(String shopId, String productId);
  Future<ShopModel?> getShopById(String shopId);
}

class ShopRemoteDataSourceImpl implements IShopRemoteDataSource {
  final FirebaseFirestore _firestore;

  ShopRemoteDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<ShopModel>> getShopsStream() {
    return _firestore.collection(AppConstants.shopsCollection).snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => ShopModel.fromDocument(doc)).toList(),
        );
  }

  @override
  Stream<List<ProductModel>> getShopProductsStream(String shopId) {
    return _firestore
        .collection(AppConstants.shopsCollection)
        .doc(shopId)
        .collection(AppConstants.productsSubCollection)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) => ProductModel.fromDocument(doc)).toList(),
        );
  }

  @override
  Future<ProductModel?> getProductDetails(String shopId, String productId) async {
    final doc = await _firestore
        .collection(AppConstants.shopsCollection)
        .doc(shopId)
        .collection(AppConstants.productsSubCollection)
        .doc(productId)
        .get();

    if (!doc.exists) return null;
    return ProductModel.fromDocument(doc);
  }

  @override
  Future<ShopModel?> getShopById(String shopId) async {
    final doc = await _firestore
        .collection(AppConstants.shopsCollection)
        .doc(shopId)
        .get();

    if (!doc.exists) return null;
    return ShopModel.fromDocument(doc);
  }
}
