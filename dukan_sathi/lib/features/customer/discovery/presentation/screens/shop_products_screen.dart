import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_card.dart';
import '../../../../../core/widgets/app_snack_bar.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../../../../../core/widgets/shimmer_loading.dart';
import '../../../quick_list/presentation/providers/quick_list_provider.dart';
import '../../../quick_list/domain/entities/quick_list_item_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/entities/shop_entity.dart';
import '../providers/shop_products_provider.dart';
import 'product_detail_screen.dart';

class ShopProductsScreen extends ConsumerStatefulWidget {
  final ShopEntity shop;

  const ShopProductsScreen({super.key, required this.shop});

  @override
  ConsumerState<ShopProductsScreen> createState() => _ShopProductsScreenState();
}

class _ShopProductsScreenState extends ConsumerState<ShopProductsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(filteredShopProductsProvider(widget.shop.id));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Shop Banner & Header SliverAppBar
          SliverAppBar(
            expandedHeight: 160.0,
            pinned: true,
            backgroundColor: AppColors.primaryEmerald,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.shop.shopName,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  (widget.shop.imageUrl != null && widget.shop.imageUrl!.isNotEmpty)
                      ? Image.network(widget.shop.imageUrl!, fit: BoxFit.cover)
                      : Container(color: AppColors.primaryEmeraldLight),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Search Bar Sliver
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: AppTextField(
                controller: _searchController,
                hintText: 'Search in ${widget.shop.shopName}...',
                prefixIcon: const Icon(Icons.search_rounded),
                onChanged: (val) {
                  ref.read(productSearchQueryProvider.notifier).state = val;
                },
              ),
            ),
          ),

          // Product Grid View
          productsAsync.when(
            data: (products) {
              if (products.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.inventory_2_outlined, size: 48, color: AppColors.textMuted),
                        const SizedBox(height: 12),
                        Text(
                          'No products found',
                          style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.76,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = products[index];
                      return _ProductGridCard(product: product, shop: widget.shop);
                    },
                    childCount: products.length,
                  ),
                ),
              );
            },
            loading: () => const SliverFillRemaining(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: ShimmerLoading(width: double.infinity, height: 180, borderRadius: 14),
              ),
            ),
            error: (err, _) => SliverFillRemaining(
              child: Center(child: Text('Error loading catalog: $err')),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

class _ProductGridCard extends ConsumerWidget {
  final ProductEntity product;
  final ShopEntity shop;

  const _ProductGridCard({
    required this.product,
    required this.shop,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstVariant = product.variants.isNotEmpty ? product.variants.first : null;
    final displayPrice = firstVariant?.sellPrice ?? 0.0;

    return AppCard(
      padding: EdgeInsets.zero,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product, shopName: shop.shopName),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Container with 1-Tap Quick List Bookmark Action
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(14),
                    topRight: Radius.circular(14),
                  ),
                  child: product.imageUrl.isNotEmpty
                      ? Image.network(product.imageUrl, fit: BoxFit.cover)
                      : Container(
                          color: AppColors.surfaceVariant,
                          child: const Icon(Icons.shopping_bag_outlined, color: AppColors.textMuted),
                        ),
                ),

                // 1-Tap Quick List Bookmark Icon Button
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () async {
                      final item = QuickListItemEntity(
                        productId: product.id,
                        productName: product.productName,
                        imageUrl: product.imageUrl,
                        shopId: shop.id,
                        shopName: shop.shopName,
                        variant: firstVariant?.name ?? 'Standard',
                        price: firstVariant?.sellPrice ?? 0.0,
                        quantity: 1,
                        addedAt: DateTime.now(),
                      );
                      await ref.read(quickListNotifierProvider.notifier).addToQuickList(item);

                      if (context.mounted) {
                        AppSnackBar.showSuccess(context, 'Saved 📌 ${product.productName} to Quick List!');
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.bookmark_add_rounded,
                        size: 16,
                        color: AppColors.primaryEmerald,
                      ),
                    ),
                  ),
                ),

                if (product.isSoldOut)
                  Container(
                    color: Colors.black.withValues(alpha: 0.5),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'SOLD OUT',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Compact Modern Product Details
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.productName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '${product.variants.length} Variant${product.variants.length > 1 ? 's' : ''}',
                  style: GoogleFonts.inter(fontSize: 10, color: AppColors.textMuted),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Formatters.currency(displayPrice),
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: AppColors.primaryEmerald,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryEmerald,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add, color: Colors.white, size: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
