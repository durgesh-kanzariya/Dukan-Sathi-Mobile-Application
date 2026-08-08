import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../providers/auth_notifier.dart';

class CleanSignUpScreen extends ConsumerStatefulWidget {
  const CleanSignUpScreen({super.key});

  @override
  ConsumerState<CleanSignUpScreen> createState() => _CleanSignUpScreenState();
}

class _CleanSignUpScreenState extends ConsumerState<CleanSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _selectedRole = 'customer'; // Default role: customer

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    final success = await ref.read(authNotifierProvider.notifier).signUp(
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          role: _selectedRole,
        );

    if (success && mounted) {
      Navigator.pop(context);
    } else if (mounted) {
      final errorMessage = ref.read(authNotifierProvider).errorMessage ?? 'Sign up failed';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Full-Bleed Hero Header Container
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 44),
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 28),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),

                      // GPU-Optimized Hero Icon Badge
                      Hero(
                        tag: 'auth_logo_hero',
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.accentMint,
                              width: 1.5,
                            ),
                          ),
                          child: const Icon(
                            Icons.storefront_rounded,
                            size: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      Text(
                        'Dukan Sathi',
                        style: GoogleFonts.outfit(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create Account',
                          style: GoogleFonts.outfit(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Join Dukan Sathi to pre-order or manage local retail.',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Form Sheet Container
            Transform.translate(
              offset: const Offset(0, -24),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Role Selection Label
                        Text(
                          'SELECT YOUR ACCOUNT TYPE',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Interactive Role Selector Cards Row
                        Row(
                          children: [
                            Expanded(
                              child: _RoleCard(
                                title: 'Customer',
                                subtitle: 'Pre-order groceries',
                                icon: Icons.shopping_bag_outlined,
                                isSelected: _selectedRole == 'customer',
                                onTap: () {
                                  setState(() {
                                    _selectedRole = 'customer';
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _RoleCard(
                                title: 'Shopkeeper',
                                subtitle: 'Manage store orders',
                                icon: Icons.storefront_outlined,
                                isSelected: _selectedRole == 'shopkeeper',
                                onTap: () {
                                  setState(() {
                                    _selectedRole = 'shopkeeper';
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Full Name Field
                        AppTextField(
                          controller: _nameController,
                          labelText: 'Full Name',
                          hintText: 'e.g. Durgesh Kanzariya',
                          prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.textMuted),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your full name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Email Address Field
                        AppTextField(
                          controller: _emailController,
                          labelText: 'Email Address',
                          hintText: 'name@example.com',
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textMuted),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your email address';
                            }
                            if (!value.contains('@') || !value.contains('.')) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Password Field
                        AppTextField(
                          controller: _passwordController,
                          labelText: 'Password',
                          hintText: '••••••••',
                          isPassword: true,
                          prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.textMuted),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 28),

                        // Submit Register Button
                        AppButton(
                          text: 'Register Account',
                          icon: Icons.check_circle_outline_rounded,
                          type: AppButtonType.primary,
                          isLoading: authState.isLoading,
                          onPressed: _submitSignUp,
                        ),
                        const SizedBox(height: 20),

                        // Switch to Login Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: GoogleFonts.inter(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Text(
                                'Sign In',
                                style: GoogleFonts.inter(
                                  color: AppColors.primaryEmerald,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryEmerald.withValues(alpha: 0.08)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primaryEmerald : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 30,
              color: isSelected ? AppColors.primaryEmerald : AppColors.textMuted,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isSelected ? AppColors.primaryEmerald : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 10,
                color: isSelected ? AppColors.primaryEmerald.withValues(alpha: 0.8) : AppColors.textMuted,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
