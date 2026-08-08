import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/utils/constants.dart';
import '../../data/models/customer_order_model.dart';
import '../../domain/entities/customer_order_entity.dart';
import '../../data/repositories/customer_order_repository_impl.dart';

/// Stream Provider fetching customer active orders
final activeOrdersStreamProvider = StreamProvider<List<CustomerOrderEntity>>((ref) {
  final repo = ref.watch(customerOrderRepositoryProvider);
  return repo.getActiveOrdersStream();
});

/// Stream Provider fetching completed/cancelled order history
final orderHistoryStreamProvider = StreamProvider<List<CustomerOrderEntity>>((ref) {
  final repo = ref.watch(customerOrderRepositoryProvider);
  return repo.getOrderHistoryStream();
});

/// Stream Provider fetching ALL completed customer orders for real analytics calculation
final allCustomerOrdersStreamProvider = StreamProvider<List<CustomerOrderEntity>>((ref) {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return Stream.value([]);

  return FirebaseFirestore.instance
      .collection(AppConstants.ordersCollection)
      .where('customerId', isEqualTo: uid)
      .where('status', isEqualTo: AppConstants.statusCompleted)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) => CustomerOrderModel.fromDocument(doc)).toList();
  });
});

/// Spending Summary Provider calculating current & previous month totals from Firestore
final monthlySpendingStreamProvider = StreamProvider<Map<String, double>>((ref) {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return Stream.value({'current': 0.0, 'previous': 0.0});

  return FirebaseFirestore.instance
      .collection(AppConstants.ordersCollection)
      .where('customerId', isEqualTo: uid)
      .where('status', isEqualTo: AppConstants.statusCompleted)
      .snapshots()
      .map((snapshot) {
    final now = DateTime.now();
    double currentMonth = 0.0;
    double previousMonth = 0.0;

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final double total = (data['totalPrice'] as num?)?.toDouble() ?? 0.0;
      final createdAt = (data['createdAt'] as Timestamp?)?.toDate() ?? now;

      if (createdAt.month == now.month && createdAt.year == now.year) {
        currentMonth += total;
      } else if ((now.month == 1 && createdAt.month == 12 && createdAt.year == now.year - 1) ||
          (createdAt.month == now.month - 1 && createdAt.year == now.year)) {
        previousMonth += total;
      }
    }

    return {
      'current': currentMonth,
      'previous': previousMonth,
    };
  });
});
