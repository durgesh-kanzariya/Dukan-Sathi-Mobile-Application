import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/constants.dart';
import '../../data/repositories/shopkeeper_repository_impl.dart';
import '../../domain/entities/inventory_product_entity.dart';
import '../../domain/entities/shopkeeper_order_entity.dart';

/// Stream Provider discovering active shopkeeper's shop ID
final activeShopIdProvider = StreamProvider<String?>((ref) {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return Stream.value(null);

  return FirebaseFirestore.instance
      .collection(AppConstants.shopsCollection)
      .where('ownerId', isEqualTo: uid)
      .limit(1)
      .snapshots()
      .map((snapshot) {
    if (snapshot.docs.isEmpty) return null;
    return snapshot.docs.first.id;
  });
});

/// Stream Provider fetching orders for current merchant shop ID
final shopkeeperOrdersStreamProvider = StreamProvider<List<ShopkeeperOrderEntity>>((ref) {
  final shopIdAsync = ref.watch(activeShopIdProvider);
  final shopId = shopIdAsync.asData?.value;
  if (shopId == null || shopId.isEmpty) return Stream.value([]);

  final repo = ref.watch(shopkeeperRepositoryProvider);
  return repo.getShopOrdersStream(shopId);
});

/// Stream Provider fetching inventory products for current merchant shop ID
final shopkeeperProductsStreamProvider = StreamProvider<List<InventoryProductEntity>>((ref) {
  final shopIdAsync = ref.watch(activeShopIdProvider);
  final shopId = shopIdAsync.asData?.value;
  if (shopId == null || shopId.isEmpty) return Stream.value([]);

  final repo = ref.watch(shopkeeperRepositoryProvider);
  return repo.getShopProductsStream(shopId);
});

/// Analytics metrics model for Shopkeeper Dashboard
class ShopkeeperAnalyticsMetrics {
  final double todayRevenue;
  final double todayProfit;
  final int totalOrders;
  final int pendingOrdersCount;
  final int readyForPickupCount;

  const ShopkeeperAnalyticsMetrics({
    required this.todayRevenue,
    required this.todayProfit,
    required this.totalOrders,
    required this.pendingOrdersCount,
    required this.readyForPickupCount,
  });
}

/// Computed Analytics Provider from live orders stream
final shopkeeperAnalyticsProvider = Provider<ShopkeeperAnalyticsMetrics>((ref) {
  final ordersAsync = ref.watch(shopkeeperOrdersStreamProvider);
  final productsAsync = ref.watch(shopkeeperProductsStreamProvider);
  final orders = ordersAsync.asData?.value ?? [];
  final products = productsAsync.asData?.value ?? [];

  final now = DateTime.now();
  final todayStart = DateTime(now.year, now.month, now.day);

  double todayRev = 0.0;
  double todayProf = 0.0;
  int pendingCount = 0;
  int readyCount = 0;

  for (var order in orders) {
    if (order.isPending) pendingCount++;
    if (order.isReady) readyCount++;

    if (order.isCompleted && order.createdAt.isAfter(todayStart)) {
      todayRev += order.totalPrice;

      for (var item in order.items) {
        double itemProfit = item.price * 0.20; // 20% default margin fallback
        final matchedProd = products.where((p) => p.id == item.productId || p.productName == item.productName).firstOrNull;
        if (matchedProd != null) {
          final matchedVariant = matchedProd.variants.where((v) => v.name == item.variant).firstOrNull;
          if (matchedVariant != null && matchedVariant.buyPrice > 0) {
            itemProfit = (matchedVariant.sellPrice - matchedVariant.buyPrice);
          }
        }
        todayProf += (itemProfit * item.quantity);
      }
    }
  }

  return ShopkeeperAnalyticsMetrics(
    todayRevenue: todayRev,
    todayProfit: todayProf,
    totalOrders: orders.length,
    pendingOrdersCount: pendingCount,
    readyForPickupCount: readyCount,
  );
});
