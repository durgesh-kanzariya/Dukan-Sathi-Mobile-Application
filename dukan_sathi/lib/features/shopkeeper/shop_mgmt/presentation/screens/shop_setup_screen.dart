import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../core/network/image_upload_service.dart';
import '../../../../../core/utils/constants.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_card.dart';
import '../../../../../core/widgets/app_confirmation_dialog.dart';
import '../../../../../core/widgets/app_snack_bar.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../../../../auth/presentation/providers/auth_notifier.dart';
import '../../../../auth/presentation/providers/role_router_provider.dart';

class CleanShopSetupScreen extends ConsumerStatefulWidget {
  const CleanShopSetupScreen({super.key});

  @override
  ConsumerState<CleanShopSetupScreen> createState() => _CleanShopSetupScreenState();
}

class _CleanShopSetupScreenState extends ConsumerState<CleanShopSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _openTimeController = TextEditingController(text: '9:00 AM');
  final TextEditingController _closeTimeController = TextEditingController(text: '9:00 PM');

  String? _uploadedImageUrl;
  String? _existingShopId;
  bool _isLoadingExisting = true;
  bool _isUploadingImage = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _fetchExistingShop();
  }

  Future<void> _fetchExistingShop() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) setState(() => _isLoadingExisting = false);
      return;
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(AppConstants.shopsCollection)
          .where('ownerId', isEqualTo: user.uid)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty && mounted) {
        final doc = snapshot.docs.first;
        final data = doc.data();
        _existingShopId = doc.id;
        _shopNameController.text = data['shopName'] ?? '';
        _descController.text = data['description'] ?? '';
        _addressController.text = data['address'] ?? '';
        _contactController.text = data['contact'] ?? '';
        _openTimeController.text = data['openTime'] ?? '9:00 AM';
        _closeTimeController.text = data['closeTime'] ?? '9:00 PM';
        _uploadedImageUrl = data['imageUrl'] ?? '';
      }
    } catch (e) {
      // Ignore fetch error, user can enter details fresh
    } finally {
      if (mounted) {
        setState(() => _isLoadingExisting = false);
      }
    }
  }

  @override
  void dispose() {
    _shopNameController.dispose();
    _descController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    _openTimeController.dispose();
    _closeTimeController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadBanner() async {
    setState(() {
      _isUploadingImage = true;
    });

    try {
      final uploadService = ref.read(imageUploadServiceProvider);
      final imageUrl = await uploadService.pickAndUploadImage(source: ImageSource.gallery);

      if (imageUrl != null && mounted) {
        setState(() {
          _uploadedImageUrl = imageUrl;
        });
        AppSnackBar.showSuccess(context, 'Shop banner uploaded successfully!');
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

  Future<void> _saveShop() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      AppSnackBar.showError(context, 'User session expired. Please log in again.');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final shopsCollection = FirebaseFirestore.instance.collection(AppConstants.shopsCollection);
      
      // Use existing shop document ID or user.uid as document ID to prevent duplicate shops
      final targetDocRef = _existingShopId != null 
          ? shopsCollection.doc(_existingShopId)
          : shopsCollection.doc(user.uid);

      final shopData = {
        'shopName': _shopNameController.text.trim(),
        'description': _descController.text.trim(),
        'address': _addressController.text.trim(),
        'contact': _contactController.text.trim(),
        'openTime': _openTimeController.text.trim(),
        'closeTime': _closeTimeController.text.trim(),
        'imageUrl': _uploadedImageUrl ?? '',
        'ownerId': user.uid,
        'isOpen': true,
        'updatedAt': FieldValue.serverTimestamp(),
        if (_existingShopId == null) 'createdAt': FieldValue.serverTimestamp(),
      };

      await targetDocRef.set(shopData, SetOptions(merge: true));

      if (!mounted) return;
      AppSnackBar.showSuccess(
        context,
        _existingShopId != null ? 'Merchant shop profile updated!' : 'Merchant shop registered successfully!',
      );

      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      } else {
        ref.invalidate(roleRouterDestinationProvider);
      }
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.showError(context, 'Failed to save shop details: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingExisting) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text('Store Setup', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
          elevation: 0,
        ),
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.primaryEmerald),
        ),
      );
    }

    final isEditing = _existingShopId != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Store Profile' : 'Set Up Merchant Store',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Card
              AppCard(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primaryEmerald.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.storefront_rounded, size: 44, color: AppColors.primaryEmerald),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      isEditing ? 'Update Store Details' : 'Register Your Store',
                      style: GoogleFonts.outfit(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isEditing
                          ? 'Modify shop information displayed to local neighborhood customers.'
                          : 'Provide shop details to start receiving pre-orders from local neighborhood customers.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Banner Photo Picker Card
              AppCard(
                onTap: _pickAndUploadBanner,
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 64,
                        height: 64,
                        color: AppColors.surfaceVariant,
                        child: _isUploadingImage
                            ? const Center(child: CircularProgressIndicator(color: AppColors.primaryEmerald))
                            : (_uploadedImageUrl != null && _uploadedImageUrl!.isNotEmpty)
                                ? Image.network(_uploadedImageUrl!, fit: BoxFit.cover)
                                : const Icon(Icons.add_a_photo_outlined, color: AppColors.textMuted, size: 24),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _uploadedImageUrl != null && _uploadedImageUrl!.isNotEmpty
                                ? 'Shop Banner Uploaded'
                                : 'Upload Shop Storefront Photo',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Tap to choose image from gallery',
                            style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Shop Details Form Fields
              AppCard(
                child: Column(
                  children: [
                    AppTextField(
                      controller: _shopNameController,
                      label: 'Shop / Business Name',
                      hintText: 'e.g. Laxmi Kirana & General Store',
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) return 'Shop name is required';
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),

                    AppTextField(
                      controller: _descController,
                      label: 'Short Description',
                      hintText: 'e.g. Fresh dairy, spices, staples & snacks',
                    ),
                    const SizedBox(height: 14),

                    AppTextField(
                      controller: _addressController,
                      label: 'Shop Address / Location',
                      hintText: 'e.g. Shop #4, Market Road, Sector 5',
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) return 'Address is required';
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),

                    AppTextField(
                      controller: _contactController,
                      label: 'Contact Phone Number',
                      hintText: 'e.g. 9876543210',
                      keyboardType: TextInputType.phone,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) return 'Contact number is required';
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            controller: _openTimeController,
                            label: 'Opening Time',
                            hintText: '9:00 AM',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppTextField(
                            controller: _closeTimeController,
                            label: 'Closing Time',
                            hintText: '9:00 PM',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              AppButton(
                text: isEditing ? 'Save Store Changes' : 'Register Merchant Store',
                icon: Icons.check_circle_rounded,
                type: AppButtonType.primary,
                isLoading: _isSubmitting,
                onPressed: _saveShop,
              ),
              const SizedBox(height: 14),

              AppButton(
                text: 'Logout Account',
                icon: Icons.logout_rounded,
                type: AppButtonType.danger,
                onPressed: () async {
                  final confirm = await AppConfirmationDialog.show(
                    context,
                    title: 'Logout Account?',
                    message: 'Are you sure you want to log out of your merchant account?',
                    confirmLabel: 'Logout',
                    icon: Icons.logout_rounded,
                    iconColor: AppColors.error,
                    confirmButtonColor: AppColors.error,
                  );

                  if (confirm == true && context.mounted) {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    await ref.read(authNotifierProvider.notifier).signOut();
                  }
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
