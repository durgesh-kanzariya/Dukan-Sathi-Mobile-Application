import '../entities/quick_list_item_entity.dart';

/// Contract interface for Quick Purchase List operations.
abstract class IQuickListRepository {
  Stream<List<QuickListItemEntity>> getQuickListStream();
  Future<void> addToQuickList(QuickListItemEntity item);
  Future<void> updateQuantity(String productId, int newQuantity);
  Future<void> deleteItem(String productId);
  Future<void> clearList();
}
