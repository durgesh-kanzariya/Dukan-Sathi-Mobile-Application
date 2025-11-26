import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// --- DATA MODEL ---
class CartItem {
  final String productId;
  final String imageUrl;
  final String name;
  final String variant;
  final double price;
  final String shopId;
  final String shopName;
  RxInt quantity;

  CartItem({
    required this.productId,
    required this.imageUrl,
    required this.name,
    required this.variant,
    required this.price,
    required this.shopId,
    required this.shopName,
    int quantity = 1,
  }) : quantity = quantity.obs;
}

// --- CONTROLLER ---
class CartController extends GetxController {
  var cartItems = <CartItem>[].obs;

  double get grandTotal => cartItems.fold(
    0,
    (sum, item) => sum + (item.price * item.quantity.value),
  );

  // 1. Add Item to Cart
  void addToCart(CartItem newItem) {
    var existingItem = cartItems.firstWhereOrNull(
      (item) =>
          item.productId == newItem.productId &&
          item.variant == newItem.variant,
    );

    if (existingItem != null) {
      existingItem.quantity.value += newItem.quantity.value;
      Get.snackbar(
        "Updated",
        "${newItem.name} quantity updated",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1),
      );
    } else {
      cartItems.add(newItem);
      Get.snackbar(
        "Added",
        "${newItem.name} added to cart",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1),
      );
    }
  }

  // 2. Remove Item
  void removeFromCart(CartItem item) {
    cartItems.remove(item);
  }

  // --- FIX: Decrease Quantity Logic ---
  void decreaseQuantity(CartItem item) {
    if (item.quantity.value > 1) {
      item.quantity.value--;
    } else {
      // Optional: Ask to remove if qty goes below 1
      removeFromCart(item);
    }
  }

  void increaseQuantity(CartItem item) {
    if (item.quantity.value < 99) {
      item.quantity.value++;
    }
  }

  void clearCart() {
    cartItems.clear();
  }

  // --- PLACE ORDER LOGIC ---
  Future<void> placeOrders() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      Get.snackbar("Error", "Please login first");
      return;
    }

    if (cartItems.isEmpty) return;

    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      // 1. DEBUG: Print what is currently in the cart
      print("--- STARTING ORDER PLACEMENT ---");
      print("Total items in cart: ${cartItems.length}");
      for (var item in cartItems) {
        print(
          "Item: ${item.name} | Shop Name: ${item.shopName} | Shop ID: ${item.shopId}",
        );
      }

      // 2. Group items by Shop ID
      Map<String, List<CartItem>> itemsByShop = {};
      for (var item in cartItems) {
        if (!itemsByShop.containsKey(item.shopId)) {
          itemsByShop[item.shopId] = [];
        }
        itemsByShop[item.shopId]!.add(item);
      }

      print("--- GROUPING RESULT ---");
      print("Unique Shops identified: ${itemsByShop.keys.length}");

      // 3. Create Separate Orders
      for (var entry in itemsByShop.entries) {
        String shopId = entry.key;
        List<CartItem> items = entry.value;

        print(
          "Creating order for Shop ID: $shopId containing ${items.length} items...",
        );

        double orderTotal = items.fold(
          0,
          (sum, x) => sum + (x.price * x.quantity.value),
        );

        // Create the order in Firebase
        await FirebaseFirestore.instance.collection('orders').add({
          'customerId': uid,
          'shopId':
              shopId, // <--- THIS is what routes it to the specific shopkeeper
          'shopName': items.first.shopName,
          'status': 'pending',
          'totalPrice': orderTotal,
          'createdAt': FieldValue.serverTimestamp(),
          'pickupCode': DateTime.now().millisecondsSinceEpoch
              .toString()
              .substring(7),
          'items': items
              .map(
                (item) => {
                  'productId': item.productId,
                  'productName': item.name,
                  'variant': item.variant,
                  'price': item.price,
                  'quantity': item.quantity.value,
                  'imageUrl': item.imageUrl,
                },
              )
              .toList(),
        });
      }

      Get.back(); // Close loading
      clearCart();
      Get.snackbar("Success", "Orders placed separately!");
    } catch (e) {
      Get.back();
      print("ERROR: $e");
      Get.snackbar("Error", "Failed: $e");
    }
  }
}
