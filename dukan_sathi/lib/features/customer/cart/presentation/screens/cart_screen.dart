import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../core/utils/constants.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../core/utils/pickup_slot_generator_util.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_card.dart';
import '../../../../../core/widgets/app_confirmation_dialog.dart';
import '../../../../../core/widgets/app_snack_bar.dart';
import '../../domain/entities/shop_group_cart_entity.dart';
import '../providers/cart_provider.dart';

class CleanCartScreen extends ConsumerStatefulWidget {
  const CleanCartScreen({super.key});

  @override
  ConsumerState<CleanCartScreen> createState() => _CleanCartScreenState();
}

class _CleanShopGroupCardState extends ConsumerState<_ShopGroupCard> {
  late ShopOperatingHours _hours;
  late List<String> _shopSlots;
  late String _selectedSlot;

  @override
  void initState() {
    super.initState();
    final isDairy = widget.group.shopName.toLowerCase().contains('dairy');
    _hours = isDairy ? ShopOperatingHours.defaultDairy() : ShopOperatingHours.defaultKirana();
    _shopSlots = PickupSlotGeneratorUtil.generateAvailableSlots(hours: _hours);
    _selectedSlot = _shopSlots.first;
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shop Header & Subtotal Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryEmerald.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.storefront_rounded, color: AppColors.primaryEmerald, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.group.shopName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Store Hours: ${_hours.formattedHoursSummary}',
                            style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                Formatters.currency(widget.group.subtotal),
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.primaryEmerald,
                ),
              ),
            ],
          ),
          const Divider(height: 24),

          // Item List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.group.items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, idx) {
              final item = widget.group.items[idx];

              return Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      item.imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 50,
                        height: 50,
                        color: AppColors.surfaceVariant,
                        child: const Icon(Icons.shopping_bag_outlined, color: AppColors.textMuted, size: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${item.variant} • ${Formatters.currency(item.price)}',
                          style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline, size: 20),
                        color: AppColors.primaryEmerald,
                        onPressed: () async {
                          if (item.quantity == 1) {
                            final confirm = await AppConfirmationDialog.show(
                              context,
                              title: 'Remove Item?',
                              message: 'Are you sure you want to remove "${item.name}" from your cart?',
                              confirmLabel: 'Remove',
                              icon: Icons.delete_outline_rounded,
                              iconColor: AppColors.error,
                              confirmButtonColor: AppColors.error,
                            );
                            if (confirm != true) return;
                          }
                          ref.read(cleanCartNotifierProvider.notifier).updateQuantity(
                                item.productId,
                                item.variant,
                                item.quantity - 1,
                              );
                        },
                      ),
                      Text(
                        '${item.quantity}',
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline, size: 20),
                        color: AppColors.primaryEmerald,
                        onPressed: () {
                          ref.read(cleanCartNotifierProvider.notifier).updateQuantity(
                                item.productId,
                                item.variant,
                                item.quantity + 1,
                              );
                        },
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 14),

          // Dynamic Split-Shift Pickup Time Slot Selector Card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded, color: AppColors.primaryEmerald, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'SELECT 1-HOUR PICKUP WINDOW',
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedSlot,
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down_rounded, color: AppColors.primaryEmerald),
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    items: _shopSlots.map((slot) {
                      return DropdownMenuItem<String>(
                        value: slot,
                        child: Text(slot),
                      );
                    }).toList(),
                    onChanged: (newSlot) {
                      if (newSlot != null) {
                        setState(() {
                          _selectedSlot = newSlot;
                        });
                      }
                    },
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

class _ShopGroupCard extends ConsumerStatefulWidget {
  final ShopGroupCartEntity group;

  const _ShopGroupCard({required this.group});

  @override
  ConsumerState<_ShopGroupCard> createState() => _CleanShopGroupCardState();
}

class _CleanCartScreenState extends ConsumerState<CleanCartScreen> {
  bool _isCheckingOut = false;

  Future<void> _checkout() async {
    final groups = ref.read(groupedCartItemsProvider);
    if (groups.isEmpty) return;

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      AppSnackBar.showError(context, 'Please sign in to place pre-orders');
      return;
    }

    setState(() {
      _isCheckingOut = true;
    });

    try {
      final batch = FirebaseFirestore.instance.batch();
      final rng = Random();

      for (var group in groups) {
        final docRef = FirebaseFirestore.instance.collection(AppConstants.ordersCollection).doc();
        final pickupPin = (1000 + rng.nextInt(9000)).toString();

        final orderData = {
          'id': docRef.id,
          'customerId': uid,
          'shopId': group.shopId,
          'shopName': group.shopName,
          'status': 'pending',
          'totalPrice': group.subtotal,
          'createdAt': FieldValue.serverTimestamp(),
          'pickupCode': pickupPin,
          'items': group.items.map((item) => {
            'productId': item.productId,
            'productName': item.name,
            'name': item.name,
            'imageUrl': item.imageUrl,
            'price': item.price,
            'quantity': item.quantity,
            'variant': item.variant,
          }).toList(),
        };

        batch.set(docRef, orderData);
      }

      await batch.commit();
      ref.read(cleanCartNotifierProvider.notifier).clearCart();

      if (!mounted) return;

      AppSnackBar.showSuccess(context, 'Successfully reserved ${groups.length} store pre-order(s) for self-pickup!');
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.showError(context, 'Checkout failed: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isCheckingOut = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final groupedItems = ref.watch(groupedCartItemsProvider);
    final grandTotal = ref.watch(cartGrandTotalProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Shopping Cart'),
        elevation: 0,
        actions: [
          if (groupedItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded),
              tooltip: 'Clear Cart',
              onPressed: () async {
                final confirm = await AppConfirmationDialog.show(
                  context,
                  title: 'Clear Shopping Cart?',
                  message: 'Are you sure you want to remove all items from your cart across all shops?',
                  confirmLabel: 'Clear Cart',
                  icon: Icons.remove_shopping_cart_rounded,
                  iconColor: AppColors.error,
                  confirmButtonColor: AppColors.error,
                );
                if (confirm == true) {
                  ref.read(cleanCartNotifierProvider.notifier).clearCart();
                }
              },
            ),
        ],
      ),
      body: groupedItems.isEmpty
          ? Center(
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
                        Icons.shopping_cart_outlined,
                        size: 64,
                        color: AppColors.primaryEmerald,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Your Cart is Empty',
                      style: GoogleFonts.outfit(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Browse nearby local shops to add items for quick self-pickup.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 130),
              children: [
                ...groupedItems.map((group) => Padding(
                      padding: const EdgeInsets.only(bottom: 14.0),
                      child: _ShopGroupCard(group: group),
                    )),
              ],
            ),
      bottomSheet: groupedItems.isEmpty
          ? const SizedBox.shrink()
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Grand Total (${groupedItems.length} Store${groupedItems.length > 1 ? 's' : ''})',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          Formatters.currency(grandTotal),
                          style: GoogleFonts.outfit(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryEmerald,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    AppButton(
                      text: 'Confirm Pre-Orders (${groupedItems.length}) →',
                      icon: Icons.check_circle_outline_rounded,
                      type: AppButtonType.primary,
                      height: 48,
                      isLoading: _isCheckingOut,
                      onPressed: _checkout,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
