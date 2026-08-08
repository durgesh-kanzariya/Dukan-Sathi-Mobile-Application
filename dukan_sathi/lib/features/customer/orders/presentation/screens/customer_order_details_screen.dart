import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../core/utils/constants.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_card.dart';
import '../../../../../core/widgets/app_confirmation_dialog.dart';
import '../../../../../core/widgets/app_snack_bar.dart';
import '../../../cart/domain/entities/cart_item_entity.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../domain/entities/customer_order_entity.dart';
import 'pickup_code_screen.dart';

class CustomerOrderDetailsScreen extends StatelessWidget {
  final CustomerOrderEntity order;

  const CustomerOrderDetailsScreen({super.key, required this.order});

  Widget _buildStatusChip(String status) {
    Color bgColor;
    Color textColor;
    String label;

    switch (status) {
      case 'pending':
        bgColor = AppColors.warningLight;
        textColor = AppColors.warning;
        label = 'Pending Acceptance';
        break;
      case 'accepted':
      case 'preparing':
        bgColor = AppColors.infoLight;
        textColor = AppColors.info;
        label = 'Preparing Order';
        break;
      case 'ready_for_pickup':
      case 'ready':
        bgColor = AppColors.successLight;
        textColor = AppColors.success;
        label = 'Ready for Pickup';
        break;
      case 'completed':
        bgColor = AppColors.surfaceVariant;
        textColor = AppColors.textSecondary;
        label = 'Completed';
        break;
      case 'rejected':
      case 'declined':
        bgColor = AppColors.errorLight;
        textColor = AppColors.error;
        label = 'Declined by Shop';
        break;
      case 'cancelled':
        bgColor = AppColors.errorLight;
        textColor = AppColors.error;
        label = 'Cancelled';
        break;
      default:
        bgColor = AppColors.surfaceVariant;
        textColor = AppColors.textPrimary;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Order Breakdown'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (order.isCancelled || order.isRejected) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.error.withValues(alpha: 0.25)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.cancel_rounded, color: AppColors.error, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.isRejected ? 'Pre-Order Declined by Shopkeeper' : 'Pre-Order Cancelled',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: AppColors.error,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            order.isRejected
                                ? 'The shopkeeper was unable to fulfill this order (e.g. items out of stock). No payment was charged.'
                                : 'This pre-order has been cancelled. You can tap "Re-Order All Items" below to select another shop.',
                            style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
            ],
            // Order Header Card
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Order #${order.id.substring(0, 8).toUpperCase()}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      _buildStatusChip(order.status),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Placed on ${AppFormatters.formatDateTime(order.createdAt)}',
                    style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: AppColors.divider),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.storefront_rounded, size: 18, color: AppColors.primaryEmerald),
                      const SizedBox(width: 6),
                      Text(
                        order.shopName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppColors.primaryEmerald,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Itemized List Header
            Text(
              'Purchased Items (${order.items.length})',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),

            // Items ListView Cards
            ...order.items.map((item) {
              return AppCard(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 50,
                        height: 50,
                        color: AppColors.surfaceVariant,
                        child: item.imageUrl.isNotEmpty
                            ? Image.network(item.imageUrl, fit: BoxFit.cover)
                            : const Icon(Icons.shopping_bag_outlined, color: AppColors.textMuted),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.productName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Variant: ${item.variant} • Qty: ${item.quantity}',
                            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      AppFormatters.formatCurrency(item.itemTotal),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.primaryEmerald,
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(top: BorderSide(color: AppColors.border)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Amount:',
                      style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
                    ),
                    Text(
                      AppFormatters.formatCurrency(order.totalPrice),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryEmerald,
                      ),
                    ),
                  ],
                ),
                if (order.isReadyForPickup) ...[
                  const SizedBox(height: 14),
                  AppButton(
                    text: 'Show Pickup Code & QR',
                    icon: Icons.qr_code_rounded,
                    type: AppButtonType.primary,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CustomerPickupCodeScreen(order: order),
                        ),
                      );
                    },
                  ),
                ] else if (order.isActive) ...[
                  const SizedBox(height: 14),
                  AppButton(
                    text: '🔒 QR & PIN Unlocks when Ready',
                    icon: Icons.lock_outline_rounded,
                    type: AppButtonType.outlined,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Shopkeeper is packing your items. Pickup QR & PIN will automatically unlock when Ready for Pickup!'),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    },
                  ),
                ],
                if (order.isActive || order.isReadyForPickup) ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      onPressed: () async {
                        final confirm = await AppConfirmationDialog.show(
                          context,
                          title: 'Cancel Pre-Order?',
                          message: 'Are you sure you want to cancel your pre-order with ${order.shopName}? This action cannot be undone.',
                          confirmLabel: 'Cancel Order',
                          icon: Icons.cancel_outlined,
                          iconColor: AppColors.error,
                          confirmButtonColor: AppColors.error,
                        );

                        if (confirm == true) {
                          try {
                            await FirebaseFirestore.instance
                                .collection(AppConstants.ordersCollection)
                                .doc(order.id)
                                .update({
                              'status': 'cancelled',
                              'cancelledAt': FieldValue.serverTimestamp(),
                              'cancelledBy': 'customer',
                            });

                            if (context.mounted) {
                              AppSnackBar.showSuccess(context, 'Pre-order cancelled successfully.');
                              Navigator.pop(context);
                            }
                          } catch (e) {
                            if (context.mounted) {
                              AppSnackBar.showError(context, 'Failed to cancel order: $e');
                            }
                          }
                        }
                      },
                      icon: const Icon(Icons.cancel_outlined, size: 16, color: AppColors.error),
                      label: Text(
                        'Cancel Pre-Order',
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ),
                ],
                if (!order.isActive && !order.isReadyForPickup) ...[
                  const SizedBox(height: 14),
                  Consumer(
                    builder: (context, ref, child) {
                      return AppButton(
                        text: 'Re-Order All Items',
                        icon: Icons.refresh_rounded,
                        type: AppButtonType.primary,
                        onPressed: () {
                          final cartNotifier = ref.read(cleanCartNotifierProvider.notifier);
                          for (var item in order.items) {
                            cartNotifier.addItem(
                              CartItemEntity(
                                productId: item.productId,
                                name: item.productName,
                                imageUrl: item.imageUrl,
                                shopId: order.shopId,
                                shopName: order.shopName,
                                variant: item.variant,
                                price: item.price,
                                quantity: item.quantity,
                              ),
                            );
                          }

                          AppSnackBar.showSuccess(
                            context,
                            'Successfully added ${order.items.length} items from ${order.shopName} to cart!',
                          );
                        },
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
