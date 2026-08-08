import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/shimmer_loading.dart';
import '../../orders/domain/entities/customer_order_entity.dart';
import '../../orders/presentation/providers/customer_orders_provider.dart';

class CustomerAnalyticsScreen extends ConsumerStatefulWidget {
  const CustomerAnalyticsScreen({super.key});

  @override
  ConsumerState<CustomerAnalyticsScreen> createState() => _CustomerAnalyticsScreenState();
}

class _CustomerAnalyticsScreenState extends ConsumerState<CustomerAnalyticsScreen> {
  String _selectedFilter = '6 Months';

  final List<String> _monthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  List<Map<String, dynamic>> _buildMonthlyData(List<CustomerOrderEntity> orders, int monthCount) {
    final now = DateTime.now();
    final List<Map<String, dynamic>> result = [];

    for (int i = monthCount - 1; i >= 0; i--) {
      final targetDate = DateTime(now.year, now.month - i, 1);
      final monthStr = _monthNames[targetDate.month - 1];
      final yearStr = targetDate.year.toString();

      double sum = 0.0;
      int count = 0;

      for (var order in orders) {
        if (order.createdAt.month == targetDate.month && order.createdAt.year == targetDate.year) {
          sum += order.totalPrice;
          count++;
        }
      }

      result.add({
        'month': monthStr,
        'year': yearStr,
        'amount': sum,
        'orders': count,
        'isCurrent': i == 0,
      });
    }

    return result;
  }

  List<Map<String, dynamic>> _buildTopShopsData(List<CustomerOrderEntity> orders) {
    final Map<String, Map<String, dynamic>> shopMap = {};

    for (var order in orders) {
      if (!shopMap.containsKey(order.shopName)) {
        shopMap[order.shopName] = {
          'name': order.shopName,
          'orders': 0,
          'spent': 0.0,
        };
      }
      shopMap[order.shopName]!['orders'] = (shopMap[order.shopName]!['orders'] as int) + 1;
      shopMap[order.shopName]!['spent'] = (shopMap[order.shopName]!['spent'] as double) + order.totalPrice;
    }

    final list = shopMap.values.toList();
    list.sort((a, b) => (b['spent'] as double).compareTo(a['spent'] as double));
    return list;
  }

