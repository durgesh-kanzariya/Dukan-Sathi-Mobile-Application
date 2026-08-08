import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/utils/constants.dart';
import '../models/inventory_product_model.dart';
import '../models/shopkeeper_order_model.dart';

abstract class IShopkeeperRemoteDataSource {
  Stream<List<ShopkeeperOrderModel>> getShopOrdersStream(String shopId);
  Stream<List<InventoryProductModel>> getShopProductsStream(String shopId);

  Future<void> updateOrderStatus(String orderId, String newStatus);
  Future<void> addProduct(String shopId, Map<String, dynamic> productData);
  Future<void> updateProduct(String shopId, String productId, Map<String, dynamic> productData);
  Future<void> deleteProduct(String shopId, String productId);

  Future<ShopkeeperOrderModel> verifyAndCompleteOrderWithScan({
    required String shopId,
    required String pickupCodeOrOrderId,
  });
}

class ShopkeeperRemoteDataSourceImpl implements IShopkeeperRemoteDataSource {
  final FirebaseFirestore _firestore;

  ShopkeeperRemoteDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<ShopkeeperOrderModel>> getShopOrdersStream(String shopId) {
    return _firestore
        .collection(AppConstants.ordersCollection)
        .where('shopId', isEqualTo: shopId)
        .snapshots()
        .map((snapshot) {
      final orders = snapshot.docs
          .map((doc) => ShopkeeperOrderModel.fromDocument(doc))
          .toList();
      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return orders;
    });
  }

  @override
  Stream<List<InventoryProductModel>> getShopProductsStream(String shopId) {
    return _firestore
        .collection(AppConstants.shopsCollection)
        .doc(shopId)
        .collection(AppConstants.productsSubCollection)
        .snapshots()
        .map((snapshot) {
      final products = snapshot.docs
          .map((doc) => InventoryProductModel.fromDocument(doc))
          .toList();
      products.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return products;
    });
  }

  Future<Map<DocumentReference, Map<String, dynamic>>> _prepareInventoryStockUpdates(
    Transaction transaction,
    String shopId,
    ShopkeeperOrderModel orderModel,
  ) async {
    final Map<DocumentReference, Map<String, dynamic>> updates = {};

    for (var item in orderModel.items) {
      final productRef = _firestore
          .collection(AppConstants.shopsCollection)
          .doc(shopId)
          .collection(AppConstants.productsSubCollection)
          .doc(item.productId);

      final productSnap = await transaction.get(productRef);
      if (productSnap.exists && productSnap.data() != null) {
        final pData = productSnap.data()!;
        final variantsList = List<Map<String, dynamic>>.from(pData['variants'] as List<dynamic>? ?? []);

        for (int i = 0; i < variantsList.length; i++) {
          final v = variantsList[i];
          if (v['name'] == item.variant) {
            final currentStock = (v['stock'] as num?)?.toInt() ?? 0;
            final newStock = currentStock - item.quantity;
            variantsList[i]['stock'] = newStock < 0 ? 0 : newStock;
            break;
          }
        }

        updates[productRef] = {'variants': variantsList};
      }
    }

    return updates;
  }

