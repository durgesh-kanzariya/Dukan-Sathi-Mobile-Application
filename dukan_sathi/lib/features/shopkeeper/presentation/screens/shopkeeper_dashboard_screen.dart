import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_confirmation_dialog.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/shimmer_loading.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';
import '../../domain/entities/shopkeeper_order_entity.dart';
import '../providers/shopkeeper_provider.dart';
import 'add_edit_product_screen.dart';
import 'manage_inventory_screen.dart';
import 'qr_scanner_screen.dart';
import 'shopkeeper_order_details_screen.dart';

class CleanShopkeeperDashboardScreen extends ConsumerStatefulWidget {
  const CleanShopkeeperDashboardScreen({super.key});

  @override
  ConsumerState<CleanShopkeeperDashboardScreen> createState() => _CleanShopkeeperDashboardScreenState();
}

class _CleanShopkeeperDashboardScreenState extends ConsumerState<CleanShopkeeperDashboardScreen> {
  String _selectedFilter = 'All';

  Future<void> _updateOrderStatus(String orderId, String newStatus, String successMsg) async {
    try {
      await FirebaseFirestore.instance
          .collection(AppConstants.ordersCollection)
          .doc(orderId)
          .update({'status': newStatus});

      if (mounted) {
        AppSnackBar.showSuccess(context, successMsg);
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.showError(context, 'Failed to update status: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;
    final analytics = ref.watch(shopkeeperAnalyticsProvider);
    final ordersAsync = ref.watch(shopkeeperOrdersStreamProvider);
    final productsAsync = ref.watch(shopkeeperProductsStreamProvider);

    int lowStockCount = 0;
    int totalProductsCount = 0;
    if (productsAsync.hasValue) {
      totalProductsCount = productsAsync.value!.length;
      lowStockCount = productsAsync.value!.where((p) => p.isLowStock || p.isOutOfStock).length;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Merchant Premium Hero Header
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0F2D24), Color(0xFF051B15)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 16,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    // Owner Row & Store Active Status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                color: AppColors.primaryEmerald.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.primaryEmerald, width: 1.5),
                              ),
                              child: const Icon(Icons.storefront_rounded, color: AppColors.primaryEmerald, size: 24),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user?.name ?? 'Shop Owner',
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF10B981).withValues(alpha: 0.25),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF34D399),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        'Accepting Orders',
                                        style: GoogleFonts.inter(
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
                          ],
                        ),
                        const SizedBox.shrink(),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Compact 1-Row Financial Overview
                    Row(
                      children: [
                        Expanded(
                          child: _KpiCard(
                            title: "TODAY'S REVENUE",
                            value: AppFormatters.formatCurrency(analytics.todayRevenue),
                            icon: Icons.payments_outlined,
                            accentColor: AppColors.primaryEmerald,
                            bgColor: Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _KpiCard(
                            title: "TODAY'S PROFIT",
                            value: AppFormatters.formatCurrency(analytics.todayProfit),
                            icon: Icons.trending_up_rounded,
                            accentColor: const Color(0xFF34D399),
                            bgColor: Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Compact Horizontal Status Strip
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _CompactStatBadge(
                            icon: Icons.pending_actions_rounded,
                            color: AppColors.warmAmber,
                            label: '${analytics.pendingOrdersCount} Pending',
                          ),
                          Container(width: 1, height: 16, color: Colors.white24),
                          _CompactStatBadge(
                            icon: Icons.qr_code_rounded,
                            color: AppColors.info,
                            label: '${analytics.readyForPickupCount} Ready',
                          ),
                          Container(width: 1, height: 16, color: Colors.white24),
                          _CompactStatBadge(
                            icon: Icons.warning_amber_rounded,
                            color: lowStockCount > 0 ? AppColors.error : Colors.white60,
                            label: '$lowStockCount Stock Alert',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

              // Quick Actions Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: _QuickActionButton(
                        label: 'Scan QR / PIN',
                        icon: Icons.qr_code_scanner_rounded,
                        color: AppColors.primaryEmerald,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const QRScannerScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _QuickActionButton(
                        label: 'Inventory ($totalProductsCount)',
                        icon: Icons.inventory_2_outlined,
                        color: lowStockCount > 0 ? AppColors.warning : AppColors.textPrimary,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ManageInventoryScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _QuickActionButton(
                        label: 'Add Product',
                        icon: Icons.add_box_rounded,
                        color: AppColors.accentMint,
                        textColor: AppColors.darkObsidian,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddEditProductScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Live Orders Queue Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Live Store Orders',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '${analytics.totalOrders} Total',
                      style: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Status Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: ['All', 'Pending', 'Preparing', 'Ready', 'Completed', 'Declined'].map((filter) {
                    final isSelected = _selectedFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(filter),
                        selected: isSelected,
                        selectedColor: AppColors.primaryEmerald,
                        backgroundColor: Colors.white,
                        labelStyle: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : AppColors.textSecondary,
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        side: BorderSide(
                          color: isSelected ? AppColors.primaryEmerald : AppColors.border,
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedFilter = filter;
                            });
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 14),

              // Order List Stream
              ordersAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: ShimmerLoading(width: double.infinity, height: 80),
                ),
                error: (err, s) => Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text('Error loading orders: $err'),
                ),
                data: (allOrders) {
                  // Filter orders according to selected tab
                  final filteredOrders = allOrders.where((order) {
                    if (_selectedFilter == 'All') return true;
                    if (_selectedFilter == 'Pending') return order.status == 'pending';
                    if (_selectedFilter == 'Preparing') return order.status == 'preparing' || order.status == 'accepted';
                    if (_selectedFilter == 'Ready') return order.status == 'ready_for_pickup' || order.status == 'ready';
                    if (_selectedFilter == 'Completed') return order.status == 'completed';
                    if (_selectedFilter == 'Declined') return order.status == 'rejected' || order.status == 'declined' || order.status == 'cancelled';
                    return true;
                  }).toList();

                  if (filteredOrders.isEmpty) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.inbox_outlined, size: 48, color: AppColors.textMuted),
                            const SizedBox(height: 12),
                            Text(
                              _selectedFilter == 'All' ? 'No incoming orders right now.' : 'No $_selectedFilter orders found.',
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = filteredOrders[index];
                      return _ShopkeeperOrderCard(
                        order: order,
                        onUpdateStatus: (newStatus, msg) => _updateOrderStatus(order.id, newStatus, msg),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      );
    }
}

class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color accentColor;
  final Color bgColor;

  const _KpiCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.accentColor,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: Colors.white70,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Icon(icon, color: accentColor, size: 18),
            ],
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactStatBadge extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;

  const _CompactStatBadge({
    required this.icon,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 5),
        Text(
          label,
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.label,
    required this.icon,
    required this.color,
    this.textColor = Colors.white,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: textColor, size: 22),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                color: textColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShopkeeperOrderCard extends StatelessWidget {
  final ShopkeeperOrderEntity order;
  final Function(String newStatus, String msg) onUpdateStatus;

  const _ShopkeeperOrderCard({
    required this.order,
    required this.onUpdateStatus,
  });

  @override
  Widget build(BuildContext context) {
    Color statusBgColor = AppColors.warningLight;
    Color statusTextColor = AppColors.warning;
    String statusLabel = 'Pending Approval';

    if (order.status == 'accepted' || order.status == 'preparing') {
      statusBgColor = AppColors.infoLight;
      statusTextColor = AppColors.info;
      statusLabel = 'Packing Items';
    } else if (order.status == 'ready_for_pickup' || order.status == 'ready') {
      statusBgColor = AppColors.successLight;
      statusTextColor = AppColors.success;
      statusLabel = 'Ready for Pickup';
    } else if (order.status == 'completed') {
      statusBgColor = AppColors.surfaceVariant;
      statusTextColor = AppColors.textSecondary;
      statusLabel = 'Completed';
    } else if (order.status == 'rejected' || order.status == 'declined' || order.status == 'cancelled') {
      statusBgColor = AppColors.errorLight;
      statusTextColor = AppColors.error;
      statusLabel = 'Declined/Cancelled';
    }

    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShopkeeperOrderDetailsScreen(order: order),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order #${order.id.substring(0, 8).toUpperCase()}',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  statusLabel,
                  style: GoogleFonts.inter(
                    color: statusTextColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.lock_outline_rounded, size: 14, color: AppColors.primaryEmerald),
                  const SizedBox(width: 4),
                  Text(
                    'PIN Verification Required',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: AppColors.primaryEmerald,
                    ),
                  ),
                ],
              ),
              Text(
                '${order.items.length} item(s) • ${Formatters.currency(order.totalPrice)}',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Action Row for direct 1-tap processing
          if (order.status == 'pending') ...[
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => onUpdateStatus('preparing', 'Order accepted! Start packing items.'),
                    icon: const Icon(Icons.check_circle_outline, size: 16, color: Colors.white),
                    label: Text(
                      'Accept & Pack',
                      style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryEmerald,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () async {
                    final confirm = await AppConfirmationDialog.show(
                      context,
                      title: 'Decline Order?',
                      message: 'Are you sure you want to decline this pre-order? The customer will be notified.',
                      confirmLabel: 'Decline Order',
                      icon: Icons.cancel_outlined,
                      iconColor: AppColors.error,
                      confirmButtonColor: AppColors.error,
                    );
                    if (confirm == true) {
                      onUpdateStatus('declined', 'Order declined.');
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    'Decline',
                    style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.error),
                  ),
                ),
              ],
            ),
          ] else if (order.status == 'accepted' || order.status == 'preparing') ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => onUpdateStatus('ready_for_pickup', 'Order marked Ready for Pickup!'),
                icon: const Icon(Icons.qr_code_rounded, size: 16, color: Colors.white),
                label: Text(
                  'Mark Ready for Pickup',
                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryEmerald,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
              ),
            ),
          ] else if (order.status == 'ready_for_pickup' || order.status == 'ready') ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QRScannerScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.qr_code_scanner_rounded, size: 16, color: Colors.white),
                label: Text(
                  'Verify PIN / Scan QR to Hand Over 🔒',
                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryEmerald,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
