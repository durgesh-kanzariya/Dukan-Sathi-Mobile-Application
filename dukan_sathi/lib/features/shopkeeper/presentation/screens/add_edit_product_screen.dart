import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/network/image_upload_service.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../data/repositories/shopkeeper_repository_impl.dart';
import '../../domain/entities/inventory_product_entity.dart';
import '../providers/shopkeeper_provider.dart';

class AddEditProductScreen extends ConsumerStatefulWidget {
  final InventoryProductEntity? product;
  final InventoryProductEntity? productToEdit;

  const AddEditProductScreen({super.key, this.product, this.productToEdit});

  InventoryProductEntity? get activeProduct => productToEdit ?? product;

  @override
  ConsumerState<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends ConsumerState<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _imageController;

  String _selectedCategory = 'Dairy & Eggs';
  List<Map<String, dynamic>> _variants = [];
  bool _isUploadingImage = false;
  bool _isSaving = false;

  final List<String> _categories = [
    'Dairy & Eggs',
    'Atta, Rice & Dal',
    'Snacks & Munchies',
    'Cold Drinks & Juices',
    'Personal Care',
    'Cleaning & Household',
    'Fruits & Vegetables',
    'General Store',
  ];

  @override
  void initState() {
    super.initState();
    final p = widget.activeProduct;
    _nameController = TextEditingController(text: p?.productName ?? '');
    _descController = TextEditingController(text: p?.description ?? '');
    _imageController = TextEditingController(text: p?.imageUrl ?? '');

    if (p != null && p.category.isNotEmpty) {
      if (_categories.contains(p.category)) {
        _selectedCategory = p.category;
      }
    }

    if (p != null && p.variants.isNotEmpty) {
      _variants = p.variants
          .map((v) => {
                'name': v.name,
                'buyPrice': v.buyPrice,
                'sellPrice': v.sellPrice,
                'stock': v.stock,
              })
          .toList();
    } else {
      _variants = [
        {'name': '1 kg', 'buyPrice': 0.0, 'sellPrice': 0.0, 'stock': 10}
      ];
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadProductImage(ImageSource source) async {
    setState(() {
      _isUploadingImage = true;
    });

    try {
      final uploadService = ref.read(imageUploadServiceProvider);
      final imageUrl = await uploadService.pickAndUploadImage(source: source);

      if (imageUrl != null && mounted) {
        setState(() {
          _imageController.text = imageUrl;
        });
        AppSnackBar.showSuccess(context, 'Product image uploaded successfully!');
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.showError(context, 'Image upload failed: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingImage = false;
        });
      }
    }
  }

  void _showImagePickerModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Product Photo Source',
                style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 6),
              Text(
                'Capture product with phone camera or upload from photo gallery',
                style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryEmerald.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt_rounded, color: AppColors.primaryEmerald),
                ),
                title: Text('Take Photo with Camera 📷', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 15)),
                subtitle: Text('Open camera & capture item directly', style: GoogleFonts.inter(fontSize: 12)),
                onTap: () {
                  Navigator.pop(context);
                  _pickAndUploadProductImage(ImageSource.camera);
                },
              ),
              const Divider(),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.info.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.photo_library_rounded, color: AppColors.info),
                ),
                title: Text('Choose from Gallery 🖼️', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 15)),
                subtitle: Text('Select an existing photo from gallery', style: GoogleFonts.inter(fontSize: 12)),
                onTap: () {
                  Navigator.pop(context);
                  _pickAndUploadProductImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    if (_variants.isEmpty) {
      AppSnackBar.showError(context, 'Please add at least one product variant.');
      return;
    }

    final shopId = ref.read(activeShopIdProvider).asData?.value;
    if (shopId == null || shopId.isEmpty) {
      AppSnackBar.showError(context, 'Merchant shop ID not found. Please setup shop profile first.');
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final repo = ref.read(shopkeeperRepositoryProvider);
      final p = widget.activeProduct;

      final productData = {
        'productName': _nameController.text.trim(),
        'description': _descController.text.trim(),
        'imageUrl': _imageController.text.trim(),
        'category': _selectedCategory,
        'variants': _variants,
      };

      if (p != null) {
        await repo.updateProduct(shopId, p.id, productData);
      } else {
        await repo.addProduct(shopId, productData);
      }

      if (!mounted) return;
      AppSnackBar.showSuccess(
        context,
        p != null ? 'Product updated successfully!' : 'Product added to inventory!',
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.showError(context, 'Failed to save product: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _addVariant() {
    setState(() {
      _variants.add({'name': '1 pc', 'buyPrice': 0.0, 'sellPrice': 0.0, 'stock': 10});
    });
  }

  void _removeVariant(int index) {
    if (_variants.length <= 1) {
      AppSnackBar.showError(context, 'At least one variant is required.');
      return;
    }
    setState(() {
      _variants.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.activeProduct != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Product' : 'Add New Product',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image Picker Card with Camera Action
              AppCard(
                onTap: _showImagePickerModal,
                child: Column(
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            width: 80,
                            height: 80,
                            color: AppColors.surfaceVariant,
                            child: _isUploadingImage
                                ? const Center(child: CircularProgressIndicator(color: AppColors.primaryEmerald))
                                : (_imageController.text.trim().isNotEmpty)
                                    ? Image.network(
                                        _imageController.text.trim(),
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stack) => const Icon(
                                          Icons.broken_image_rounded,
                                          color: AppColors.textMuted,
                                          size: 32,
                                        ),
                                      )
                                    : const Icon(Icons.add_a_photo_rounded, color: AppColors.primaryEmerald, size: 32),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _imageController.text.trim().isNotEmpty ? 'Product Photo Set' : 'Add Product Photo',
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Tap to capture with Camera 📷 or pick from Gallery 🖼️',
                                style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: _showImagePickerModal,
                                    icon: const Icon(Icons.camera_alt_rounded, size: 14),
                                    label: Text('Camera / Gallery', style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primaryEmerald,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      minimumSize: Size.zero,
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                  ),
                                ],
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

              // Product Basic Info Form Card
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Product Information',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 14),

                    AppTextField(
                      controller: _nameController,
                      label: 'Product Name',
                      hintText: 'e.g. Amul Taaza Toned Milk',
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) return 'Product name is required';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // Category Dropdown Picker
                    Text(
                      'Category',
                      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedCategory,
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down_rounded, color: AppColors.primaryEmerald),
                          style: GoogleFonts.outfit(fontSize: 14, color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                          items: _categories.map((cat) {
                            return DropdownMenuItem<String>(
                              value: cat,
                              child: Text(cat),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _selectedCategory = val;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    AppTextField(
                      controller: _descController,
                      label: 'Description (Optional)',
                      hintText: 'e.g. Fresh pasteurized milk 3.0% fat content',
                    ),
                    const SizedBox(height: 12),

                    AppTextField(
                      controller: _imageController,
                      label: 'Product Image URL (Auto-filled or manual)',
                      hintText: 'https://images.unsplash.com/...',
                      onChanged: (val) => setState(() {}),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Product Variants Builder Card
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Price & Stock Variants',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _addVariant,
                    icon: const Icon(Icons.add_circle_outline_rounded, size: 16, color: AppColors.primaryEmerald),
                    label: Text(
                      'Add Variant',
                      style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AppColors.primaryEmerald),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _variants.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final variant = _variants[index];
                  return AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Variant #${index + 1}',
                              style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            if (_variants.length > 1)
                              IconButton(
                                icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 20),
                                onPressed: () => _removeVariant(index),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: TextFormField(
                                    initialValue: variant['name']?.toString() ?? '',
                                    decoration: InputDecoration(
                                      labelText: 'Unit / Name',
                                      hintText: 'e.g. 1 kg / 500 ml',
                                      filled: true,
                                      fillColor: AppColors.surfaceVariant,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    onChanged: (val) => variant['name'] = val,
                                    validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    initialValue: variant['stock']?.toString() ?? '0',
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: 'Stock Qty',
                                      filled: true,
                                      fillColor: AppColors.surfaceVariant,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    onChanged: (val) => setState(() {
                                      variant['stock'] = int.tryParse(val) ?? 0;
                                    }),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    initialValue: variant['buyPrice']?.toString() ?? '0',
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: 'Cost Price (₹)',
                                      hintText: 'Merchant cost',
                                      filled: true,
                                      fillColor: AppColors.surfaceVariant,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    onChanged: (val) => setState(() {
                                      variant['buyPrice'] = double.tryParse(val) ?? 0.0;
                                    }),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                    initialValue: variant['sellPrice']?.toString() ?? '0',
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: 'Selling Price (₹)',
                                      hintText: 'Customer price',
                                      filled: true,
                                      fillColor: AppColors.surfaceVariant,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    onChanged: (val) => setState(() {
                                      variant['sellPrice'] = double.tryParse(val) ?? 0.0;
                                    }),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            // Real-time Profit Calculation Badge
                            Builder(
                              builder: (context) {
                                final buy = double.tryParse(variant['buyPrice']?.toString() ?? '0') ?? 0.0;
                                final sell = double.tryParse(variant['sellPrice']?.toString() ?? '0') ?? 0.0;
                                final profit = sell - buy;
                                final margin = buy > 0 ? ((profit / buy) * 100).toStringAsFixed(1) : '0';
                                final isProfitable = profit >= 0;

                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: isProfitable ? AppColors.successLight : AppColors.errorLight,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            isProfitable ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                                            size: 16,
                                            color: isProfitable ? AppColors.success : AppColors.error,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Profit per unit: ₹${profit.toStringAsFixed(2)}',
                                            style: GoogleFonts.outfit(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: isProfitable ? AppColors.success : AppColors.error,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        '$margin% margin',
                                        style: GoogleFonts.inter(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: isProfitable ? AppColors.success : AppColors.error,
                                        ),
                                      ),
                                    ],
                                  ),
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
              const SizedBox(height: 28),

              AppButton(
                text: isEditing ? 'Save Product Changes' : 'Add Product to Inventory',
                icon: Icons.check_circle_rounded,
                type: AppButtonType.primary,
                isLoading: _isSaving,
                onPressed: _saveProduct,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
