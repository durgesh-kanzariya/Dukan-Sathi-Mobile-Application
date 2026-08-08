import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_confirmation_dialog.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/shimmer_loading.dart';
import '../../data/repositories/shopkeeper_repository_impl.dart';
import '../../domain/entities/inventory_product_entity.dart';
import '../providers/shopkeeper_provider.dart';
import 'add_edit_product_screen.dart';

class ManageInventoryScreen extends ConsumerStatefulWidget {
  const ManageInventoryScreen({super.key});

  @override
  ConsumerState<ManageInventoryScreen> createState() => _ManageInventoryScreenState();
}

class _ManageInventoryScreenState extends ConsumerState<ManageInventoryScreen> {
  String _searchQuery = '';
  String _stockFilter = 'All';

  Widget _buildStockBadge(InventoryProductEntity product) {
    if (product.isOutOfStock) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.errorLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'OUT OF STOCK',
          style: GoogleFonts.inter(color: AppColors.error, fontSize: 10, fontWeight: FontWeight.bold),
        ),
      );
    } else if (product.isLowStock) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.warningLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'LOW STOCK (${product.totalStock})',
          style: GoogleFonts.inter(color: AppColors.warning, fontSize: 10, fontWeight: FontWeight.bold),
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.successLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'IN STOCK (${product.totalStock})',
          style: GoogleFonts.inter(color: AppColors.success, fontSize: 10, fontWeight: FontWeight.bold),
        ),
      );
    }
  }

  Future<void> _deleteProduct(BuildContext context, String shopId, String productId, String productName) async {
    final confirm = await AppConfirmationDialog.show(
      context,
      title: 'Delete Product?',
      message: 'Are you sure you want to remove "$productName" and all its variants from your shop catalog?',
      confirmLabel: 'Delete',
      icon: Icons.delete_outline_rounded,
      iconColor: AppColors.error,
      confirmButtonColor: AppColors.error,
    );

    if (confirm == true && mounted) {
      await ref.read(shopkeeperRepositoryProvider).deleteProduct(shopId, productId);
      if (context.mounted) {
        AppSnackBar.showError(context, 'Product deleted.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(shopkeeperProductsStreamProvider);
    final shopId = ref.watch(activeShopIdProvider).asData?.value;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Manage Inventory',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditProductScreen(),
            ),
          );
        },
        backgroundColor: AppColors.primaryEmerald,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(
          'Add Product',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          // Search & Filter Header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
            color: Colors.white,
            child: Column(
              children: [
                // Search Input Box
                TextField(
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val.toLowerCase().trim();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search products by name or category...',
                    hintStyle: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted),
                    prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primaryEmerald),
                    filled: true,
                    fillColor: AppColors.surfaceVariant,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Stock Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['All', 'In Stock', 'Low Stock', 'Out of Stock'].map((filter) {
                      final isSelected = _stockFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(filter),
                          selected: isSelected,
                          selectedColor: AppColors.primaryEmerald,
                          backgroundColor: AppColors.surfaceVariant,
                          labelStyle: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : AppColors.textSecondary,
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          side: BorderSide.none,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _stockFilter = filter;
                              });
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),

          // Product List
          Expanded(
            child: productsAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(16.0),
                child: ShimmerLoading(width: double.infinity, height: 80),
              ),
              error: (err, s) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text('Error loading inventory: $err'),
                ),
              ),
              data: (allProducts) {
                final filteredProducts = allProducts.where((product) {
                  final matchesSearch = _searchQuery.isEmpty ||
                      product.productName.toLowerCase().contains(_searchQuery) ||
                      product.category.toLowerCase().contains(_searchQuery);

                  if (!matchesSearch) return false;

                  if (_stockFilter == 'In Stock') return !product.isOutOfStock;
                  if (_stockFilter == 'Low Stock') return product.isLowStock;
                  if (_stockFilter == 'Out of Stock') return product.isOutOfStock;
                  return true;
                }).toList();

                if (filteredProducts.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 56,
                            color: AppColors.textMuted,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No Products Found',
                            style: GoogleFonts.outfit(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap "+ Add Product" to add grocery items to your inventory.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 85),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];

                    return AppCard(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  width: 54,
                                  height: 54,
                                  color: AppColors.surfaceVariant,
                                  child: product.imageUrl.isNotEmpty
                                      ? Image.network(product.imageUrl, fit: BoxFit.cover)
                                      : const Icon(Icons.shopping_bag_outlined, color: AppColors.textMuted, size: 22),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            product.productName,
                                            style: GoogleFonts.outfit(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: AppColors.textPrimary,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        _buildStockBadge(product),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${product.category} • ${product.variants.length} Variant(s)',
                                      style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      Formatters.currency(product.minPrice),
                                      style: GoogleFonts.outfit(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: AppColors.primaryEmerald,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 20),

                          // Card Action Row: Edit & Delete
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddEditProductScreen(productToEdit: product),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.edit_outlined, size: 14, color: AppColors.primaryEmerald),
                                label: Text(
                                  'Edit Details',
                                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryEmerald),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: AppColors.primaryEmerald),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 20),
                                tooltip: 'Delete Product',
                                onPressed: () {
                                  if (shopId != null) {
                                    _deleteProduct(context, shopId, product.id, product.productName);
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
