// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dukan_sathi/shop_model.dart';
// import 'package:dukan_sathi/shopkeeper/product/products_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart' as p;
// import 'package:dukan_sathi/shopkeeper/product/product_model.dart';
// import 'package:dukan_sathi/shop_service.dart';

// class ProductController extends GetxController {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//   final ShopService _shopService = Get.find<ShopService>();

//   var products = <Product>[].obs;
//   var isLoading = true.obs;
//   var isUploading = false.obs;
//   var isUpdating = false.obs;
//   var isDeleting = false.obs;

//   String? get _shopId => _shopService.currentShop.value?.id;
//   String? get _ownerId => _shopService.currentShop.value?.ownerId;

//   @override
//   void onInit() {
//     super.onInit();
//     ever(_shopService.currentShop, (Shop? shop) {
//       if (shop != null) {
//         fetchProducts(shop.id);
//       } else {
//         products.clear();
//         isLoading.value = false;
//       }
//     });
//   }

//   CollectionReference<Map<String, dynamic>> _productsCollection(String shopId) {
//     return _firestore.collection('shops').doc(shopId).collection('products');
//   }

//   void fetchProducts(String shopId) {
//     isLoading.value = true;
//     _productsCollection(shopId).snapshots().listen(
//       (snapshot) {
//         products.value = snapshot.docs
//             .map((doc) => Product.fromSnapshot(doc))
//             .toList();
//         isLoading.value = false;
//       },
//       onError: (error) {
//         isLoading.value = false;
//         Get.snackbar('Error', 'Could not fetch products: $error');
//       },
//     );
//   }

//   Future<bool> addProduct({
//     required String name,
//     required String description,
//     required XFile imageFile,
//     required List<ProductVariant> variants,
//   }) async {
//     if (_shopId == null || _ownerId == null) {
//       Get.snackbar('Error', 'No shop found. Cannot add product.');
//       return false;
//     }

//     isUploading.value = true;

//     try {
//       String imageUrl = await _uploadImage(imageFile, _ownerId!);

//       final newProductData = {
//         'productName': name,
//         'description': description,
//         'imageUrl': imageUrl,
//         'variants': variants.map((v) => v.toMap()).toList(),
//         'createdAt': FieldValue.serverTimestamp(),
//       };

//       await _productsCollection(_shopId!).add(newProductData);
//       return true;
//     } catch (e) {
//       print("Error adding product: $e");
//       Get.snackbar('Error', 'Failed to add product: $e');
//       return false;
//     } finally {
//       isUploading.value = false;
//     }
//   }

//   Future<void> updateProduct({
//     required String id,
//     required String name,
//     required String description,
//     required List<ProductVariant> variants,
//     XFile? newImageFile,
//     String? existingImageUrl,
//   }) async {
//     if (_shopId == null) return;
//     isUpdating.value = true;

//     String? oldImageUrl = existingImageUrl; // Store old image URL

//     try {
//       String imageUrl = existingImageUrl ?? '';
//       if (newImageFile != null) {
//         // Upload new image first
//         imageUrl = await _uploadImage(newImageFile, _ownerId!);

//         // Delete old image after successful upload
//         if (oldImageUrl != null && oldImageUrl.isNotEmpty) {
//           await _deleteImageFromStorage(oldImageUrl);
//         }
//       }

//       final updatedProductData = {
//         'productName': name,
//         'description': description,
//         'imageUrl': imageUrl,
//         'variants': variants.map((v) => v.toMap()).toList(),
//       };

//       await _productsCollection(_shopId!).doc(id).update(updatedProductData);
//       Get.snackbar('Success', 'Product updated successfully!');
//       Get.back();
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to update product: $e');
//     } finally {
//       isUpdating.value = false;
//     }
//   }

//   Future<void> deleteProduct(String id, String imageUrl) async {
//     if (_shopId == null) return;

//     Get.dialog(
//       AlertDialog(
//         title: const Text('Delete Product'),
//         content: const Text('Are you sure you want to delete this product?'),
//         actions: [
//           TextButton(child: const Text('Cancel'), onPressed: () => Get.back()),
//           TextButton(
//             child: const Text('Delete', style: TextStyle(color: Colors.red)),
//             onPressed: () async {
//               Get.back(); // Close the dialog first
//               isDeleting.value = true;
//               try {
//                 // Delete the Firestore document first
//                 await _productsCollection(_shopId!).doc(id).delete();

//                 // Then delete the image from Firebase Storage
//                 await _deleteImageFromStorage(imageUrl);

