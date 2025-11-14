import 'dart:io'; // For File
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart'; // For Storage
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart'; // For XFile
import 'package:path/path.dart' as p; // For path extension
import 'shop_model.dart';

class ShopService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // --- NEW: Add Storage ---
  final FirebaseStorage _storage = FirebaseStorage.instance;

  var currentShop = Rxn<Shop>();
  var isLoading = true.obs;
  // --- NEW: Loading state for image uploads ---
  var isUploadingImage = false.obs;

  // Add this to shop_service.dart
  Future<void> createNewShop({
    required String shopName,
    required String address,
    required String description,
    required String contact,
    required String openTime,
    required String closeTime,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    isLoading.value = true;
    try {
      final shopRef = _firestore.collection('shops').doc();
      final newShop = Shop(
        id: shopRef.id,
        shopName: shopName,
        address: address,
        ownerId: user.uid,
        imageUrl: '',
        description: description,
        contact: contact,
        openTime: openTime,
        closeTime: closeTime,
      );

      await shopRef.set(newShop.toMap());
      currentShop.value = newShop;

      Get.snackbar('Success', 'Shop created successfully!');
    } catch (e) {
      print("ShopService Error creating shop: $e");
      Get.snackbar('Error', 'Could not create shop.');
    } finally {
      isLoading.value = false;
    }
  }

  // Add this method to check if user has a shop
  Future<bool> hasShop() async {
    final user = _auth.currentUser;
    if (user == null) return false;

    try {
      final query = await _firestore
          .collection('shops')
          .where('ownerId', isEqualTo: user.uid)
          .limit(1)
          .get();

      return query.docs.isNotEmpty;
    } catch (e) {
      print("Error checking shop existence: $e");
      return false;
    }
  }

  Future<ShopService> init() async {
    print("🛍️ ShopService: Initializing...");

    // Start listening to auth changes immediately
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        print(
          "🛍️ ShopService: User detected, fetching shop data for ${user.uid}",
        );
        _fetchShopData(user.uid);
      } else {
        print("🛍️ ShopService: No user, clearing shop data");
        currentShop.value = null;
        isLoading.value = false;
      }
    });

    // If user is already logged in, fetch shop data immediately
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      print(
        "🛍️ ShopService: Current user exists, fetching shop data immediately",
      );
      await _fetchShopData(currentUser.uid);
    } else {
      isLoading.value = false;
    }

    return this;
  }

  // In shop_service.dart, update the _fetchShopData method:
  Future<void> _fetchShopData(String userId) async {
    isLoading.value = true;
    print("🛍️ ShopService: Fetching shop data for user: $userId");

    try {
      final query = _firestore
          .collection('shops')
          .where('ownerId', isEqualTo: userId)
          .limit(1);

      query.snapshots().listen(
        (snapshot) {
          print(
            "🛍️ ShopService: Received snapshot with ${snapshot.docs.length} shops",
          );

          if (snapshot.docs.isNotEmpty) {
            currentShop.value = Shop.fromSnapshot(snapshot.docs.first);
            print(
              "🛍️ ShopService: Successfully loaded shop: ${currentShop.value?.shopName}",
            );
          } else {
            currentShop.value = null;
            print("🛍️ ShopService: No shop found for user: $userId");
          }
          isLoading.value = false;
        },
        onError: (error) {
          print("🛍️ ShopService: Error listening to shop data: $error");
          isLoading.value = false;
        },
      );
    } catch (e) {
      print("🛍️ ShopService Error fetching shop: $e");
      isLoading.value = false;
    }
  }

  // --- UPDATED: Now saves all new fields ---
  Future<void> updateShopDetails({
    required String shopName,
    required String address,
    required String description,
    required String contact,
    required String openTime,
    required String closeTime,
  }) async {
    if (currentShop.value == null) return;

    isLoading.value = true; // Use the main loading flag
    try {
      final shopRef = _firestore.collection('shops').doc(currentShop.value!.id);
      await shopRef.update({
        'shopName': shopName,
        'address': address,
        'description': description,
        'contact': contact,
        'openTime': openTime,
        'closeTime': closeTime,
      });

      Get.snackbar('Success', 'Shop details updated!');
    } catch (e) {
      print("ShopService Error updating shop: $e");
      Get.snackbar('Error', 'Could not update shop details.');
    } finally {
      isLoading.value = false;
    }
  }

  // --- NEW: Function to upload/update shop image ---
  // In ShopService class
  // In ShopService class, update the updateShopImage method
  Future<void> updateShopImage(XFile imageFile) async {
    if (currentShop.value == null) {
      Get.snackbar('Error', 'No shop found');
      return;
    }

    isUploadingImage.value = true;

    String? oldImageUrl = currentShop.value!.imageUrl; // Store old image URL

    try {
      // Upload new image to Firebase Storage
      String newImageUrl = await _uploadShopImage(imageFile);

      // Update Firestore with new image URL
      await _firestore.collection('shops').doc(currentShop.value!.id).update({
        'imageUrl': newImageUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Delete the old image after successful update
      if (oldImageUrl != null && oldImageUrl.isNotEmpty) {
        // Added null check
        await _deleteImageFromStorage(oldImageUrl);
      }

      // Update local state
      currentShop.value = currentShop.value!.copyWith(imageUrl: newImageUrl);

      Get.snackbar('Success', 'Shop image updated successfully!');
    } catch (e) {
      print('Error updating shop image: $e');
      Get.snackbar('Error', 'Failed to update image: $e');
    } finally {
      isUploadingImage.value = false;
    }
  }

  // Add this method to ShopService
  Future<void> _deleteImageFromStorage(String imageUrl) async {
    try {
      Reference storageRef = _storage.refFromURL(imageUrl);
      await storageRef.delete();
      print('Old shop image deleted successfully');
    } catch (e) {
      print('Error deleting old shop image: $e');
    }
  }

  Future<String> _uploadShopImage(XFile imageFile) async {
    try {
      String fileExtension = p.extension(imageFile.path);
      String fileName =
          'shop_${currentShop.value!.id}_${DateTime.now().millisecondsSinceEpoch}$fileExtension';

      Reference storageRef = _storage
          .ref()
          .child('shop_images')
          .child(currentShop.value!.ownerId)
          .child(fileName);

      UploadTask uploadTask = storageRef.putFile(File(imageFile.path));
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("Shop image upload error: $e");
      throw Exception('Shop image upload failed');
    }
  }

  // --- NEW: Helper function (from ProductController) ---
  Future<String> _uploadImage(XFile imageFile, String ownerId) async {
    try {
      String fileExtension = p.extension(imageFile.path);
      String fileName =
          '${ownerId}_shopImage_${DateTime.now().millisecondsSinceEpoch}$fileExtension';
      Reference storageRef = _storage
          .ref()
          .child('shop_images') // Different folder
          .child(ownerId)
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
