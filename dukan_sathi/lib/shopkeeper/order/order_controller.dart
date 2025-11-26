// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// // --- THIS IS THE NEW IMPORT PATH ---
// import 'package:dukan_sathi/shopkeeper/order/order_model.dart' as order_model;
// // ---
// import 'package:dukan_sathi/shop_service.dart';
// import 'package:dukan_sathi/shop_model.dart';

// class OrderController extends GetxController {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final ShopService _shopService = Get.find<ShopService>();

//   var allOrders = <order_model.Order>[].obs;
//   var isLoading = true.obs;

//   String? get _shopId => _shopService.currentShop.value?.id;

//   // Computed lists. The UI will use these.
//   List<order_model.Order> get newOrders =>
//       allOrders.where((o) => o.status == 'pending').toList();

//   List<order_model.Order> get preparingOrders =>
//       allOrders.where((o) => o.status == 'preparing').toList();

//   List<order_model.Order> get readyOrders =>
//       allOrders.where((o) => o.status == 'ready_for_pickup').toList();

//   List<order_model.Order> get historyOrders => allOrders
//       .where((o) => o.status == 'completed' || o.status == 'cancelled')
//       .toList();

//   // Inside order_controller.dart
//   @override
//   void onInit() {
//     super.onInit();
//     // Listen to the shop service
//     ever(_shopService.currentShop, (Shop? shop) {
//       if (shop != null) {
//         fetchOrders(shop.id);
//       } else {
//         allOrders.clear();
//         isLoading.value = false; // <-- ADD THIS LINE
//       }
//     });
//   }

//   void fetchOrders(String shopId) {
//     isLoading.value = true;
//     _firestore
//         .collection('orders')
//         .where('shopId', isEqualTo: shopId)
//         .orderBy('createdAt', descending: true)
//         .snapshots()
//         .listen(
//           (snapshot) {
//             allOrders.value = snapshot.docs
//                 .map((doc) => order_model.Order.fromSnapshot(doc))
//                 .toList();
//             isLoading.value = false;
//           },
//           onError: (error) {
//             isLoading.value = false;
//             Get.snackbar('Error', 'Could not fetch orders: $error');
//           },
//         );
//   }

//   // --- Functions to change order status ---

//   Future<void> updateOrderStatus(String orderId, String newStatus) async {
//     try {
//       await _firestore.collection('orders').doc(orderId).update({
//         'status': newStatus,
//       });
//       Get.snackbar('Success', 'Order status updated to "$newStatus"');
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to update order status.');
//     }
//   }

//   // --- Functions for the UI to call ---
//   void acceptOrder(String orderId) {
//     updateOrderStatus(orderId, 'preparing');
//   }

//   void declineOrder(String orderId) {
//     updateOrderStatus(orderId, 'cancelled');
//   }

//   void markAsReady(String orderId) {
//     updateOrderStatus(orderId, 'ready_for_pickup');
//   }

//   // This one will be called from the PickupCodeScreen
//   Future<void> completeOrder(String code) async {
//     if (code.isEmpty) return;

//     // 1. Show Loading
//     Get.dialog(
//       const Center(child: CircularProgressIndicator(color: Colors.white)),
//       barrierDismissible: false,
//     );

//     try {
//       // 2. Get current Shopkeeper ID
//       String uid = FirebaseAuth.instance.currentUser?.uid ?? "";
//       if (uid.isEmpty) throw "User not logged in";

//       // 3. Query Firestore
//       final querySnapshot = await FirebaseFirestore.instance
//           .collection('orders')
//           .where('pickupCode', isEqualTo: code)
//           .where('status', isEqualTo: 'ready_for_pickup')
//           .limit(1)
//           .get();

//       // 4. Check if order exists
//       if (querySnapshot.docs.isEmpty) {
//         // CLOSE LOADING BEFORE SHOWING ERROR
//         if (Get.isDialogOpen == true) Get.back();

