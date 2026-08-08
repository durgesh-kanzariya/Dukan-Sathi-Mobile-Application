import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../../core/utils/constants.dart';
import '../../domain/entities/cart_item_entity.dart';

abstract class ICartRemoteDataSource {
  Future<List<String>> placeMultiShopOrders(List<CartItemEntity> items);
}

class CartRemoteDataSourceImpl implements ICartRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  CartRemoteDataSourceImpl({
    FirebaseFirestore? firestore,
    FirebaseAuth? firebaseAuth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<List<String>> placeMultiShopOrders(List<CartItemEntity> items) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw Exception('User must be logged in to place orders.');
    }

    if (items.isEmpty) {
      throw Exception('Cart is empty.');
    }

    // Group items by shopId
    final Map<String, List<CartItemEntity>> itemsByShop = {};
    for (var item in items) {
      if (!itemsByShop.containsKey(item.shopId)) {
        itemsByShop[item.shopId] = [];
      }
      itemsByShop[item.shopId]!.add(item);
    }

    final List<String> createdOrderIds = [];

    // Create a distinct Firestore order document per shop
    for (var entry in itemsByShop.entries) {
      final String shopId = entry.key;
      final List<CartItemEntity> shopItems = entry.value;

      final double orderTotal = shopItems.fold(0.0, (subtotal, i) => subtotal + i.totalPrice);
      final String shopName = shopItems.first.shopName;

      // Generate a unique 7-digit alphanumeric pickup code PIN
      final String pickupCode = DateTime.now().millisecondsSinceEpoch.toString().substring(6);

      final orderData = {
        'customerId': user.uid,
        'shopId': shopId,
        'shopName': shopName,
        'status': AppConstants.statusPending,
        'totalPrice': orderTotal,
        'createdAt': FieldValue.serverTimestamp(),
        'pickupCode': pickupCode,
        'items': shopItems.map((item) {
          return {
            'productId': item.productId,
            'productName': item.name,
            'variant': item.variant,
            'price': item.price,
            'quantity': item.quantity,
            'imageUrl': item.imageUrl,
          };
        }).toList(),
      };

      final docRef = await _firestore.collection(AppConstants.ordersCollection).add(orderData);
      createdOrderIds.add(docRef.id);
    }

    return createdOrderIds;
  }
}
