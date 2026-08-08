import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../data/repositories/shopkeeper_repository_impl.dart';
import '../../domain/entities/shopkeeper_order_entity.dart';
import '../providers/shopkeeper_provider.dart';

enum VerificationMode { qrScan, pinInput }

class QRScannerScreen extends ConsumerStatefulWidget {
  const QRScannerScreen({super.key});

  @override
  ConsumerState<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends ConsumerState<QRScannerScreen> {
  VerificationMode _activeMode = VerificationMode.qrScan;
  final TextEditingController _pinController = TextEditingController();
  late final MobileScannerController _scannerController;
  
  bool _isProcessing = false;
  bool _isTorchOn = false;

  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      torchEnabled: false,
    );
  }

  @override
  void dispose() {
    _pinController.dispose();
    _scannerController.dispose();
    super.dispose();
  }

  Future<void> _processScanCode(String rawCode) async {
    final cleanCode = rawCode.trim();
    if (cleanCode.isEmpty || _isProcessing) return;

    final shopId = ref.read(activeShopIdProvider).asData?.value;
    if (shopId == null || shopId.isEmpty) {
      AppSnackBar.showError(context, 'Shop ID not found. Please log in again.');
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final repo = ref.read(shopkeeperRepositoryProvider);
      final completedOrder = await repo.verifyAndCompleteOrderWithScan(
        shopId: shopId,
        pickupCodeOrOrderId: cleanCode,
      );

      if (!mounted) return;
      _pinController.clear();
      _showSuccessDialog(completedOrder);
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.showError(
        context,
        'Verification Failed: ${e.toString().replaceAll('Exception: ', '')}',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _showSuccessDialog(ShopkeeperOrderEntity order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColors.successLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 52),
              ),
              const SizedBox(height: 16),
              Text(
                'Order Verified & Fulfilled! 🎉',
                style: GoogleFonts.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Order #${order.id.substring(0, 8).toUpperCase()} • PIN ${order.pickupCode}',
                style: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted),
              ),
              const SizedBox(height: 16),
              const Divider(color: AppColors.divider),
              const SizedBox(height: 14),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Collected Amount:',
                    style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary),
                  ),
                  Text(
                    Formatters.currency(order.totalPrice),
                    style: GoogleFonts.outfit(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryEmerald,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.inventory_2_outlined, color: AppColors.success, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${order.items.length} item(s) verified & deducted from stock inventory.',
                        style: GoogleFonts.inter(fontSize: 12, color: AppColors.success, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              AppButton(
                text: 'Done & Next Order Scan',
                type: AppButtonType.primary,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkObsidian,
      appBar: AppBar(
        title: Text(
          'Order Verification',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: AppColors.darkObsidian,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_activeMode == VerificationMode.qrScan) ...[
            IconButton(
              icon: Icon(_isTorchOn ? Icons.flash_on_rounded : Icons.flash_off_rounded, color: Colors.white),
              tooltip: 'Toggle Flashlight',
              onPressed: () async {
                await _scannerController.toggleTorch();
                setState(() {
                  _isTorchOn = !_isTorchOn;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.cameraswitch_rounded, color: Colors.white),
              tooltip: 'Switch Camera',
              onPressed: () => _scannerController.switchCamera(),
            ),
          ],
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Mode Selector Bar (QR Scan vs Manual PIN)
            Container(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _activeMode = VerificationMode.qrScan;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _activeMode == VerificationMode.qrScan ? AppColors.primaryEmerald : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.qr_code_scanner_rounded,
                              size: 18,
                              color: _activeMode == VerificationMode.qrScan ? Colors.white : Colors.white60,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'QR Scanner',
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: _activeMode == VerificationMode.qrScan ? Colors.white : Colors.white60,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _activeMode = VerificationMode.pinInput;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _activeMode == VerificationMode.pinInput ? AppColors.primaryEmerald : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.pin_rounded,
                              size: 18,
                              color: _activeMode == VerificationMode.pinInput ? Colors.white : Colors.white60,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Manual PIN',
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: _activeMode == VerificationMode.pinInput ? Colors.white : Colors.white60,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Main Active View Body
            Expanded(
              child: _activeMode == VerificationMode.qrScan
                  ? _buildCameraScanView()
                  : _buildManualPinView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraScanView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.primaryEmerald.withValues(alpha: 0.5), width: 2),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Camera Texture View
                    MobileScanner(
                      controller: _scannerController,
                      onDetect: (capture) {
                        final List<Barcode> barcodes = capture.barcodes;
                        for (final barcode in barcodes) {
                          if (barcode.rawValue != null && !_isProcessing) {
                            _processScanCode(barcode.rawValue!);
                            break;
                          }
                        }
                      },
                    ),

                    // Reticle Frame Overlay
                    Container(
                      width: 240,
                      height: 240,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primaryEmerald, width: 3.5),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryEmerald.withValues(alpha: 0.3),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),

                    if (_isProcessing)
                      Container(
                        color: Colors.black.withValues(alpha: 0.7),
                        child: const Center(
                          child: CircularProgressIndicator(color: AppColors.primaryEmerald),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Point camera at customer pickup QR code',
            style: GoogleFonts.inter(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildManualPinView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primaryEmerald.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.pin_rounded, color: AppColors.primaryEmerald, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Enter Customer Pickup PIN',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Customer displays a 4-digit PIN on their order screen.',
                            style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                AppTextField(
                  controller: _pinController,
                  labelText: 'Pickup PIN / Order Code',
                  hintText: 'e.g. 4892',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),

                AppButton(
                  text: 'Verify & Fulfill Order',
                  icon: Icons.check_circle_rounded,
                  type: AppButtonType.primary,
                  isLoading: _isProcessing,
                  onPressed: () {
                    if (_pinController.text.trim().isNotEmpty) {
                      _processScanCode(_pinController.text);
                    } else {
                      AppSnackBar.showError(context, 'Please enter the pickup PIN code.');
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
