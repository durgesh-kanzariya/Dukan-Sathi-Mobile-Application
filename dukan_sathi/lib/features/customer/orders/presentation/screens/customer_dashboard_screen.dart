import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../core/utils/grocery_image_assets.dart';
import '../../../../../core/widgets/app_card.dart';
import '../../../../../core/widgets/app_snack_bar.dart';
import '../../../../../core/widgets/shimmer_loading.dart';
import '../../../../auth/presentation/providers/auth_notifier.dart';
import '../../../cart/domain/entities/cart_item_entity.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../domain/entities/customer_order_entity.dart';
import '../../../presentation/screens/customer_analytics_screen.dart';
import '../../../presentation/screens/customer_main_shell.dart';
import '../../../presentation/screens/customer_profile_screen.dart';
import '../../../quick_list/presentation/providers/quick_list_provider.dart';
import '../providers/customer_orders_provider.dart';
import 'customer_order_details_screen.dart';

class CleanCustomerDashboardScreen extends ConsumerWidget {
  const CleanCustomerDashboardScreen({super.key});

  String _formatDisplayName(String? name, String? email) {
    if (name != null && name.trim().isNotEmpty) {
      return name.trim();
    }
    if (email != null && email.trim().isNotEmpty) {
      return email.split('@').first;
    }
    return 'Valued Customer';
  }





  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;
    final activeOrdersAsync = ref.watch(activeOrdersStreamProvider);
    final spendingAsync = ref.watch(monthlySpendingStreamProvider);
    final quickListAsync = ref.watch(quickListStreamProvider);

    final displayName = _formatDisplayName(user?.name, user?.email);

