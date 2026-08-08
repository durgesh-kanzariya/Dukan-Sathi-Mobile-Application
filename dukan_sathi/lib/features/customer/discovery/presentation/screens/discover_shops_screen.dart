import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../core/utils/grocery_image_assets.dart';
import '../../../../../core/utils/pickup_slot_generator_util.dart';
import '../../../../../core/utils/sample_data_seeder_util.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_card.dart';
import '../../../../../core/widgets/app_snack_bar.dart';
import '../../../../../core/widgets/shimmer_loading.dart';
import '../providers/shops_provider.dart';
import 'shop_products_screen.dart';

class DiscoverShopsScreen extends ConsumerStatefulWidget {
  const DiscoverShopsScreen({super.key});

  @override
  ConsumerState<DiscoverShopsScreen> createState() => _DiscoverShopsScreenState();
}

class _DiscoverShopsScreenState extends ConsumerState<DiscoverShopsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  bool _isFilterExpanded = false;
  bool _isSeeding = false;

  final List<String> _categories = [
    'All',
    'Kirana & Grains',
    'Dairy & Milk',
    'Organic & Farm',
    'Bakery & Toast',
    'General Store',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _seedSampleShops() async {
    setState(() {
      _isSeeding = true;
    });

    try {
      await SampleDataSeederUtil.seedSampleShopsAndProducts();
      if (!mounted) return;
      AppSnackBar.showSuccess(context, 'Generated sample local shops & products in Firestore!');
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.showError(context, 'Failed to generate shops: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isSeeding = false;
        });
      }
    }
  }

  Widget _buildCategoryPill(String category) {
    final isSelected = _selectedCategory == category;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = category;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.35),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            category,
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              color: isSelected ? AppColors.primaryEmerald : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final shopsAsync = ref.watch(shopsStreamProvider);
    final searchQuery = ref.watch(shopSearchQueryProvider);
    final hasActiveFilter = _selectedCategory != 'All';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Discover Local Shops'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_business_rounded),
            tooltip: 'Generate Sample Shops',
            onPressed: _seedSampleShops,
          ),
        ],
      ),
      body: Column(
        children: [
          // Sleek Header Container with Animated Expandable Category Bar
          Container(
            color: AppColors.primaryEmerald,
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
            child: Column(
              children: [
                // Compact Search Bar + Animated Filter Toggle Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 42,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (val) {
                              ref.read(shopSearchQueryProvider.notifier).state = val;
                            },
                            style: GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimary),
                            decoration: InputDecoration(
                              hintText: 'Search shops by name or location...',
                              hintStyle: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
                              prefixIcon: const Icon(Icons.search_rounded, size: 20, color: AppColors.textMuted),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear_rounded, size: 18, color: AppColors.textMuted),
                                      onPressed: () {
                                        _searchController.clear();
                                        ref.read(shopSearchQueryProvider.notifier).state = '';
                                      },
                                    )
                                  : null,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _isFilterExpanded = !_isFilterExpanded;
                          });
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          height: 42,
                          width: 42,
                          decoration: BoxDecoration(
                            color: (_isFilterExpanded || hasActiveFilter) ? Colors.white : Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: (_isFilterExpanded || hasActiveFilter) ? Colors.white : Colors.white.withValues(alpha: 0.35),
                            ),
                          ),
                          child: Icon(
                            _isFilterExpanded ? Icons.keyboard_arrow_up_rounded : Icons.tune_rounded,
                            color: (_isFilterExpanded || hasActiveFilter) ? AppColors.primaryEmerald : Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Smooth Drop-Down Animated Category Pills Bar
                AnimatedSize(
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.fastOutSlowIn,
                  child: _isFilterExpanded
                      ? Column(
                          children: [
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 34,
                              child: ListView.separated(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                scrollDirection: Axis.horizontal,
                                itemCount: _categories.length,
                                separatorBuilder: (_, __) => const SizedBox(width: 8),
                                itemBuilder: (context, index) {
                                  return _buildCategoryPill(_categories[index]);
                                },
                              ),
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),

          // Selected Active Filter Chip Bar (If Filtered & Bar Collapsed)
          if (hasActiveFilter && !_isFilterExpanded)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: AppColors.primaryEmerald.withValues(alpha: 0.08),
              child: Row(
                children: [
                  Text(
                    'Category Filter: ',
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textMuted),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primaryEmerald,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _selectedCategory,
                      style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = 'All';
                      });
                    },
                    child: const Text('Reset', style: TextStyle(fontSize: 11, color: AppColors.error, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),

          // Shop Directory List with Split-Shift Operating Hours
          Expanded(
            child: shopsAsync.when(
              data: (shops) {
                final filteredShops = shops.where((shop) {
                  final matchesQuery = searchQuery.isEmpty ||
                      shop.shopName.toLowerCase().contains(searchQuery.toLowerCase()) ||
                      shop.address.toLowerCase().contains(searchQuery.toLowerCase());

                  if (_selectedCategory == 'All') return matchesQuery;

                  final shopLower = shop.shopName.toLowerCase() + (shop.description ?? '').toLowerCase();
                  if (_selectedCategory == 'Kirana & Grains') {
                    return matchesQuery && (shopLower.contains('kirana') || shopLower.contains('grain') || shopLower.contains('aata'));
                  } else if (_selectedCategory == 'Dairy & Milk') {
                    return matchesQuery && (shopLower.contains('dairy') || shopLower.contains('milk'));
                  } else if (_selectedCategory == 'Bakery & Toast') {
                    return matchesQuery && (shopLower.contains('bakery') || shopLower.contains('bread'));
                  }
                  return matchesQuery;
                }).toList();

                if (filteredShops.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.storefront_outlined, size: 64, color: AppColors.textMuted),
                          const SizedBox(height: 16),
                          Text(
                            'No Local Shops Found',
                            style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Generate test shops to explore local grocery pre-ordering.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: 260,
                            child: AppButton(
                              text: 'Generate Sample Shops',
                              icon: Icons.add_business_rounded,
                              type: AppButtonType.primary,
                              isLoading: _isSeeding,
                              onPressed: _seedSampleShops,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredShops.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final shop = filteredShops[index];
                    final isDairy = shop.shopName.toLowerCase().contains('dairy');
                    final operatingHours = isDairy ? ShopOperatingHours.defaultDairy() : ShopOperatingHours.defaultKirana();

                    final imageUrl = (shop.imageUrl != null && shop.imageUrl!.isNotEmpty)
                        ? shop.imageUrl!
                        : GroceryImageAssets.getFallbackForShop(shop.shopName);

                    return AppCard(
                      padding: EdgeInsets.zero,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShopProductsScreen(shop: shop),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Shop Storefront Image with Open Badge & Distance Pill
                          Stack(
                            children: [
                              Container(
                                height: 140,
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                  color: AppColors.surfaceVariant,
                                ),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                  child: Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Image.network(
                                      GroceryImageAssets.getFallbackForShop(shop.shopName),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 12,
                                right: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: shop.isOpen ? AppColors.success : AppColors.error,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.15),
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    shop.isOpen ? 'OPEN NOW' : 'CLOSED',
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 12,
                                left: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.7),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.near_me_rounded, size: 12, color: AppColors.accentMint),
                                      const SizedBox(width: 4),
                                      Text(
                                        '0.8 km • 4.8 ★',
                                        style: GoogleFonts.inter(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Shop Information Body with Split Shift Operating Hours
                          Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  shop.shopName,
                                  style: GoogleFonts.outfit(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textMuted),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        shop.address,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.access_time_rounded, size: 14, color: AppColors.primaryEmerald),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        'Hours: ${operatingHours.formattedHoursSummary}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.inter(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.all(20),
                child: ShimmerLoading(width: double.infinity, height: 220, borderRadius: 16),
              ),
              error: (err, _) => Center(child: Text('Failed to load shops: $err')),
            ),
          ),
        ],
      ),
    );
  }
}
