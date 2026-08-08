import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/quick_list_item_entity.dart';
import '../../data/repositories/quick_list_repository_impl.dart';

class QuickListNotifier extends Notifier<void> {
  @override
  void build() {}

  Future<void> addToQuickList(QuickListItemEntity item) async {
    final repo = ref.read(quickListRepositoryProvider);
    await repo.addToQuickList(item);
  }

  Future<void> removeFromQuickList(String productId) async {
    final repo = ref.read(quickListRepositoryProvider);
    await repo.deleteItem(productId);
  }

  Future<void> updateQuantity(String productId, int newQuantity) async {
    final repo = ref.read(quickListRepositoryProvider);
    await repo.updateQuantity(productId, newQuantity);
  }

  Future<void> clearQuickList() async {
    final repo = ref.read(quickListRepositoryProvider);
    await repo.clearList();
  }
}

final quickListNotifierProvider = NotifierProvider<QuickListNotifier, void>(QuickListNotifier.new);

/// Stream Provider fetching saved Quick Purchase List items for the active user
final quickListStreamProvider = StreamProvider<List<QuickListItemEntity>>((ref) {
  final repo = ref.watch(quickListRepositoryProvider);
  return repo.getQuickListStream();
});
