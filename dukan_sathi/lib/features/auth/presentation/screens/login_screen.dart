import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/animations/smooth_page_route.dart';
import '../../../../core/utils/firebase_reset_util.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../providers/auth_notifier.dart';
import 'sign_up_screen.dart';

class CleanLoginScreen extends ConsumerStatefulWidget {
  const CleanLoginScreen({super.key});

  @override
  ConsumerState<CleanLoginScreen> createState() => _CleanLoginScreenState();
}

class _CleanLoginScreenState extends ConsumerState<CleanLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitLogin() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    final success = await ref.read(authNotifierProvider.notifier).signIn(
          email: _emailController.text,
          password: _passwordController.text,
        );

    if (!success && mounted) {
      final errorMessage = ref.read(authNotifierProvider).errorMessage ?? 'Login failed';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _resetFirebaseDatabase() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('🔥 Wipe All Firebase Data?', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        content: const Text('This will programmatically delete all shops, products, orders, and user profiles from Firestore for a fresh test.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('WIPE ALL DATA'),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🔥 Wiping all Firebase data... Please wait'),
        backgroundColor: AppColors.warning,
        duration: Duration(seconds: 2),
      ),
    );

    try {
      await FirebaseResetUtil.wipeAllFirestoreData(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Firebase data completely wiped clean! You can now register fresh.'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Firestore Permission Error', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AppColors.error)),
          content: Text(e.toString().replaceAll('Exception: ', '')),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
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
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 48),
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36),
                ),
              ),
              child: Column(
                children: [
                  // GPU-Optimized Hero Icon Badge
                  Hero(
                    tag: 'auth_logo_hero',
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.accentMint,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.storefront_rounded,
                        size: 48,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Dukan Sathi',
                    style: GoogleFonts.outfit(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Hyperlocal Grocery & Retail Pre-Ordering',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),

            // Form Sheet Card Container
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
                        Text(
                          'Welcome Back',
                          style: GoogleFonts.outfit(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Sign in to access your pre-orders and inventory.',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 24),

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
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Submit Sign In Button
                        AppButton(
                          text: 'Sign In to Account',
                          icon: Icons.arrow_forward_rounded,
                          type: AppButtonType.primary,
                          isLoading: authState.isLoading,
                          onPressed: _submitLogin,
                        ),
                        const SizedBox(height: 20),

                        // Switch to Sign Up Toggle Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: GoogleFonts.inter(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                ref.read(authNotifierProvider.notifier).clearError();
                                Navigator.push(
                                  context,
                                  SmoothAuthPageRoute(
                                    page: const CleanSignUpScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Sign Up',
                                style: GoogleFonts.inter(
                                  color: AppColors.primaryEmerald,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Dev Reset Database Button
                        Center(
                          child: TextButton.icon(
                            onPressed: _resetFirebaseDatabase,
                            icon: const Icon(Icons.local_fire_department_rounded, color: AppColors.error, size: 18),
                            label: Text(
                              'Reset Firebase Test Data',
                              style: GoogleFonts.inter(
                                color: AppColors.error,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
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