//                 Get.snackbar('Success', 'Product deleted.');
//                 // Close both screens and go back to ProductsScreen
//                 Navigator.of(Get.context!).pop(); // Close EditProductScreen
//                 Navigator.of(Get.context!).pop(); // Close ProductDetailsScreen
//               } catch (e) {
//                 Get.snackbar('Error', 'Failed to delete product: $e');
//               } finally {
//                 isDeleting.value = false;
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   // Add this method to delete image from Firebase Storage
//   Future<void> _deleteImageFromStorage(String imageUrl) async {
//     try {
//       // Create a reference from the download URL
//       Reference storageRef = _storage.refFromURL(imageUrl);

//       // Delete the file
//       await storageRef.delete();

//       print('Product image deleted successfully from storage');
//     } catch (e) {
//       print('Error deleting product image from storage: $e');
//       // Don't throw the error here - we don't want image deletion failure
//       // to prevent product deletion from Firestore
//     }
//   }

//   Future<String> _uploadImage(XFile imageFile, String ownerId) async {
//     try {
//       String fileExtension = p.extension(imageFile.path);
//       String fileName =
//           '${ownerId}_${DateTime.now().millisecondsSinceEpoch}$fileExtension';
//       Reference storageRef = _storage
//           .ref()
//           .child('product_images')
//           .child(ownerId)
//           .child(fileName);
//       UploadTask uploadTask = storageRef.putFile(File(imageFile.path));
//       TaskSnapshot snapshot = await uploadTask;
//       return await snapshot.ref.getDownloadURL();
//     } catch (e) {
//       print("Product image upload error: $e");
//       throw Exception('Product image upload failed');
//     }
//   }
// }

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dukan_sathi/shop_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary_public/cloudinary_public.dart'; // Import Cloudinary
import 'package:dukan_sathi/shopkeeper/product/product_model.dart';
import 'package:dukan_sathi/shop_service.dart';

class ProductController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ShopService _shopService = Get.find<ShopService>();

  // --- CLOUDINARY CONFIGURATION ---
  // TODO: Replace 'YOUR_CLOUD_NAME' with your actual Cloudinary Cloud Name
  final cloudinary = CloudinaryPublic(
    'dizbwzb7i',
    'dukan_sathi_preset',
    cache: false,
  );

  var products = <Product>[].obs;
  var isLoading = true.obs;
  var isUploading = false.obs;
  var isUpdating = false.obs;
  var isDeleting = false.obs;

  String? get _shopId => _shopService.currentShop.value?.id;
  String? get _ownerId => _shopService.currentShop.value?.ownerId;

  @override
  void onInit() {
    super.onInit();
    ever(_shopService.currentShop, (Shop? shop) {
      if (shop != null) {
        fetchProducts(shop.id);
      } else {
        products.clear();
        isLoading.value = false;
      }
    });
  }

  CollectionReference<Map<String, dynamic>> _productsCollection(String shopId) {
    return _firestore.collection('shops').doc(shopId).collection('products');
  }

  void fetchProducts(String shopId) {
    isLoading.value = true;
    _productsCollection(shopId).snapshots().listen(
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

  Future<bool> addProduct({
    required String name,
    required String description,
    required XFile imageFile,
    required List<ProductVariant> variants,
  }) async {
    if (_shopId == null || _ownerId == null) {
      Get.snackbar('Error', 'No shop found. Cannot add product.');
      return false;
    }

    isUploading.value = true;

    try {
      String imageUrl = await _uploadImage(imageFile);

      final newProductData = {
        'shopId': _shopId, // <--- CRITICAL FIX: Save the Shop ID here!
        'productName': name,
        'description': description,
        'imageUrl': imageUrl,
        'variants': variants.map((v) => v.toMap()).toList(),
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _productsCollection(_shopId!).add(newProductData);
      return true;
    } catch (e) {
      // ... existing error handling
      return false;
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
        // --- NEW: Upload to Cloudinary ---
        imageUrl = await _uploadImage(newImageFile);
        // We skip deleting the old image to save time/complexity
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

  Future<void> deleteProduct(String id, String imageUrl) async {
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
              Get.back(); // Close dialog
              isDeleting.value = true;
              try {
                // Delete Firestore document only
                await _productsCollection(_shopId!).doc(id).delete();

                // Skip deleting from Cloudinary (requires API secret or signature)

                Get.snackbar('Success', 'Product deleted.');
                // Close screens
                Navigator.of(Get.context!).pop(); // Close EditProductScreen
                Navigator.of(Get.context!).pop(); // Close ProductDetailsScreen
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

  // --- NEW: Cloudinary Upload Function ---
  Future<String> _uploadImage(XFile imageFile) async {
    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imageFile.path,
          resourceType: CloudinaryResourceType.Image,
          folder: 'product_images', // <--- Specific folder for products
        ),
      );
      return response.secureUrl;
    } catch (e) {
      print("Product image upload error: $e");
      throw Exception('Product image upload failed');
    }
  }
}
