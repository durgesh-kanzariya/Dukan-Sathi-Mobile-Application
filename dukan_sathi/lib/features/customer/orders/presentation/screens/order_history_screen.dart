import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../core/widgets/app_card.dart';
import '../../../../../core/widgets/shimmer_loading.dart';
import '../providers/customer_orders_provider.dart';
import 'customer_order_details_screen.dart';

class OrderHistoryScreen extends ConsumerWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completedOrdersAsync = ref.watch(orderHistoryStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Order History'),
        elevation: 0,
      ),
      body: completedOrdersAsync.when(
        data: (orders) {
          if (orders.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.primaryEmerald.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.receipt_long_outlined,
                        size: 64,
                        color: AppColors.primaryEmerald,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'No Past Orders Found',
                      style: GoogleFonts.outfit(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Completed pre-orders will appear here for easy re-ordering.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final order = orders[index];
              final isCancelled = order.isCancelled;
              final isRejected = order.isRejected;
              final isDeclinedOrCancelled = isCancelled || isRejected;

              final statusColor = isDeclinedOrCancelled ? AppColors.error : AppColors.success;
              final statusBgColor = isDeclinedOrCancelled ? AppColors.errorLight : AppColors.successLight;
              final statusLabel = isRejected
                  ? 'DECLINED'
                  : (isCancelled ? 'CANCELLED' : 'COMPLETED');

              return AppCard(
                padding: const EdgeInsets.all(18),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CustomerOrderDetailsScreen(order: order),
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
                          order.shopName,
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusBgColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            statusLabel,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${order.items.length} items • ${Formatters.currency(order.totalPrice)} • Placed on ${Formatters.date(order.createdAt)}',
                      style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary),
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'View Order Details',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryEmerald,
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 12,
                          color: AppColors.primaryEmerald,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Padding(
          padding: EdgeInsets.all(20),
          child: ShimmerLoading(width: double.infinity, height: 180, borderRadius: 16),
        ),
        error: (err, _) => Center(child: Text('Error loading history: $err')),
      ),
    );
  }
}