//         Get.snackbar(
//           "Invalid Code",
//           "Code incorrect or order not ready.",
//           backgroundColor: Colors.redAccent,
//           colorText: Colors.white,
//           snackPosition: SnackPosition.BOTTOM,
//         );
//         return;
//       }

//       // 5. Update Status
//       DocumentReference orderRef = querySnapshot.docs.first.reference;
//       await orderRef.update({
//         'status': 'completed',
//         'completedAt': FieldValue.serverTimestamp(),
//       });

//       // 6. CLOSE LOADING (Success path)
//       if (Get.isDialogOpen == true) Get.back();

//       // 7. Show Success Dialog
//       Get.defaultDialog(
//         title: "Success",
//         titleStyle: const TextStyle(
//           color: Color(0xFF5A7D60),
//           fontWeight: FontWeight.bold,
//         ),
//         middleText: "Order completed successfully!",
//         confirmTextColor: Colors.white,
//         buttonColor: const Color(0xFF5A7D60),
//         barrierDismissible: false,
//         onConfirm: () {
//           // Close the Success Dialog
//           Get.back();
//           // Close the Scanner Screen (Go back to dashboard)
//           Get.back();
//         },
//       );
//     } catch (e) {
//       // 8. CLOSE LOADING (Error path) - This prevents the endless spinner
//       if (Get.isDialogOpen == true) Get.back();

//       print("Error completing order: $e");
//       Get.snackbar(
//         "Error",
//         "Failed: $e",
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dukan_sathi/shopkeeper/order/order_model.dart' as order_model;
import 'package:dukan_sathi/shop_service.dart';
import 'package:dukan_sathi/shop_model.dart';

