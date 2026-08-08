import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../../core/utils/constants.dart';
import '../models/quick_list_item_model.dart';

abstract class IQuickListRemoteDataSource {
  Stream<List<QuickListItemModel>> getQuickListStream();
  Future<void> addToQuickList(QuickListItemModel item);
  Future<void> updateQuantity(String productId, int newQuantity);
  Future<void> deleteItem(String productId);
  Future<void> clearList();
}

class QuickListRemoteDataSourceImpl implements IQuickListRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  QuickListRemoteDataSourceImpl({
    FirebaseFirestore? firestore,
    FirebaseAuth? firebaseAuth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  String? get _uid => _firebaseAuth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>>? get _quickListCollection {
    if (_uid == null) return null;
    return _firestore
        .collection(AppConstants.usersCollection)
        .doc(_uid!)
        .collection(AppConstants.quickListSubCollection);
  }

  @override
  Stream<List<QuickListItemModel>> getQuickListStream() {
    final col = _quickListCollection;
    if (col == null) return Stream.value([]);

    return col.snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => QuickListItemModel.fromDocument(doc))
              .toList(),
        );
  }

  @override
  Future<void> addToQuickList(QuickListItemModel item) async {
    final col = _quickListCollection;
    if (col == null) return;
    final docId = '${item.productId}_${item.variant.replaceAll(' ', '_')}';
    await col.doc(docId).set(item.toMap(), SetOptions(merge: true));
  }

  @override
  Future<void> updateQuantity(String docId, int newQuantity) async {
    final col = _quickListCollection;
    if (col == null) return;
    if (newQuantity <= 0) {
      await col.doc(docId).delete();
    } else {
      await col.doc(docId).update({'quantity': newQuantity});
    }
  }

  @override
  Future<void> deleteItem(String docId) async {
    final col = _quickListCollection;
    if (col == null) return;
    await col.doc(docId).delete();
  }

  @override
  Future<void> clearList() async {
    final col = _quickListCollection;
    if (col == null) return;
    final snapshot = await col.get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}