  List<Map<String, dynamic>> _buildCategoryData(List<CustomerOrderEntity> orders) {
    double kiranaTotal = 0.0;
    double dairyTotal = 0.0;
    double bakeryTotal = 0.0;

    for (var order in orders) {
      for (var item in order.items) {
        final nameLower = item.name.toLowerCase();
        final shopLower = order.shopName.toLowerCase();

        if (nameLower.contains('milk') || nameLower.contains('butter') || nameLower.contains('paneer') || nameLower.contains('curd') || shopLower.contains('dairy')) {
          dairyTotal += item.price * item.quantity;
        } else if (nameLower.contains('bread') || nameLower.contains('toast') || nameLower.contains('cake') || shopLower.contains('bakery')) {
          bakeryTotal += item.price * item.quantity;
        } else {
          kiranaTotal += item.price * item.quantity;
        }
      }
    }

    final grandTotal = kiranaTotal + dairyTotal + bakeryTotal;
    if (grandTotal == 0) {
      return [
        {'name': 'Kirana & Staples', 'amount': 0.0, 'percentage': 0, 'color': AppColors.primaryEmerald, 'icon': Icons.rice_bowl_rounded},
        {'name': 'Dairy & Milk', 'amount': 0.0, 'percentage': 0, 'color': AppColors.warmAmber, 'icon': Icons.water_drop_rounded},
        {'name': 'Bakery & Snacks', 'amount': 0.0, 'percentage': 0, 'color': Colors.deepOrangeAccent, 'icon': Icons.bakery_dining_rounded},
      ];
    }

    return [
      {
        'name': 'Kirana & Staples',
        'amount': kiranaTotal,
        'percentage': ((kiranaTotal / grandTotal) * 100).round(),
        'color': AppColors.primaryEmerald,
        'icon': Icons.rice_bowl_rounded
      },
      {
        'name': 'Dairy & Milk',
        'amount': dairyTotal,
        'percentage': ((dairyTotal / grandTotal) * 100).round(),
        'color': AppColors.warmAmber,
        'icon': Icons.water_drop_rounded
      },
      {
        'name': 'Bakery & Snacks',
        'amount': bakeryTotal,
        'percentage': ((bakeryTotal / grandTotal) * 100).round(),
        'color': Colors.deepOrangeAccent,
        'icon': Icons.bakery_dining_rounded
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final allOrdersAsync = ref.watch(allCustomerOrdersStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Spending Analytics'),
        elevation: 0,
      ),
      body: allOrdersAsync.when(
        data: (orders) {
          final int monthCount = _selectedFilter == '3 Months' ? 3 : (_selectedFilter == '6 Months' ? 6 : 12);
          final monthlyData = _buildMonthlyData(orders, monthCount);
          final topShops = _buildTopShopsData(orders);
          final categoryData = _buildCategoryData(orders);

          final totalSpent = orders.fold<double>(0, (sum, item) => sum + item.totalPrice);
          final totalOrders = orders.length;
          final avgOrderValue = totalOrders > 0 ? totalSpent / totalOrders : 0.0;
          final maxAmount = monthlyData.fold<double>(0, (max, item) => item['amount'] > max ? item['amount'] : max);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Filter Pills Row
                Row(
                  children: ['3 Months', '6 Months', 'All Time'].map((filter) {
                    final isSelected = _selectedFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(
                          filter,
                          style: GoogleFonts.outfit(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                            fontSize: 12,
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: AppColors.primaryEmerald,
                        backgroundColor: AppColors.surfaceVariant,
                        onSelected: (val) {
                          if (val) {
                            setState(() {
                              _selectedFilter = filter;
                            });
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                // Lifetime Overview Summary Cards Row
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryEmerald.withValues(alpha: 0.2),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'TOTAL SPENT',
                                  style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.accentMint, letterSpacing: 0.8),
                                ),
                                const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 18),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              Formatters.currency(totalSpent),
                              style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$totalOrders Completed Pre-Orders',
                              style: GoogleFonts.inter(fontSize: 11, color: Colors.white.withValues(alpha: 0.85)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.accentMintLight,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.primaryEmerald.withValues(alpha: 0.2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'AVG ORDER VALUE',
                                  style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primaryEmerald, letterSpacing: 0.8),
                                ),
                                const Icon(Icons.analytics_rounded, color: AppColors.primaryEmerald, size: 18),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              Formatters.currency(avgOrderValue),
                              style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primaryEmerald),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Per Pre-Order',
                              style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primaryEmerald),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Monthly Spending Visual Chart Section
                AppCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Monthly Order Breakdown',
                            style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                          Text(
                            _selectedFilter,
                            style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Bar Chart Visualizer
                      SizedBox(
                        height: 175,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: monthlyData.map((data) {
                            final double amt = data['amount'] as double;
                            final heightFactor = maxAmount > 0 ? amt / maxAmount : 0.0;
                            final isCurrentMonth = data['isCurrent'] == true;

                            return Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  Formatters.currency(amt),
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: isCurrentMonth ? AppColors.primaryEmerald : AppColors.textMuted,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: 24,
                                  height: (90 * heightFactor) + 12,
                                  decoration: BoxDecoration(
                                    color: isCurrentMonth ? AppColors.primaryEmerald : AppColors.primaryEmerald.withValues(alpha: 0.25),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  data['month'],
                                  style: GoogleFonts.outfit(
                                    fontSize: 12,
                                    fontWeight: isCurrentMonth ? FontWeight.bold : FontWeight.normal,
                                    color: isCurrentMonth ? AppColors.primaryEmerald : AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Spending By Category Progress Bars Section
                AppCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Spending by Grocery Category',
                        style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 16),

                      ...categoryData.map((cat) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(cat['icon'] as IconData, size: 18, color: cat['color'] as Color),
                                      const SizedBox(width: 8),
                                      Text(
                                        cat['name'],
                                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${Formatters.currency(cat['amount'])} (${cat['percentage']}%)',
                                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              LinearProgressIndicator(
                                value: ((cat['percentage'] as int) / 100).clamp(0.0, 1.0),
                                backgroundColor: (cat['color'] as Color).withValues(alpha: 0.12),
                                color: cat['color'] as Color,
                                minHeight: 6,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Top Favorite Stores Section
                AppCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Top Visited Local Stores',
                        style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 14),

                      topShops.isEmpty
                          ? Text('No completed orders yet.', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted))
                          : Column(
                              children: List.generate(topShops.length, (index) {
                                final shop = topShops[index];
                                return Column(
                                  children: [
                                    if (index > 0) const Divider(height: 20),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryEmerald.withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: const Icon(Icons.storefront_rounded, color: AppColors.primaryEmerald, size: 22),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                shop['name'],
                                                style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14),
                                              ),
                                              Text(
                                                '${shop['orders']} pre-orders fulfilled',
                                                style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          Formatters.currency(shop['spent']),
                                          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }),
                            ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
        loading: () => const Padding(
          padding: EdgeInsets.all(20),
          child: ShimmerLoading(width: double.infinity, height: 300, borderRadius: 20),
        ),
        error: (err, _) => Center(
          child: Text('Error loading analytics: $err', style: GoogleFonts.inter(color: AppColors.textMuted)),
        ),
      ),
    );
  }
}
