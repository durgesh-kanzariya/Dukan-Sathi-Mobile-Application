import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/product_entity.dart';
import '../../data/repositories/shop_repository_impl.dart';

class ProductSearchNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) => state = query;
}

/// Search Query State Provider for shop-specific products
final productSearchQueryProvider = NotifierProvider<ProductSearchNotifier, String>(ProductSearchNotifier.new);

/// Stream Provider fetching products for a specific shop ID
final shopProductsStreamProvider =
    StreamProvider.family<List<ProductEntity>, String>((ref, shopId) {
  final repo = ref.watch(shopRepositoryProvider);
  return repo.getShopProductsStream(shopId);
});

/// Filtered products for a specific shop ID
final filteredShopProductsProvider =
    Provider.family<AsyncValue<List<ProductEntity>>, String>((ref, shopId) {
  final productsAsync = ref.watch(shopProductsStreamProvider(shopId));
  final query = ref.watch(productSearchQueryProvider).trim().toLowerCase();

  return productsAsync.whenData((products) {
    if (query.isEmpty) return products;
    return products.where((product) {
      final name = product.productName.toLowerCase();
      final desc = product.description.toLowerCase();
      return name.contains(query) || desc.contains(query);
    }).toList();
  });
});
