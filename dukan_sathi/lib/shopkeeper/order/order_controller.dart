import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// --- THIS IS THE NEW IMPORT PATH ---
import 'package:dukan_sathi/shopkeeper/order/order_model.dart' as order_model;
// ---
import 'package:dukan_sathi/shop_service.dart';
import 'package:dukan_sathi/shop_model.dart';

class OrderController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ShopService _shopService = Get.find<ShopService>();

  var allOrders = <order_model.Order>[].obs;
  var isLoading = true.obs;

  String? get _shopId => _shopService.currentShop.value?.id;

  // Computed lists. The UI will use these.
  List<order_model.Order> get newOrders =>
      allOrders.where((o) => o.status == 'pending').toList();

  List<order_model.Order> get preparingOrders =>
      allOrders.where((o) => o.status == 'preparing').toList();

  List<order_model.Order> get readyOrders =>
      allOrders.where((o) => o.status == 'ready_for_pickup').toList();

  List<order_model.Order> get historyOrders => allOrders
      .where((o) => o.status == 'completed' || o.status == 'cancelled')
      .toList();

  // Inside order_controller.dart
  @override
  void onInit() {
    super.onInit();
    // Listen to the shop service
    ever(_shopService.currentShop, (Shop? shop) {
      if (shop != null) {
        fetchOrders(shop.id);
      } else {
        allOrders.clear();
        isLoading.value = false; // <-- ADD THIS LINE
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
            Get.snackbar('Error', 'Could not fetch orders: $error');
          },
        );
  }

  // --- Functions to change order status ---

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'status': newStatus,
      });
      Get.snackbar('Success', 'Order status updated to "$newStatus"');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update order status.');
    }
  }

  // --- Functions for the UI to call ---
  void acceptOrder(String orderId) {
    updateOrderStatus(orderId, 'preparing');
  }

  void declineOrder(String orderId) {
    updateOrderStatus(orderId, 'cancelled');
  }

  void markAsReady(String orderId) {
    updateOrderStatus(orderId, 'ready_for_pickup');
  }

  // This one will be called from the PickupCodeScreen
  Future<void> completeOrder(String pickupCode) async {
    if (_shopId == null) {
      Get.snackbar('Error', 'Shop not loaded. Please wait.');
      return;
    }

    // Show a loading dialog
    Get.dialog(
      const Center(child: CircularProgressIndicator(color: Color(0xFF5A7D60))),
      barrierDismissible: false,
    );

    try {
      // Find the order by pickup code
      final query = await _firestore
          .collection('orders')
          .where('shopId', isEqualTo: _shopId)
          .where('pickupCode', isEqualTo: pickupCode.trim()) // trim whitespace
          .where('status', isEqualTo: 'ready_for_pickup')
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        Get.back(); // Close loading dialog
        Get.snackbar('Not Found', 'No ready order found with that code.');
        return;
      }

      // Found it, now complete it
      final orderId = query.docs.first.id;
      await updateOrderStatus(orderId, 'completed');

      Get.back(); // Close loading dialog
      Get.back(); // Go back from scan screen
      Get.snackbar('Success', 'Order $orderId completed!');
    } catch (e) {
      Get.back(); // Close loading dialog
      Get.snackbar('Error', 'Failed to complete order.');
    }
    // We don't use finally/isLoading here because of the dialog
  }
}
