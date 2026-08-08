import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_confirmation_dialog.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';

class CustomerProfileScreen extends ConsumerStatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  ConsumerState<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends ConsumerState<CustomerProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  bool _isSaving = false;
  String _selectedAvatarIcon = '👤';

  final List<String> _avatarOptions = ['👤', '👨‍💼', '👩‍💼', '🥑', '🛒', '⚡'];

  @override
  void initState() {
    super.initState();
    final user = ref.read(authNotifierProvider).user;
    final initialName = (user?.name != null && user!.name.trim().isNotEmpty)
        ? user.name.trim()
        : (user?.email.isNotEmpty == true ? user!.email.split('@').first : 'Customer');

    _nameController = TextEditingController(text: initialName);
    _phoneController = TextEditingController(text: '+91 98765 43210');
    _emailController = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      final newName = _nameController.text.trim();

      if (firebaseUser != null) {
        // Update display name in Firebase Auth
        await firebaseUser.updateDisplayName(newName);

        // Update name in Firestore users collection
        await FirebaseFirestore.instance
            .collection(AppConstants.usersCollection)
            .doc(firebaseUser.uid)
            .update({
          'name': newName,
        });

        // Refresh Riverpod auth state
        await ref.read(authNotifierProvider.notifier).checkCurrentUser();
      }

      if (!mounted) return;
      AppSnackBar.showSuccess(context, 'Profile updated successfully!');
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.showError(context, 'Failed to save profile: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _showAvatarPickerModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Choose Avatar Badge', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _avatarOptions.map((emoji) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAvatarIcon = emoji;
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _selectedAvatarIcon == emoji ? AppColors.primaryEmerald.withValues(alpha: 0.1) : AppColors.surfaceVariant,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _selectedAvatarIcon == emoji ? AppColors.primaryEmerald : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Text(emoji, style: const TextStyle(fontSize: 26)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() async {
    final confirm = await AppConfirmationDialog.show(
      context,
      title: 'Logout Account?',
      message: 'Are you sure you want to log out of your Dukan Sathi account?',
      confirmLabel: 'Logout',
      icon: Icons.logout_rounded,
      iconColor: AppColors.error,
      confirmButtonColor: AppColors.error,
    );

    if (confirm == true && mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      await ref.read(authNotifierProvider.notifier).signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    final nameText = _nameController.text.isNotEmpty ? _nameController.text : 'Customer';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Profile'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Hero Profile Avatar Card with Camera Badge
              Center(
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primaryEmerald, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryEmerald.withValues(alpha: 0.15),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 46,
                        backgroundColor: AppColors.primaryEmerald.withValues(alpha: 0.1),
                        child: Text(
                          _selectedAvatarIcon != '👤' ? _selectedAvatarIcon : nameText[0].toUpperCase(),
                          style: GoogleFonts.outfit(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryEmerald,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _showAvatarPickerModal,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryEmerald,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                nameText,
                style: GoogleFonts.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                _emailController.text,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 24),

              // Editable Profile Fields Form
              AppCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ACCOUNT DETAILS',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMuted,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Full Name Field (Saved in database)
                    AppTextField(
                      controller: _nameController,
                      labelText: 'Full Name',
                      hintText: 'Enter your full name',
                      prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.primaryEmerald),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) return 'Please enter your name';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Phone Number Field
                    AppTextField(
                      controller: _phoneController,
                      labelText: 'Phone Number',
                      hintText: 'Enter phone number',
                      prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.primaryEmerald),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) return 'Please enter phone number';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Email Address (Non-Editable Account Identifier)
                    AppTextField(
                      controller: _emailController,
                      labelText: 'Email Address (Account ID)',
                      hintText: 'Email address',
                      prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textMuted),
                      suffixIcon: const Icon(Icons.lock_outline_rounded, size: 18, color: AppColors.textMuted),
                      enabled: false,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Save Changes Button
              AppButton(
                text: 'Save Changes',
                icon: Icons.check_circle_outline_rounded,
                type: AppButtonType.primary,
                isLoading: _isSaving,
                onPressed: _saveProfile,
              ),
              const SizedBox(height: 12),

              // Logout Button
              AppButton(
                text: 'Logout Account',
                icon: Icons.logout_rounded,
                type: AppButtonType.secondary,
                onPressed: _showLogoutDialog,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
