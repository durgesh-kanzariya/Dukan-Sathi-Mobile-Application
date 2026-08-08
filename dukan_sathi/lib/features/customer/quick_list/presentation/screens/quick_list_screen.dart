import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../core/utils/grocery_image_assets.dart';
import '../../../../../core/utils/pickup_slot_generator_util.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_card.dart';
import '../../../../../core/widgets/app_confirmation_dialog.dart';
import '../../../../../core/widgets/app_snack_bar.dart';
import '../../../../../core/widgets/shimmer_loading.dart';
import '../../../cart/domain/entities/cart_item_entity.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../domain/entities/quick_list_item_entity.dart';
import '../providers/quick_list_provider.dart';

class QuickListScreen extends ConsumerWidget {
  const QuickListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quickListAsync = ref.watch(quickListStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Quick Purchase List'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            tooltip: 'Clear Quick List',
            onPressed: () async {
              final confirm = await AppConfirmationDialog.show(
                context,
                title: 'Clear Quick List?',
                message: 'Are you sure you want to remove all saved items from your quick purchase list?',
                confirmLabel: 'Clear All',
                icon: Icons.delete_sweep_rounded,
                iconColor: AppColors.error,
                confirmButtonColor: AppColors.error,
              );

              if (confirm == true) {
                await ref.read(quickListNotifierProvider.notifier).clearQuickList();
              }
            },
          ),
        ],
      ),
      body: quickListAsync.when(
        data: (items) {
          if (items.isEmpty) {
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
                        Icons.bookmark_border_rounded,
                        size: 64,
                        color: AppColors.primaryEmerald,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Your Quick List is Empty',
                      style: GoogleFonts.outfit(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Save your daily milk, bread, and groceries from product pages to order them in 1-tap.',
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

          // Group items by shopId
          final Map<String, List<QuickListItemEntity>> grouped = {};
          final Map<String, String> shopNames = {};

          for (var item in items) {
            final sId = item.shopId.isNotEmpty ? item.shopId : 'default_shop';
            if (!grouped.containsKey(sId)) {
              grouped[sId] = [];
              shopNames[sId] = item.shopName.isNotEmpty ? item.shopName : 'Local Store';
            }
            grouped[sId]!.add(item);
          }

          final groupList = grouped.entries.map((entry) {
            return _ShopQuickListGroup(
              shopId: entry.key,
              shopName: shopNames[entry.key] ?? 'Local Store',
              items: entry.value,
            );
          }).toList();

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 130),
            itemCount: groupList.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final group = groupList[index];
              return _ShopQuickListGroupCard(group: group);
            },
          );
        },
        loading: () => const Padding(
          padding: EdgeInsets.all(20),
          child: ShimmerLoading(width: double.infinity, height: 200, borderRadius: 16),
        ),
        error: (err, _) => Center(child: Text('Error loading quick list: $err')),
      ),
      bottomSheet: quickListAsync.maybeWhen(
        data: (items) {
          if (items.isEmpty) return const SizedBox.shrink();

          final totalUnits = items.fold<int>(0, (sum, i) => sum + i.quantity);
          final totalListPrice = items.fold<double>(0.0, (sum, i) => sum + (i.price * i.quantity));

          return Container(
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
                        'Total ($totalUnits Units • ${items.length} Items)',
                        style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                      ),
                      Text(
                        Formatters.currency(totalListPrice),
                        style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primaryEmerald),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    text: 'Add All to Cart ($totalUnits Units) →',
                    icon: Icons.add_shopping_cart_rounded,
                    type: AppButtonType.primary,
                    height: 48,
                    onPressed: () {
                      final cartNotifier = ref.read(cleanCartNotifierProvider.notifier);
                      for (var qItem in items) {
                        cartNotifier.addItem(
                          CartItemEntity(
                            productId: qItem.productId,
                            name: qItem.productName,
                            imageUrl: qItem.imageUrl.isNotEmpty ? qItem.imageUrl : GroceryImageAssets.getFallbackForProduct(qItem.productName),
                            shopId: qItem.shopId,
                            shopName: qItem.shopName,
                            variant: qItem.variant,
                            price: qItem.price,
                            quantity: qItem.quantity,
                          ),
                        );
                      }

                      AppSnackBar.showSuccess(context, 'Added $totalUnits recurring items to cart!');
                    },
                  ),
                ],
              ),
            ),
          );
        },
        orElse: () => const SizedBox.shrink(),
      ),
    );
  }
}

class _ShopQuickListGroup {
  final String shopId;
  final String shopName;
  final List<QuickListItemEntity> items;

  _ShopQuickListGroup({
    required this.shopId,
    required this.shopName,
    required this.items,
  });

  double get subtotal => items.fold(0.0, (sum, i) => sum + (i.price * i.quantity));
}

class _ShopQuickListGroupCard extends ConsumerWidget {
  final _ShopQuickListGroup group;

  const _ShopQuickListGroupCard({required this.group});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDairy = group.shopName.toLowerCase().contains('dairy');
    final hours = isDairy ? ShopOperatingHours.defaultDairy() : ShopOperatingHours.defaultKirana();

    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shop Header & Subtotal with exact split shift hours summary
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
                            group.shopName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Store Hours: ${hours.formattedHoursSummary}',
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
                Formatters.currency(group.subtotal),
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.primaryEmerald,
                ),
              ),
            ],
          ),
          const Divider(height: 24),

          // Item List matching Cart Page exactly
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: group.items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, idx) {
              final item = group.items[idx];
              final docId = '${item.productId}_${item.variant.replaceAll(' ', '_')}';
              final imageUrl = item.imageUrl.isNotEmpty ? item.imageUrl : GroceryImageAssets.getFallbackForProduct(item.productName);

              return Dismissible(
                key: Key(docId),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.delete_outline, color: Colors.white, size: 22),
                ),
                onDismissed: (_) {
                  ref.read(quickListNotifierProvider.notifier).removeFromQuickList(docId);
                },
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        imageUrl,
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
                            item.productName,
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
                          onPressed: item.quantity > 1
                              ? () {
                                  ref.read(quickListNotifierProvider.notifier).updateQuantity(
                                        docId,
                                        item.quantity - 1,
                                      );
                                }
                              : null,
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
                            ref.read(quickListNotifierProvider.notifier).updateQuantity(
                                  docId,
                                  item.quantity + 1,
                                );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
