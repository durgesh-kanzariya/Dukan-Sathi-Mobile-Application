import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../../core/utils/constants.dart';
import '../models/customer_order_model.dart';

abstract class ICustomerOrderRemoteDataSource {
  Stream<List<CustomerOrderModel>> getActiveOrdersStream();
  Stream<List<CustomerOrderModel>> getOrderHistoryStream();
  Future<CustomerOrderModel?> getOrderById(String orderId);
}

class CustomerOrderRemoteDataSourceImpl implements ICustomerOrderRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  CustomerOrderRemoteDataSourceImpl({
    FirebaseFirestore? firestore,
    FirebaseAuth? firebaseAuth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  String? get _uid => _firebaseAuth.currentUser?.uid;

  @override
  Stream<List<CustomerOrderModel>> getActiveOrdersStream() {
    if (_uid == null) return Stream.value([]);
    return _firestore
        .collection(AppConstants.ordersCollection)
        .where('customerId', isEqualTo: _uid)
        .snapshots()
        .map((snapshot) {
      final orders = snapshot.docs
          .map((doc) => CustomerOrderModel.fromDocument(doc))
          .where((order) => order.isActive)
          .toList();
      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return orders;
    });
  }

  @override
  Stream<List<CustomerOrderModel>> getOrderHistoryStream() {
    if (_uid == null) return Stream.value([]);
    return _firestore
        .collection(AppConstants.ordersCollection)
        .where('customerId', isEqualTo: _uid)
        .snapshots()
        .map((snapshot) {
      final orders = snapshot.docs
          .map((doc) => CustomerOrderModel.fromDocument(doc))
          .where((order) => !order.isActive)
          .toList();
      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return orders;
    });
  }

  @override
  Future<CustomerOrderModel?> getOrderById(String orderId) async {
    final doc = await _firestore.collection(AppConstants.ordersCollection).doc(orderId).get();
    if (!doc.exists) return null;
    return CustomerOrderModel.fromDocument(doc);
  }
}
