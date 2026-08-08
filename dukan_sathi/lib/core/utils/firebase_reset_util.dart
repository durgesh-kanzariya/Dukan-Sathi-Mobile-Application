import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'constants.dart';

/// Automated program utility to completely wipe all Firebase Firestore data
class FirebaseResetUtil {
  FirebaseResetUtil._();

  /// Programmatically deletes all documents across users, shops, products & orders
  static Future<void> wipeAllFirestoreData({String? email, String? password}) async {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;

    debugPrint("🔥 Starting automated Firebase wipe...");

    // 1. If not logged in, attempt temporary sign-in with provided credentials or anonymous fallback
    bool createdTempSession = false;
    if (auth.currentUser == null) {
      if (email != null && email.isNotEmpty && password != null && password.isNotEmpty) {
        try {
          await auth.signInWithEmailAndPassword(email: email, password: password);
          createdTempSession = true;
        } catch (e) {
          debugPrint("Sign in with provided credentials failed: $e");
        }
      }

      if (auth.currentUser == null) {
        try {
          await auth.signInAnonymously();
          createdTempSession = true;
        } catch (e) {
          debugPrint("Anonymous sign-in skipped/failed: $e");
        }
      }
    }

    try {
      // 2. Wipe 'orders' collection
      await _deleteCollectionAtPath(firestore, AppConstants.ordersCollection);

      // 3. Wipe 'shops' collection and nested 'products' subcollections
      final shopsSnapshot = await firestore.collection(AppConstants.shopsCollection).get();
      for (var shopDoc in shopsSnapshot.docs) {
        final productsPath = '${AppConstants.shopsCollection}/${shopDoc.id}/${AppConstants.productsSubCollection}';
        await _deleteCollectionAtPath(firestore, productsPath);
        await shopDoc.reference.delete();
      }

      // 4. Wipe 'users' collection and nested 'quickPurchaseList' subcollections
      final usersSnapshot = await firestore.collection(AppConstants.usersCollection).get();
      for (var userDoc in usersSnapshot.docs) {
        final quickListPath = '${AppConstants.usersCollection}/${userDoc.id}/${AppConstants.quickListSubCollection}';
        await _deleteCollectionAtPath(firestore, quickListPath);
        await userDoc.reference.delete();
      }

      debugPrint("✅ All Firebase Firestore collections & documents completely wiped!");
    } on FirebaseException catch (e) {
      debugPrint("Firestore Exception during wipe: ${e.code} - ${e.message}");
      if (e.code == 'permission-denied') {
        throw Exception(
          'PERMISSION_DENIED: Firebase Security Rules blocked deletion.\n\nTo fix this:\n1. Go to Firebase Console -> Firestore Database -> Rules tab.\n2. Change rules to allow testing:\n   allow read, write: if true;\n3. Or sign in to an active account before wiping.',
        );
      }
      rethrow;
    } finally {
      if (createdTempSession || auth.currentUser != null) {
        await auth.signOut();
      }
    }
  }

  static Future<void> _deleteCollectionAtPath(FirebaseFirestore firestore, String collectionPath) async {
    try {
      final snapshot = await firestore.collection(collectionPath).get();
      if (snapshot.docs.isEmpty) return;

      final batch = firestore.batch();
      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        rethrow;
      }
      debugPrint("Error wiping $collectionPath: $e");
    }
  }
}
