import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'cart_controller.dart';

class QuickListController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CartController _cartController = Get.find<CartController>();

  String? get uid => _auth.currentUser?.uid;

  // 1. Update Quantity in Firestore
  Future<void> updateQuantity(
    String docId,
    int currentQty,
    bool increase,
  ) async {
    if (uid == null) return;

    int newQty = increase ? currentQty + 1 : currentQty - 1;

    if (newQty < 1) return; // Don't go below 1

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('quickPurchaseList')
        .doc(docId)
        .update({'quantity': newQty});
  }

  // 2. Delete Item
  Future<void> deleteItem(String docId) async {
    if (uid == null) return;

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('quickPurchaseList')
        .doc(docId)
        .delete();

    Get.snackbar(
      "Removed",
      "Item removed from list",
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }

  // 3. Add All Items to Cart
  Future<void> addAllToCart() async {
    if (uid == null) {
      Get.snackbar("Error", "Please login first");
      return;
    }

    // Show loading
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      // A. Fetch all items from Quick List
      var snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('quickPurchaseList')
          .get();

      if (snapshot.docs.isEmpty) {
        Get.back();
        Get.snackbar("Empty", "Your list is empty");
        return;
      }

      int addedCount = 0;

      // B. Loop through items
      for (var doc in snapshot.docs) {
        var data = doc.data();
        String productId = data['productId'];
        String shopId = data['shopId'];
        String variantName = data['variant'] ?? '';
        int qty = data['quantity'] ?? 1;

        // C. FETCH LIVE PRICE (Critical Step)
        // We fetch the product from the Shop to ensure the price is up-to-date
        double price = 0.0;
        try {
          var productDoc = await _firestore
              .collection('shops')
              .doc(shopId)
              .collection('products')
              .doc(productId)
              .get();

          if (productDoc.exists) {
            var prodData = productDoc.data()!;

            // Try to find the price for the specific variant
            var variants = prodData['variants'] as List<dynamic>? ?? [];

            // Default to base price if exists
            if (prodData.containsKey('price')) {
              price = double.tryParse(prodData['price'].toString()) ?? 0.0;
            }

            // Look for variant specific price
            for (var v in variants) {
              if (v is Map &&
                  (v['name'] == variantName || v['variant'] == variantName)) {
                if (v.containsKey('sellPrice')) {
                  price = double.tryParse(v['sellPrice'].toString()) ?? price;
                }
                break;
              }
            }
          }
        } catch (e) {
          print(
            "Could not fetch live price for $productId, skipping or using 0",
          );
        }

        // D. Add to Cart Controller
        _cartController.addToCart(
          CartItem(
            productId: productId,
            imageUrl: data['imageUrl'] ?? '',
            name: data['productName'] ?? 'Unknown',
            variant: variantName,
            price: price, // The live fetched price
            shopId: shopId,
            shopName: data['shopName'] ?? 'Shop',
            quantity: qty,
          ),
        );

        addedCount++;
      }

      Get.back(); // Close loading

      Get.snackbar(
        "Success",
        "$addedCount items added to your cart!",
        backgroundColor: const Color(0xFF5A7D60),
        colorText: Colors.white,
      );

      // Optional: Navigate to Cart
      // Get.to(() => const CardPage());
    } catch (e) {
      Get.back();
      Get.snackbar(
        "Error",
        "Failed to add items: $e",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }
}
