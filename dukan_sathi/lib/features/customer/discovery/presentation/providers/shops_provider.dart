import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/shop_entity.dart';
import '../../data/repositories/shop_repository_impl.dart';

class ShopSearchNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) => state = query;
}

/// Search Query State Provider for Discover Shops
final shopSearchQueryProvider = NotifierProvider<ShopSearchNotifier, String>(ShopSearchNotifier.new);

/// Stream Provider fetching all shops from Firestore
final shopsStreamProvider = StreamProvider<List<ShopEntity>>((ref) {
  final repo = ref.watch(shopRepositoryProvider);
  return repo.getShopsStream();
});

/// Filtered Shops Provider driven by search query
final filteredShopsProvider = Provider<AsyncValue<List<ShopEntity>>>((ref) {
  final shopsAsync = ref.watch(shopsStreamProvider);
  final query = ref.watch(shopSearchQueryProvider).trim().toLowerCase();

  return shopsAsync.whenData((shops) {
    if (query.isEmpty) return shops;
    return shops.where((shop) {
      final name = shop.shopName.toLowerCase();
      final address = shop.address.toLowerCase();
      final description = (shop.description ?? '').toLowerCase();
      return name.contains(query) || address.contains(query) || description.contains(query);
    }).toList();
  });
});