  @override
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    await _firestore.runTransaction((transaction) async {
      final orderRef = _firestore.collection(AppConstants.ordersCollection).doc(orderId);
      final orderSnap = await transaction.get(orderRef);
      if (!orderSnap.exists) return;

      Map<DocumentReference, Map<String, dynamic>> stockUpdates = {};
      final updateData = <String, dynamic>{
        'status': newStatus,
      };

      if (newStatus == AppConstants.statusCompleted) {
        updateData['completedAt'] = FieldValue.serverTimestamp();
        final orderModel = ShopkeeperOrderModel.fromDocument(orderSnap);
        stockUpdates = await _prepareInventoryStockUpdates(transaction, orderModel.shopId, orderModel);
      }

      // WRITES MUST OCCUR AFTER ALL READS ARE FINISHED
      transaction.update(orderRef, updateData);
      stockUpdates.forEach((ref, data) {
        transaction.update(ref, data);
      });
    });
  }

  @override
  Future<void> addProduct(String shopId, Map<String, dynamic> productData) async {
    productData['shopId'] = shopId;
    productData['createdAt'] = FieldValue.serverTimestamp();
    await _firestore
        .collection(AppConstants.shopsCollection)
        .doc(shopId)
        .collection(AppConstants.productsSubCollection)
        .add(productData);
  }

  @override
  Future<void> updateProduct(String shopId, String productId, Map<String, dynamic> productData) async {
    await _firestore
        .collection(AppConstants.shopsCollection)
        .doc(shopId)
        .collection(AppConstants.productsSubCollection)
        .doc(productId)
        .update(productData);
  }

  @override
  Future<void> deleteProduct(String shopId, String productId) async {
    await _firestore
        .collection(AppConstants.shopsCollection)
        .doc(shopId)
        .collection(AppConstants.productsSubCollection)
        .doc(productId)
        .delete();
  }

  @override
  Future<ShopkeeperOrderModel> verifyAndCompleteOrderWithScan({
    required String shopId,
    required String pickupCodeOrOrderId,
  }) async {
    final cleanCode = pickupCodeOrOrderId
        .replaceAll('PIN', '')
        .replaceAll('pin', '')
        .replaceAll(':', '')
        .replaceAll('#', '')
        .replaceAll('-', '')
        .trim();

    if (cleanCode.isEmpty) {
      throw Exception('Please enter a valid 4-digit pickup PIN or scan QR code.');
    }

    // 1. Query by pickupCode
    QuerySnapshot querySnap = await _firestore
        .collection(AppConstants.ordersCollection)
        .where('pickupCode', isEqualTo: cleanCode)
        .limit(1)
        .get();

    // 2. Fallback: Query by Document ID directly
    if (querySnap.docs.isEmpty) {
      final docById = await _firestore.collection(AppConstants.ordersCollection).doc(cleanCode).get();
      if (docById.exists) {
        querySnap = await _firestore
            .collection(AppConstants.ordersCollection)
            .where(FieldPath.documentId, isEqualTo: cleanCode)
            .get();
      }
    }

    // 3. Fallback: Search in current shop orders where pickupCode matches or ID starts with cleanCode
    if (querySnap.docs.isEmpty) {
      final shopOrders = await _firestore
          .collection(AppConstants.ordersCollection)
          .where('shopId', isEqualTo: shopId)
          .get();

      final matched = shopOrders.docs.where((doc) {
        final data = doc.data();
        final code = data['pickupCode']?.toString() ?? '';
        final id = doc.id;
        return code == cleanCode || id == cleanCode || id.startsWith(cleanCode);
      }).toList();

      if (matched.isNotEmpty) {
        querySnap = await _firestore
            .collection(AppConstants.ordersCollection)
            .where(FieldPath.documentId, isEqualTo: matched.first.id)
            .get();
      }
    }

    if (querySnap.docs.isEmpty) {
      throw Exception('No order found with PIN/Code "$cleanCode". Please check customer PIN.');
    }

    final orderDoc = querySnap.docs.first;
    final orderModel = ShopkeeperOrderModel.fromDocument(orderDoc);

    // Verify shop ownership
    if (orderModel.shopId.isNotEmpty && orderModel.shopId != shopId) {
      throw Exception('Order #${orderModel.id.substring(0, 6)} belongs to "${orderModel.shopName}", not your shop.');
    }

    if (orderModel.status == AppConstants.statusCompleted) {
      throw Exception('Order #${orderModel.id.substring(0, 6)} is already completed.');
    }
    if (orderModel.status == AppConstants.statusCancelled) {
      throw Exception('Order #${orderModel.id.substring(0, 6)} was cancelled.');
    }

    // Execute Atomic Firestore Transaction: reads all items first, then performs writes
    await _firestore.runTransaction((transaction) async {
      final freshOrderSnap = await transaction.get(orderDoc.reference); // READ 1
      if (!freshOrderSnap.exists) {
        throw Exception('Order document no longer exists.');
      }

      // READ 2: Read product snapshots for stock deduction BEFORE ANY WRITES
      final stockUpdates = await _prepareInventoryStockUpdates(transaction, shopId, orderModel);

      // ALL WRITES AFTER ALL READS ARE COMPLETED
      transaction.update(orderDoc.reference, {
        'status': AppConstants.statusCompleted,
        'completedAt': FieldValue.serverTimestamp(),
      });

      stockUpdates.forEach((ref, data) {
        transaction.update(ref, data);
      });
    });

    // Return updated completed order model
    final updatedDoc = await orderDoc.reference.get();
    return ShopkeeperOrderModel.fromDocument(updatedDoc);
  }
}