    // Contextual Daily Essentials Carousel items for 1-Tap Quick Addition
    final List<Map<String, dynamic>> dailyEssentials = [
      {
        'id': 'ess_1',
        'name': 'Golden Whole Wheat (Aata)',
        'shop': 'Shree Ram Kirana Store',
        'variant': '5 kg',
        'price': 245.0,
        'image': GroceryImageAssets.wheatAtta,
      },
      {
        'id': 'ess_2',
        'name': 'Pure Organic Farm Milk',
        'shop': 'Amul Dairy Point',
        'variant': '1 Litre',
        'price': 64.0,
        'image': GroceryImageAssets.organicMilk,
      },
      {
        'id': 'ess_3',
        'name': 'Fresh Farm Eggs (12 pcs)',
        'shop': 'Fresh Farm Retail',
        'variant': '1 Dozen',
        'price': 84.0,
        'image': GroceryImageAssets.farmEggs,
      },
      {
        'id': 'ess_4',
        'name': 'Artisan Whole Wheat Bread',
        'shop': 'City Bakery & Confectionery',
        'variant': '400g',
        'price': 45.0,
        'image': GroceryImageAssets.artisanBread,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Emerald Gradient Hero Header
            Container(
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User Greeting & Interactive Profile Avatar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'WELCOME BACK 👋',
                                style: GoogleFonts.outfit(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.accentMint,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                displayName,
                                style: GoogleFonts.outfit(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const CustomerProfileScreen()),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.accentMint, width: 2),
                              ),
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white.withValues(alpha: 0.2),
                                child: Text(
                                  displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U',
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Interactive Monthly Spending Overview Card
                      spendingAsync.when(
                        data: (spending) => GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const CustomerAnalyticsScreen()),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 14,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: AppColors.primaryEmerald.withValues(alpha: 0.1),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                'THIS MONTH',
                                                style: GoogleFonts.inter(
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.primaryEmerald,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              Formatters.currency(spending['current'] ?? 0.0),
                                              style: GoogleFonts.outfit(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.textPrimary,
                                              ),
                                            ),
                                            Text(
                                              'August 2026',
                                              style: GoogleFonts.inter(
                                                fontSize: 10,
                                                color: AppColors.textMuted,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 36,
                                        width: 1,
                                        color: AppColors.border,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 14),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: AppColors.surfaceVariant,
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  'LAST MONTH',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.textSecondary,
                                                    letterSpacing: 0.5,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                Formatters.currency(spending['previous'] ?? 0.0),
                                                style: GoogleFonts.outfit(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.textSecondary,
                                                ),
                                              ),
                                              Text(
                                                'July 2026',
                                                style: GoogleFonts.inter(
                                                  fontSize: 10,
                                                  color: AppColors.textMuted,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryEmerald.withValues(alpha: 0.06),
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(16),
                                      bottomRight: Radius.circular(16),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.analytics_rounded, size: 14, color: AppColors.primaryEmerald),
                                          const SizedBox(width: 6),
                                          Text(
                                            'View Spending Analytics',
                                            style: GoogleFonts.outfit(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primaryEmerald,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(3),
                                        decoration: const BoxDecoration(
                                          color: AppColors.primaryEmerald,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 10),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        loading: () => const ShimmerLoading(width: double.infinity, height: 80, borderRadius: 20),
                        error: (_, __) => Text(
                          'Pre-order summary unavailable',
                          style: GoogleFonts.inter(color: Colors.white70, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Active Pre-Orders Live Status Timeline Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Active Pre-Orders',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      ref.read(customerTabNotifierProvider.notifier).setTab(4);
                    },
                    child: Text(
                      'View History',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryEmerald,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            activeOrdersAsync.when(
              data: (orders) {
                if (orders.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: AppCard(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primaryEmerald.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.shopping_bag_outlined, color: AppColors.primaryEmerald, size: 28),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'No Active Pre-Orders',
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Discover nearby local shops to pre-order groceries for instant pickup.',
                                  style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: List.generate(orders.length, (index) {
                      final order = orders[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: index < orders.length - 1 ? 12 : 0),
                        child: _ActiveOrderSummaryCard(order: order),
                      );
                    }),
                  ),
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ShimmerLoading(width: double.infinity, height: 100, borderRadius: 16),
              ),
              error: (err, _) => Center(child: Text('Error loading active orders: $err')),
            ),

            const SizedBox(height: 28),

            // 1-Tap Re-Order / Your Daily Essentials Carousel Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.flash_on_rounded, color: AppColors.warmAmber, size: 22),
                      const SizedBox(width: 6),
                      Text(
                        'Your Daily Essentials',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '1-Tap Add',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.warmAmberDark,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            SizedBox(
              height: 215,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: dailyEssentials.length,
                separatorBuilder: (_, __) => const SizedBox(width: 14),
                itemBuilder: (context, index) {
                  final item = dailyEssentials[index];
                  return SizedBox(
                    width: 160,
                    child: AppCard(
                      padding: EdgeInsets.zero,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            child: Image.network(
                              item['image'],
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['name'],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  '${item['variant']} • ${item['shop']}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      Formatters.currency(item['price']),
                                      style: GoogleFonts.outfit(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        ref.read(cleanCartNotifierProvider.notifier).addItem(
                                              CartItemEntity(
                                                productId: item['id'],
                                                name: item['name'],
                                                imageUrl: item['image'],
                                                shopId: 'shop_001',
                                                shopName: item['shop'],
                                                variant: item['variant'],
                                                price: item['price'],
                                                quantity: 1,
                                              ),
                                            );
                                        AppSnackBar.showSuccess(context, 'Added 1x ${item['name']} to cart!');
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primaryEmerald,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        minimumSize: Size.zero,
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        elevation: 0,
                                      ),
                                      child: Text(
                                        '+ ADD',
                                        style: GoogleFonts.outfit(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
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
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 28),

            // Quick Purchase List Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Quick Purchase List',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      ref.read(customerTabNotifierProvider.notifier).setTab(2);
                    },
                    child: Text(
                      'Manage List',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryEmerald,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            quickListAsync.when(
              data: (items) {
                if (items.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: AppCard(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primaryEmerald.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.bookmark_border_rounded, color: AppColors.primaryEmerald, size: 28),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Save Recurring Essentials',
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Save items like Milk & Bread to re-order in 1-tap.',
                                  style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final displayItems = items.take(3).toList();
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: List.generate(displayItems.length, (index) {
                      final item = displayItems[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: index < displayItems.length - 1 ? 10 : 0),
                        child: AppCard(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  item.imageUrl.isNotEmpty ? item.imageUrl : GroceryImageAssets.getFallbackForProduct(item.productName),
                                  width: 48,
                                  height: 48,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.productName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.outfit(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${item.variant} • ${Formatters.currency(item.price)}',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  ref.read(cleanCartNotifierProvider.notifier).addItem(
                                        CartItemEntity(
                                          productId: item.productId,
                                          name: item.productName,
                                          imageUrl: item.imageUrl.isNotEmpty ? item.imageUrl : GroceryImageAssets.getFallbackForProduct(item.productName),
                                          shopId: item.shopId,
                                          shopName: item.shopName,
                                          variant: item.variant,
                                          price: item.price,
                                          quantity: item.quantity,
                                        ),
                                      );
                                  AppSnackBar.showSuccess(context, 'Added ${item.productName} to cart!');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.accentMintLight,
                                  foregroundColor: AppColors.primaryEmerald,
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  elevation: 0,
                                ),
                                child: Text(
                                  '+ ADD',
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ShimmerLoading(width: double.infinity, height: 100, borderRadius: 16),
              ),
              error: (err, _) => Center(child: Text('Error loading quick list: $err')),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _ActiveOrderSummaryCard extends StatelessWidget {
  final CustomerOrderEntity order;

  const _ActiveOrderSummaryCard({required this.order});

  @override
  Widget build(BuildContext context) {
    int stepIndex = 0;
    String statusLabel = 'Sent to Shopkeeper';
    Color statusColor = AppColors.warmAmber;

    if (order.status == 'accepted' || order.status == 'preparing') {
      stepIndex = 1;
      statusLabel = 'Packing in Progress...';
      statusColor = AppColors.primaryEmerald;
    } else if (order.status == 'ready_for_pickup' || order.status == 'ready') {
      stepIndex = 2;
      statusLabel = 'READY FOR PICKUP!';
      statusColor = AppColors.primaryEmerald;
    } else if (order.status == 'completed') {
      stepIndex = 3;
      statusLabel = 'Completed';
      statusColor = AppColors.primaryEmerald;
    }

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  order.shopName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryEmerald.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  Formatters.currency(order.totalPrice),
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryEmerald,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Live Order Status Progress Timeline Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'LIVE PICKUP STATUS',
                    style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textMuted, letterSpacing: 0.8),
                  ),
                  Text(
                    statusLabel,
                    style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: List.generate(4, (i) {
                  final isDone = i <= stepIndex;
                  return Expanded(
                    child: Container(
                      height: 4,
                      margin: EdgeInsets.only(right: i < 3 ? 4 : 0),
                      decoration: BoxDecoration(
                        color: isDone ? AppColors.primaryEmerald : AppColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: order.isReadyForPickup ? AppColors.accentMintLight : AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      order.isReadyForPickup ? Icons.lock_open_rounded : Icons.lock_rounded,
                      size: 13,
                      color: order.isReadyForPickup ? AppColors.primaryEmerald : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      order.isReadyForPickup ? 'PIN: ${order.pickupCode}' : 'PIN: • • • •',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: order.isReadyForPickup ? AppColors.primaryEmerald : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CustomerOrderDetailsScreen(order: order)),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryEmerald,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.qr_code_rounded, size: 14, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(
                        'View Ticket',
                        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