class OrderController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ShopService _shopService = Get.find<ShopService>();

  var allOrders = <order_model.Order>[].obs;
  var isLoading = true.obs;

  // --- PROFIT & PERFORMANCE VARIABLES ---
  var currentMonthProfit = 0.0.obs;
  var lastMonthProfit = 0.0.obs;
  var isCalculatingPerformance = false.obs;

  String? get _shopId => _shopService.currentShop.value?.id;

  // --- FILTERED LISTS ---
  List<order_model.Order> get newOrders =>
      allOrders.where((o) => o.status == 'pending').toList();

  List<order_model.Order> get preparingOrders =>
      allOrders.where((o) => o.status == 'preparing').toList();

  List<order_model.Order> get readyOrders =>
      allOrders.where((o) => o.status == 'ready_for_pickup').toList();

  List<order_model.Order> get historyOrders => allOrders
      .where((o) => o.status == 'completed' || o.status == 'cancelled')
      .toList();

  @override
  void onInit() {
    super.onInit();
    // Listen to shop changes to fetch data
    ever(_shopService.currentShop, (Shop? shop) {
      if (shop != null) {
        fetchOrders(shop.id);
        calculatePerformanceMetrics(shop.id);
      } else {
        allOrders.clear();
        isLoading.value = false;
      }
    });
  }

  void fetchOrders(String shopId) {
    isLoading.value = true;
    _firestore
        .collection('orders')
        .where('shopId', isEqualTo: shopId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen(
          (snapshot) {
            allOrders.value = snapshot.docs
                .map((doc) => order_model.Order.fromSnapshot(doc))
                .toList();
            isLoading.value = false;
          },
          onError: (error) {
            isLoading.value = false;
            print("Error fetching orders: $error");
          },
        );
  }

  // --- 1. PROFIT CALCULATION LOGIC ---
  Future<void> calculatePerformanceMetrics(String shopId) async {
    isCalculatingPerformance.value = true;
    try {
      DateTime now = DateTime.now();

      DateTime startOfCurrentMonth = DateTime(now.year, now.month, 1);
      DateTime startOfLastMonth = DateTime(now.year, now.month - 1, 1);
      DateTime endOfLastMonth = DateTime(now.year, now.month, 0, 23, 59, 59);

      currentMonthProfit.value = await _calculateProfitForRange(
        shopId,
        startOfCurrentMonth,
        now,
      );

      lastMonthProfit.value = await _calculateProfitForRange(
        shopId,
        startOfLastMonth,
        endOfLastMonth,
      );
    } catch (e) {
      print("Error calculating profits: $e");
    } finally {
      isCalculatingPerformance.value = false;
    }
  }

  Future<double> _calculateProfitForRange(
    String shopId,
    DateTime start,
    DateTime end,
  ) async {
    double totalProfit = 0.0;
    try {
      // Query COMPLETED orders within date range
      QuerySnapshot orderSnapshot = await _firestore
          .collection('orders')
          .where('shopId', isEqualTo: shopId)
          .where('status', isEqualTo: 'completed')
          .where('createdAt', isGreaterThanOrEqualTo: start)
          .where('createdAt', isLessThanOrEqualTo: end)
          .get();

      // Cache products to reduce reads
      Map<String, DocumentSnapshot> productCache = {};

      for (var doc in orderSnapshot.docs) {
        Map<String, dynamic> orderData = doc.data() as Map<String, dynamic>;
        List<dynamic> items = orderData['items'] ?? [];

        for (var item in items) {
          String productId = item['productId'];
          int variantIndex = item['variantIndex'] ?? 0;
          int quantity = item['quantity'] ?? 1;
          double sellPrice = (item['price'] ?? 0).toDouble();

          // Fetch Product Data (if not in cache)
          if (!productCache.containsKey(productId)) {
            DocumentSnapshot prodDoc = await _firestore
                .collection('shops')
                .doc(shopId)
                .collection('products')
                .doc(productId)
                .get();
            productCache[productId] = prodDoc;
          }

          DocumentSnapshot? productDoc = productCache[productId];

          if (productDoc != null && productDoc.exists) {
            Map<String, dynamic>? data =
                productDoc.data() as Map<String, dynamic>?;
            List<dynamic> variants = data?['variants'] ?? [];

            if (variantIndex < variants.length) {
              var variantData = variants[variantIndex];
              double buyPrice = (variantData['buyPrice'] ?? 0).toDouble();

              // Profit Formula
              totalProfit += (sellPrice - buyPrice) * quantity;
            }
          }
        }
      }
    } catch (e) {
      print("Error in profit calc: $e");
    }
    return totalProfit;
  }

  // --- 2. ROBUST ATOMIC STOCK REDUCTION ---
  Future<void> _reduceStock(Map<String, dynamic> orderData) async {
    String shopId = orderData['shopId'];
    List<dynamic> items = orderData['items'] ?? [];

    if (items.isEmpty) return;

    try {
      // We run ONE transaction for the entire order.
      // This ensures either ALL items update, or NONE do (no partial data).
      await _firestore.runTransaction((transaction) async {
        // --- PHASE 1: READ ALL PRODUCTS ---
        // We fetch the latest data for every product involved in this order.
        Map<String, DocumentSnapshot> productSnapshots = {};

        for (var item in items) {
          String productId = item['productId'];

          // Only fetch if we haven't already (in case user bought 2 variants of same product)
          if (!productSnapshots.containsKey(productId)) {
            DocumentReference ref = _firestore
                .collection('shops')
                .doc(shopId)
                .collection('products')
                .doc(productId);

            DocumentSnapshot snapshot = await transaction.get(ref);
            productSnapshots[productId] = snapshot;
          }
        }

        // --- PHASE 2: CALCULATE UPDATES ---
        // We track changes in a local map first.
        // Key: ProductID, Value: The NEW list of variants
        Map<String, List<dynamic>> updatesToCommit = {};

        for (var item in items) {
          String productId = item['productId'];
          int quantityToReduce = item['quantity'] ?? 0;
          int variantIndex = item['variantIndex'] ?? 0;

          DocumentSnapshot? snapshot = productSnapshots[productId];

          // Skip if product doesn't exist in DB anymore
          if (snapshot == null || !snapshot.exists) continue;

          // Determine which list of variants to use:
          // 1. If we already modified this product in this loop (e.g. item 1 was Size S, item 2 is Size M),
          //    we must use the ALREADY MODIFIED list from 'updatesToCommit'.
          // 2. Otherwise, use the fresh list from the DB 'snapshot'.
          List<dynamic> currentVariants;
          if (updatesToCommit.containsKey(productId)) {
            currentVariants = updatesToCommit[productId]!;
          } else {
            // Important: Use List.from to create a modifiable copy
            currentVariants = List.from(snapshot.get('variants') ?? []);
          }

          // Check if index is valid
          if (variantIndex < currentVariants.length) {
            // Create a modifiable copy of the specific variant map
            Map<String, dynamic> targetVariant = Map.from(
              currentVariants[variantIndex],
            );

            int currentStock = (targetVariant['stock'] ?? 0);
            int newStock = currentStock - quantityToReduce;

            // Safety: Don't let stock go below 0
            if (newStock < 0) newStock = 0;

            // Apply change
            targetVariant['stock'] = newStock;
            currentVariants[variantIndex] = targetVariant;

            // Save the updated list to our tracker
            updatesToCommit[productId] = currentVariants;
          }
        }

        // --- PHASE 3: WRITE COMMITS ---
        // Now we write the final calculated lists back to Firestore
        updatesToCommit.forEach((productId, newVariantsList) {
          DocumentReference ref = _firestore
              .collection('shops')
              .doc(shopId)
              .collection('products')
              .doc(productId);

          transaction.update(ref, {'variants': newVariantsList});
        });
      });

      print("✅ Stock reduced successfully for all items.");
    } catch (e) {
      print("❌ Failed to reduce stock: $e");
      // Rethrow so the UI knows something went wrong
      throw e;
    }
  }

  // --- 3. ORDER STATUS ACTIONS ---
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'status': newStatus,
      });
      Get.snackbar('Success', 'Order updated to $newStatus');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update order status.');
    }
  }

  void acceptOrder(String orderId) => updateOrderStatus(orderId, 'preparing');
  void declineOrder(String orderId) => updateOrderStatus(orderId, 'cancelled');
  void markAsReady(String orderId) =>
      updateOrderStatus(orderId, 'ready_for_pickup');

  // --- 4. COMPLETE ORDER (QR SCAN) ---
  Future<void> completeOrder(String code) async {
    if (code.isEmpty) return;

    Get.dialog(
      const Center(child: CircularProgressIndicator(color: Colors.white)),
      barrierDismissible: false,
    );

    try {
      final querySnapshot = await _firestore
          .collection('orders')
          .where('pickupCode', isEqualTo: code)
          .where('status', isEqualTo: 'ready_for_pickup')
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        if (Get.isDialogOpen == true) Get.back();
        Get.snackbar(
          "Invalid",
          "Code incorrect or order not ready.",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return;
      }

      DocumentSnapshot orderDoc = querySnapshot.docs.first;
      Map<String, dynamic> orderData = orderDoc.data() as Map<String, dynamic>;

      // A. Reduce Stock
      await _reduceStock(orderData);

      // B. Update Status
      await orderDoc.reference.update({
        'status': 'completed',
        'completedAt': FieldValue.serverTimestamp(),
      });

      // C. Refresh Profit
      if (_shopId != null) calculatePerformanceMetrics(_shopId!);

      if (Get.isDialogOpen == true) Get.back();

      Get.defaultDialog(
        title: "Success",
        middleText: "Order completed and Stock updated!",
        confirmTextColor: Colors.white,
        buttonColor: const Color(0xFF5A7D60),
        onConfirm: () {
          Get.back(); // Close Dialog
          Get.back(); // Close Scanner
        },
      );
    } catch (e) {
      if (Get.isDialogOpen == true) Get.back();
      Get.snackbar("Error", "Failed: $e", backgroundColor: Colors.red);
    }
  }
}
