import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_snack_bar.dart';
import '../../../cart/domain/entities/cart_item_entity.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../quick_list/presentation/providers/quick_list_provider.dart';
import '../../../quick_list/domain/entities/quick_list_item_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/entities/product_variant_entity.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final ProductEntity product;
  final String shopName;

  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.shopName,
  });

  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  late ProductVariantEntity _selectedVariant;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _selectedVariant = widget.product.variants.firstWhere(
      (v) => v.stock > 0,
      orElse: () => widget.product.variants.first,
    );
  }

  void _addToCart() {
    final cartItem = CartItemEntity(
      productId: widget.product.id,
      name: widget.product.productName,
      imageUrl: widget.product.imageUrl,
      shopId: widget.product.shopId,
      shopName: widget.shopName,
      variant: _selectedVariant.name,
      price: _selectedVariant.sellPrice,
      quantity: _quantity,
    );

    ref.read(cleanCartNotifierProvider.notifier).addItem(cartItem);

    AppSnackBar.showSuccess(context, 'Added ${_quantity}x ${widget.product.productName} (${_selectedVariant.name}) to cart!');
  }

  Future<void> _addToQuickList() async {
    final quickListItem = QuickListItemEntity(
      productId: widget.product.id,
      productName: widget.product.productName,
      imageUrl: widget.product.imageUrl,
      shopId: widget.product.shopId,
      shopName: widget.shopName,
      variant: _selectedVariant.name,
      price: _selectedVariant.sellPrice,
      quantity: _quantity,
      addedAt: DateTime.now(),
    );

    await ref.read(quickListNotifierProvider.notifier).addToQuickList(quickListItem);

    if (mounted) {
      AppSnackBar.showSuccess(context, 'Saved 📌 ${widget.product.productName} (${_selectedVariant.name}) to Quick Purchase List!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayPrice = _selectedVariant.sellPrice;
    final totalPrice = displayPrice * _quantity;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Full-Bleed Modern Glassmorphic SliverAppBar
          SliverAppBar(
            expandedHeight: 260.0,
            pinned: true,
            backgroundColor: AppColors.primaryEmerald,
            leading: Center(
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.black.withValues(alpha: 0.4),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 18),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            actions: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.black.withValues(alpha: 0.4),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.bookmark_add_rounded, color: Colors.white, size: 18),
                      tooltip: 'Save to Quick List',
                      onPressed: _addToQuickList,
                    ),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  widget.product.imageUrl.isNotEmpty
                      ? Image.network(widget.product.imageUrl, fit: BoxFit.cover)
                      : Container(color: AppColors.surfaceVariant),
                  // Dark Top Gradient Scrim for Status Bar Readability
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withValues(alpha: 0.65),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.4),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Product Details Content Sheet
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -20),
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Shop Store Badge
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primaryEmerald.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.storefront_rounded, color: AppColors.primaryEmerald, size: 14),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.shopName,
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryEmerald,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '• Verified Local Store',
                          style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Product Title & Price Pill Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.product.productName,
                            style: GoogleFonts.outfit(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                              height: 1.25,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.accentMintLight,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.primaryEmerald.withValues(alpha: 0.2)),
                          ),
                          child: Text(
                            Formatters.currency(displayPrice),
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryEmerald,
                            ),
                          ),
                        ),
                      ],
                    ),

                    if (widget.product.description.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        widget.product.description,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),

                    // Compact Variant Selection Section
                    Text(
                      'AVAILABLE VARIANTS',
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.product.variants.map((variant) {
                        final isSelected = _selectedVariant.name == variant.name;
                        final isOut = variant.stock <= 0;

                        return GestureDetector(
                          onTap: isOut
                              ? null
                              : () {
                                  setState(() {
                                    _selectedVariant = variant;
                                  });
                                },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primaryEmerald
                                  : isOut
                                      ? AppColors.surfaceVariant
                                      : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primaryEmerald
                                    : isOut
                                        ? Colors.transparent
                                        : AppColors.border,
                                width: isSelected ? 1.5 : 1,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: AppColors.primaryEmerald.withValues(alpha: 0.2),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isSelected) ...[
                                  const Icon(Icons.check_circle_rounded, color: Colors.white, size: 14),
                                  const SizedBox(width: 6),
                                ],
                                Text(
                                  variant.name,
                                  style: GoogleFonts.inter(
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                    fontSize: 12,
                                    color: isSelected
                                        ? Colors.white
                                        : isOut
                                            ? AppColors.textMuted
                                            : AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  Formatters.currency(variant.sellPrice),
                                  style: GoogleFonts.outfit(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Colors.white.withValues(alpha: 0.9)
                                        : isOut
                                            ? AppColors.textMuted
                                            : AppColors.primaryEmerald,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // Modern Compact Quantity Stepper Section
                    Text(
                      'QUANTITY',
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_rounded, size: 18),
                                color: AppColors.primaryEmerald,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                onPressed: _quantity > 1
                                    ? () {
                                        setState(() {
                                          _quantity--;
                                        });
                                      }
                                    : null,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  '$_quantity',
                                  style: GoogleFonts.outfit(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_rounded, size: 18),
                                color: AppColors.primaryEmerald,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                onPressed: _quantity < _selectedVariant.stock
                                    ? () {
                                        setState(() {
                                          _quantity++;
                                        });
                                      }
                                    : null,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        Text(
                          _selectedVariant.stock > 0
                              ? 'In Stock (${_selectedVariant.stock} available)'
                              : 'Out of Stock',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: _selectedVariant.stock > 0 ? AppColors.success : AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // Fixed Bottom Navigation Bar with Bottom Inset Padding (No Cut-Off!)
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(16, 12, 16, bottomPadding + 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: _addToQuickList,
              icon: const Icon(Icons.bookmark_add_outlined, color: AppColors.primaryEmerald, size: 24),
              tooltip: 'Save to Quick List',
            ),
            const SizedBox(width: 10),
            Expanded(
              child: AppButton(
                text: 'Add ${_quantity}x to Cart • ${Formatters.currency(totalPrice)}',
                icon: Icons.shopping_bag_rounded,
                type: AppButtonType.primary,
                onPressed: _selectedVariant.stock > 0 ? _addToCart : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
