import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_confirmation_dialog.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../data/repositories/shopkeeper_repository_impl.dart';
import '../../domain/entities/shopkeeper_order_entity.dart';
import 'qr_scanner_screen.dart';

class ShopkeeperOrderDetailsScreen extends ConsumerStatefulWidget {
  final ShopkeeperOrderEntity order;

  const ShopkeeperOrderDetailsScreen({super.key, required this.order});

  @override
  ConsumerState<ShopkeeperOrderDetailsScreen> createState() => _ShopkeeperOrderDetailsScreenState();
}

class _ShopkeeperOrderDetailsScreenState extends ConsumerState<ShopkeeperOrderDetailsScreen> {
  bool _isUpdating = false;
  final Set<String> _packedItems = {};

  Future<void> _updateStatus(String newStatus, String msg) async {
    setState(() {
      _isUpdating = true;
    });

    try {
      final repo = ref.read(shopkeeperRepositoryProvider);
      await repo.updateOrderStatus(widget.order.id, newStatus);

      if (!mounted) return;
      AppSnackBar.showSuccess(context, msg);
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.showError(context, 'Failed to update status: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;

    String statusLabel = 'Pending Acceptance';
    Color statusBgColor = AppColors.warningLight;
    Color statusTextColor = AppColors.warning;

    if (order.isPreparing) {
      statusLabel = 'Packing in Progress';
      statusBgColor = AppColors.infoLight;
      statusTextColor = AppColors.info;
    } else if (order.isReady) {
      statusLabel = 'Ready for Pickup';
      statusBgColor = AppColors.successLight;
      statusTextColor = AppColors.success;
    } else if (order.isCompleted) {
      statusLabel = 'Completed';
      statusBgColor = AppColors.surfaceVariant;
      statusTextColor = AppColors.textSecondary;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Order #${order.id.substring(0, 8).toUpperCase()}',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Status & Pickup PIN Hero Card
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pickup PIN Code',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textMuted,
                          letterSpacing: 0.5,
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
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.accentMintLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.shield_outlined, color: AppColors.primaryEmerald, size: 22),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Customer Verification Required',
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryEmerald,
                                ),
                              ),
                              Text(
                                'Ask customer for secret 4-digit PIN or scan QR upon pickup.',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: AppColors.divider),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time_rounded, size: 14, color: AppColors.textMuted),
                      const SizedBox(width: 6),
                      Text(
                        'Placed on ${AppFormatters.formatDateTime(order.createdAt)}',
                        style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Itemized Packing Checklist Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Packing Checklist (${_packedItems.length}/${order.items.length})',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Tap item to check off',
                  style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted),
                ),
              ],
            ),
            const SizedBox(height: 10),

            ...order.items.map((item) {
              final isChecked = _packedItems.contains(item.productId);

              return AppCard(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                onTap: () {
                  setState(() {
                    if (isChecked) {
                      _packedItems.remove(item.productId);
                    } else {
                      _packedItems.add(item.productId);
                    }
                  });
                },
                child: Row(
                  children: [
                    Checkbox(
                      value: isChecked,
                      activeColor: AppColors.primaryEmerald,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      onChanged: (val) {
                        setState(() {
                          if (val == true) {
                            _packedItems.add(item.productId);
                          } else {
                            _packedItems.remove(item.productId);
                          }
                        });
                      },
                    ),
                    const SizedBox(width: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 46,
                        height: 46,
                        color: AppColors.surfaceVariant,
                        child: item.imageUrl.isNotEmpty
                            ? Image.network(item.imageUrl, fit: BoxFit.cover)
                            : const Icon(Icons.shopping_bag_outlined, color: AppColors.textMuted, size: 20),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.productName,
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              decoration: isChecked ? TextDecoration.lineThrough : null,
                              color: isChecked ? AppColors.textMuted : AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Variant: ${item.variant} • Qty: ${item.quantity}',
                            style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      AppFormatters.formatCurrency(item.itemTotal),
                      style: GoogleFonts.outfit(
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
                    Text(
                      'Total Order Value:',
                      style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary),
                    ),
                    Text(
                      AppFormatters.formatCurrency(order.totalPrice),
                      style: GoogleFonts.outfit(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryEmerald,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                if (order.isPending) ...[
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            final confirm = await AppConfirmationDialog.show(
                              context,
                              title: 'Decline Order?',
                              message: 'Are you sure you want to decline this pre-order?',
                              confirmLabel: 'Decline',
                              icon: Icons.cancel_outlined,
                              iconColor: AppColors.error,
                              confirmButtonColor: AppColors.error,
                            );
                            if (confirm == true) {
                              _updateStatus(AppConstants.statusCancelled, 'Order declined.');
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.error,
                            side: const BorderSide(color: AppColors.error),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          child: Text(
                            'Decline',
                            style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.error),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: AppButton(
                          text: 'Accept & Start Packing',
                          icon: Icons.check_circle_outline,
                          type: AppButtonType.primary,
                          isLoading: _isUpdating,
                          onPressed: () => _updateStatus(AppConstants.statusPreparing, 'Order accepted! Start packing items.'),
                        ),
                      ),
                    ],
                  ),
                ] else if (order.isPreparing) ...[
                  AppButton(
                    text: 'Mark Ready for Pickup',
                    icon: Icons.check_circle_rounded,
                    type: AppButtonType.primary,
                    isLoading: _isUpdating,
                    onPressed: () => _updateStatus(AppConstants.statusReadyForPickup, 'Order marked Ready for Pickup!'),
                  ),
                ] else if (order.isReady) ...[
                  AppButton(
                    text: 'Verify PIN / Scan QR to Hand Over 🔒',
                    icon: Icons.qr_code_scanner_rounded,
                    type: AppButtonType.primary,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const QRScannerScreen(),
                        ),
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
