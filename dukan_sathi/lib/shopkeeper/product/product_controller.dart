import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart'; // Import for Get.dialog
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'product_model.dart';

class ProductController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  var products = <Product>[].obs;
  var isLoading = true.obs;
  var isUploading = false.obs; // For addProduct
  var isUpdating = false.obs; // For updateProduct
  var isDeleting = false.obs; // For deleteProduct

  User? get _currentUser => _auth.currentUser;

  @override
  void onInit() {
    super.onInit();
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        fetchProducts(user.uid);
      } else {
        products.clear();
      }
    });
  }

  CollectionReference<Map<String, dynamic>> _productsCollection(String uid) {
    return _firestore.collection('users').doc(uid).collection('products');
  }

  void fetchProducts(String uid) {
    isLoading.value = true;
    _productsCollection(uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
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
            print("Error fetching products: $error");
          },
        );
  }

  Future<void> addProduct({
    required String name,
    required XFile imageFile,
    required List<ProductVariant> variants,
  }) async {
    if (_currentUser == null) {
      Get.snackbar('Error', 'You must be logged in.');
      return;
    }
    isUploading.value = true;
    try {
      String imageUrl = await _uploadImage(imageFile, _currentUser!.uid);
      final newProductData = {
        'name': name,
        'imageUrl': imageUrl,
        'variants': variants.map((v) => v.toMap()).toList(),
        'createdAt': FieldValue.serverTimestamp(),
      };
      await _productsCollection(_currentUser!.uid).add(newProductData);
      Get.snackbar('Success', 'Product added successfully!');
      Get.back(); // Go back from AddProductScreen
    } catch (e) {
      Get.snackbar('Error', 'Failed to add product: $e');
      print("Error adding product: $e");
    } finally {
      isUploading.value = false;
    }
  }

  // --- NEW: UPDATE FUNCTION ---
  Future<void> updateProduct({
    required String id,
    required String name,
    required List<ProductVariant> variants,
    XFile? newImageFile, // Image is optional on update
    String? existingImageUrl,
  }) async {
    if (_currentUser == null) {
      Get.snackbar('Error', 'You must be logged in.');
      return;
    }

    isUpdating.value = true;
    try {
      String imageUrl = existingImageUrl ?? '';

      // 1. If a new image is provided, upload it
      if (newImageFile != null) {
        imageUrl = await _uploadImage(newImageFile, _currentUser!.uid);
        // TODO: Optionally, delete the old image from storage
      }

      // 2. Prepare data for Firestore
      final updatedProductData = {
        'name': name,
        'imageUrl': imageUrl,
        'variants': variants.map((v) => v.toMap()).toList(),
      };

      // 3. Update in Firestore
      await _productsCollection(
        _currentUser!.uid,
      ).doc(id).update(updatedProductData);

      Get.snackbar('Success', 'Product updated successfully!');
      Get.back(); // Go back from EditProductScreen
    } catch (e) {
      Get.snackbar('Error', 'Failed to update product: $e');
      print("Error updating product: $e");
    } finally {
      isUpdating.value = false;
    }
  }

  // --- NEW: DELETE FUNCTION ---
  Future<void> deleteProduct(String id) async {
    if (_currentUser == null) {
      Get.snackbar('Error', 'You must be logged in.');
      return;
    }

    // --- Show confirmation dialog ---
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Product'),
        content: const Text(
          'Are you sure you want to delete this product? This action cannot be undone.',
        ),
        actions: [
          TextButton(child: const Text('Cancel'), onPressed: () => Get.back()),
          TextButton(
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
            onPressed: () async {
              Get.back(); // Close dialog
              isDeleting.value = true;
              try {
                // 1. Delete Firestore document
                await _productsCollection(_currentUser!.uid).doc(id).delete();

                // TODO: Delete the image from Firebase Storage
                // (This is more advanced, can be added later)

                Get.snackbar('Success', 'Product deleted.');
                // Go back from EditProductScreen (where delete is called)
                Get.back();
              } catch (e) {
                Get.snackbar('Error', 'Failed to delete product: $e');
                print("Error deleting product: $e");
              } finally {
                isDeleting.value = false;
              }
            },
          ),
        ],
      ),
    );
  }

  Future<String> _uploadImage(XFile imageFile, String uid) async {
    try {
      String fileExtension = p.extension(imageFile.path);
      String fileName =
          '${uid}_${DateTime.now().millisecondsSinceEpoch}$fileExtension';
      Reference storageRef = _storage
          .ref()
          .child('product_images')
          .child(uid)
          .child(fileName);
      UploadTask uploadTask = storageRef.putFile(File(imageFile.path));
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("Image upload error: $e");
      throw Exception('Image upload failed');
    }
  }
}
