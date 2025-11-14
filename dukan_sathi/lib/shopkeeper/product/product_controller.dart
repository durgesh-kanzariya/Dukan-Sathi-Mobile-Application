import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dukan_sathi/shop_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:dukan_sathi/shopkeeper/product/product_model.dart';
import 'package:dukan_sathi/shop_service.dart'; // <-- 1. Import ShopService

class ProductController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ShopService _shopService =
      Get.find<ShopService>(); // <-- 2. Find ShopService

  var products = <Product>[].obs;
  var isLoading = true.obs;
  var isUploading = false.obs;
  var isUpdating = false.obs;
  var isDeleting = false.obs;

  // 3. Get the current Shop ID
  String? get _shopId => _shopService.currentShop.value?.id;
  // 4. Get the owner ID (for image paths)
  String? get _ownerId => _shopService.currentShop.value?.ownerId;

  // Inside product_controller.dart
  @override
  void onInit() {
    super.onInit();
    // 5. Listen to changes in the currentShop from the ShopService
    ever(_shopService.currentShop, (Shop? shop) {
      if (shop != null) {
        fetchProducts(shop.id);
      } else {
        products.clear();
        isLoading.value = false; // <-- ADD THIS LINE
      }
    });
  }

  // 6. Get the correct collection reference
  CollectionReference<Map<String, dynamic>> _productsCollection(String shopId) {
    return _firestore.collection('shops').doc(shopId).collection('products');
  }

  void fetchProducts(String shopId) {
    isLoading.value = true;
    _productsCollection(shopId)
        .snapshots() // No orderBy needed, we'll sort in code if needed
        .listen(
          (snapshot) {
            products.value = snapshot.docs
                .map((doc) => Product.fromSnapshot(doc))
                .toList();
            isLoading.value = false;
          },
          onError: (error) {
            isLoading.value = false;
            Get.snackbar('Error', 'Could not fetch products: $error');
          },
        );
  }

  Future<void> addProduct({
    required String name,
    required String description,
    required XFile imageFile,
    required List<ProductVariant> variants,
  }) async {
    if (_shopId == null || _ownerId == null) {
      Get.snackbar('Error', 'No shop found. Cannot add product.');
      return;
    }
    isUploading.value = true;
    try {
      String imageUrl = await _uploadImage(imageFile, _ownerId!);
      final newProductData = {
        'productName': name,
        'description': description,
        'imageUrl': imageUrl,
        'variants': variants.map((v) => v.toMap()).toList(),
        'createdAt':
            FieldValue.serverTimestamp(), // Not in your model, but good practice
      };
      await _productsCollection(_shopId!).add(newProductData);
      Get.snackbar('Success', 'Product added successfully!');
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Failed to add product: $e');
    } finally {
      isUploading.value = false;
    }
  }

  Future<void> updateProduct({
    required String id,
    required String name,
    required String description,
    required List<ProductVariant> variants,
    XFile? newImageFile,
    String? existingImageUrl,
  }) async {
    if (_shopId == null) return;
    isUpdating.value = true;
    try {
      String imageUrl = existingImageUrl ?? '';
      if (newImageFile != null) {
        imageUrl = await _uploadImage(newImageFile, _ownerId!);
        // TODO: Delete old image from storage
      }
      final updatedProductData = {
        'productName': name,
        'description': description,
        'imageUrl': imageUrl,
        'variants': variants.map((v) => v.toMap()).toList(),
      };
      await _productsCollection(_shopId!).doc(id).update(updatedProductData);
      Get.snackbar('Success', 'Product updated successfully!');
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Failed to update product: $e');
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> deleteProduct(String id) async {
    if (_shopId == null) return;
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(child: const Text('Cancel'), onPressed: () => Get.back()),
          TextButton(
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
            onPressed: () async {
              Get.back();
              isDeleting.value = true;
              try {
                await _productsCollection(_shopId!).doc(id).delete();
                // TODO: Delete image from Storage
                Get.snackbar('Success', 'Product deleted.');
                Get.back();
              } catch (e) {
                Get.snackbar('Error', 'Failed to delete product: $e');
              } finally {
                isDeleting.value = false;
              }
            },
          ),
        ],
      ),
    );
  }

  Future<String> _uploadImage(XFile imageFile, String ownerId) async {
    try {
      String fileExtension = p.extension(imageFile.path);
      String fileName =
          '${ownerId}_${DateTime.now().millisecondsSinceEpoch}$fileExtension';
      Reference storageRef = _storage
          .ref()
          .child('product_images') // Main folder
          .child(ownerId) // Subfolder per user
          .child(fileName); // File
      UploadTask uploadTask = storageRef.putFile(File(imageFile.path));
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("Image upload error: $e");
      throw Exception('Image upload failed');
    }
  }
}
