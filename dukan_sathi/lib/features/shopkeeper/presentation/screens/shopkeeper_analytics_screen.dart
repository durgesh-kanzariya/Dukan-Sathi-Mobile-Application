import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../providers/shopkeeper_provider.dart';

class ShopkeeperAnalyticsScreen extends ConsumerWidget {
  const ShopkeeperAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = ref.watch(shopkeeperAnalyticsProvider);
    final productsAsync = ref.watch(shopkeeperProductsStreamProvider);
    final ordersAsync = ref.watch(shopkeeperOrdersStreamProvider);

    final products = productsAsync.asData?.value ?? [];
    final orders = ordersAsync.asData?.value ?? [];

    final lowStockCount = products.where((p) => p.isLowStock || p.isOutOfStock).length;
    final totalProducts = products.length;

    // Calculate Completed vs Pending vs Cancelled
    final completedCount = orders.where((o) => o.isCompleted).length;
    final pendingCount = orders.where((o) => o.isPending).length;
    final readyCount = orders.where((o) => o.isReady).length;
    final cancelledCount = orders.where((o) => o.isCancelled).length;

    final avgOrderValue = analytics.totalOrders > 0
        ? analytics.todayRevenue / analytics.totalOrders
        : 0.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Business Analytics',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dark Emerald Financial Performance Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF064E3B), Color(0xFF042F2E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryEmerald.withValues(alpha: 0.2),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
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
                        'Financial Performance',
                        style: GoogleFonts.inter(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF34D399).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.show_chart_rounded, color: Color(0xFF34D399), size: 14),
                            const SizedBox(width: 4),
                            Text(
                              'Live Analytics',
                              style: GoogleFonts.outfit(
                                color: const Color(0xFF34D399),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Today's Revenue",
                              style: GoogleFonts.inter(fontSize: 12, color: Colors.white60),
                            ),
                            const SizedBox(height: 4),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                AppFormatters.formatCurrency(analytics.todayRevenue),
                                style: GoogleFonts.outfit(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(width: 1, height: 40, color: Colors.white24),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Today's Profit",
                              style: GoogleFonts.inter(fontSize: 12, color: Colors.white60),
                            ),
                            const SizedBox(height: 4),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                AppFormatters.formatCurrency(analytics.todayProfit),
                                style: GoogleFonts.outfit(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF34D399),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Secondary KPI Metrics Grid
            Row(
              children: [
                Expanded(
                  child: _AnalyticsMetricCard(
                    title: 'Total Orders',
                    value: '${analytics.totalOrders}',
                    icon: Icons.shopping_bag_outlined,
                    color: AppColors.primaryEmerald,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _AnalyticsMetricCard(
                    title: 'Avg Order Value',
                    value: AppFormatters.formatCurrency(avgOrderValue),
                    icon: Icons.receipt_long_rounded,
                    color: AppColors.info,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _AnalyticsMetricCard(
                    title: 'Pending Action',
                    value: '$pendingCount',
                    icon: Icons.pending_actions_rounded,
                    color: AppColors.warmAmber,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _AnalyticsMetricCard(
                    title: 'Ready Pickup',
                    value: '$readyCount',
                    icon: Icons.qr_code_rounded,
                    color: AppColors.info,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Order Status Breakdown Card
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Status Breakdown',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _StatusProgressRow(
                    label: 'Completed Orders',
                    count: completedCount,
                    total: orders.isEmpty ? 1 : orders.length,
                    color: AppColors.success,
                  ),
                  const SizedBox(height: 12),
                  _StatusProgressRow(
                    label: 'Ready for Pickup',
                    count: readyCount,
                    total: orders.isEmpty ? 1 : orders.length,
                    color: AppColors.info,
                  ),
                  const SizedBox(height: 12),
                  _StatusProgressRow(
                    label: 'Pending Action',
                    count: pendingCount,
                    total: orders.isEmpty ? 1 : orders.length,
                    color: AppColors.warmAmber,
                  ),
                  const SizedBox(height: 12),
                  _StatusProgressRow(
                    label: 'Cancelled Orders',
                    count: cancelledCount,
                    total: orders.isEmpty ? 1 : orders.length,
                    color: AppColors.error,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Inventory & Catalog Health Card
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Inventory Stock Health',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: lowStockCount > 0 ? AppColors.errorLight : AppColors.successLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          lowStockCount > 0 ? '$lowStockCount Stock Alerts' : 'Healthy Stock',
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: lowStockCount > 0 ? AppColors.error : AppColors.success,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _InventoryStatBox(
                          label: 'Total Products',
                          value: '$totalProducts Items',
                          icon: Icons.inventory_2_outlined,
                          color: AppColors.primaryEmerald,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _InventoryStatBox(
                          label: 'Low / Out of Stock',
                          value: '$lowStockCount Items',
                          icon: Icons.warning_amber_rounded,
                          color: lowStockCount > 0 ? AppColors.error : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _AnalyticsMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _AnalyticsMetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusProgressRow extends StatelessWidget {
  final String label;
  final int count;
  final int total;
  final Color color;

  const _StatusProgressRow({
    required this.label,
    required this.count,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? count / total : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
            Text(
              '$count orders (${(pct * 100).toStringAsFixed(0)}%)',
              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: pct,
            backgroundColor: AppColors.surfaceVariant,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}

class _InventoryStatBox extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _InventoryStatBox({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}
