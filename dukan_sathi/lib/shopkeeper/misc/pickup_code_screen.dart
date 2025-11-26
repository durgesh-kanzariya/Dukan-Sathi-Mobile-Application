// import 'package:flutter/material.dart';
// import 'package:get/get.dart'; // Import Get
// import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:dukan_sathi/shopkeeper/order/order_controller.dart'; // Import OrderController

// class PickupCodeScreen extends StatefulWidget {
//   const PickupCodeScreen({Key? key}) : super(key: key);

//   @override
//   State<PickupCodeScreen> createState() => _PickupCodeScreenState();
// }

// class _PickupCodeScreenState extends State<PickupCodeScreen> {
//   // --- 1. FIND THE CONTROLLER ---
//   final OrderController controller = Get.find<OrderController>();

//   // Controller for the mobile scanner
//   final MobileScannerController scannerController = MobileScannerController(
//     detectionSpeed: DetectionSpeed.normal,
//     facing: CameraFacing.back,
//   );
//   // Controller for the text field
//   final TextEditingController textController = TextEditingController();

//   bool isScanCompleted = false; // To prevent multiple scans

//   // --- 2. REMOVED _showSuccessDialog ---
//   // The OrderController now handles all success/error dialogs and navigation.

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFDFBF5),
//       body: Column(
//         children: [
//           _buildHeader(context),
//           Expanded(
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 30.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const SizedBox(height: 40),
//                     AspectRatio(
//                       aspectRatio: 1.0,
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(24),
//                         child: Stack(
//                           alignment: Alignment.center,
//                           children: [
//                             MobileScanner(
//                               controller: scannerController,
//                               onDetect: (capture) {
//                                 // --- 3. CALL THE CONTROLLER ---
//                                 if (!isScanCompleted) {
//                                   final String? code =
//                                       capture.barcodes.first.rawValue;
//                                   if (code != null && code.isNotEmpty) {
//                                     isScanCompleted = true; // Prevent re-scans
//                                     // Call the controller to complete the order
//                                     controller.completeOrder(code);
//                                   }
//                                 }
//                               },
//                             ),
//                             Container(
//                               decoration: BoxDecoration(
//                                 border: Border.all(
//                                   color: Colors.white.withOpacity(0.5),
//                                   width: 4,
//                                 ),
//                                 borderRadius: BorderRadius.circular(24),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 40),
//                     const Text(
//                       'OR',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.black54,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     const Text(
//                       'Enter pickup code',
//                       style: TextStyle(fontSize: 18, color: Colors.black87),
//                     ),
//                     const SizedBox(height: 20),
//                     _buildCodeInput(), // This now uses textController
//                     const SizedBox(height: 20),
//                     _buildSubmitButton(), // --- 4. ADDED SUBMIT BUTTON ---
//                     const SizedBox(height: 40),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildHeader(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.only(top: 50, left: 10, right: 20, bottom: 20),
//       decoration: const BoxDecoration(
//         color: Color(0xFF5A7D60),
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(30),
//           bottomRight: Radius.circular(30),
//         ),
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.arrow_back, color: Colors.white),
//                 onPressed: () {
//                   Get.back();
//                 },
//               ),
//               const Expanded(
//                 child: Text(
//                   'DUKAN SATHI',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 30,
//                     letterSpacing: 4,
//                     fontFamily: "Abel",
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 48),
//             ],
//           ),
//           const Text(
//             'Order Pickup', // Updated title
//             style: TextStyle(color: Colors.white70, fontSize: 18),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCodeInput() {
//     return TextField(
//       controller: textController, // --- 5. CONNECT TEXT CONTROLLER ---
//       textAlign: TextAlign.center,
//       style: const TextStyle(fontSize: 18, letterSpacing: 2),
//       decoration: InputDecoration(
//         hintText: 'Enter code here',
//         filled: true,
//         fillColor: Colors.white,
//         contentPadding: const EdgeInsets.symmetric(vertical: 18),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(30),
//           borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(30),
//           borderSide: const BorderSide(color: Color(0xFF5A7D60), width: 2),
//         ),
//       ),
//     );
//   }

//   // --- 6. NEW SUBMIT BUTTON WIDGET ---
//   Widget _buildSubmitButton() {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton(
//         onPressed: () {
//           final code = textController.text.trim();
//           if (code.isNotEmpty) {
//             // Call the same controller function
//             controller.completeOrder(code);
//           } else {
//             Get.snackbar('Error', 'Please enter a pickup code.');
//           }
//         },
//         style: ElevatedButton.styleFrom(
//           backgroundColor: const Color(0xFF5A7D60),
//           foregroundColor: Colors.white,
//           padding: const EdgeInsets.symmetric(vertical: 16),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(30),
//           ),
//           textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         child: const Text('Submit Code'),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     scannerController.dispose();
//     textController.dispose();
//     super.dispose();
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:dukan_sathi/shopkeeper/order/order_controller.dart';

class PickupCodeScreen extends StatefulWidget {
  const PickupCodeScreen({Key? key}) : super(key: key);

  @override
  State<PickupCodeScreen> createState() => _PickupCodeScreenState();
}

class _PickupCodeScreenState extends State<PickupCodeScreen> {
  final OrderController controller = Get.find<OrderController>();

  // --- PERFORMANCE FIX 1: OPTIMIZED CONTROLLER ---
  final MobileScannerController scannerController = MobileScannerController(
    // 'noDuplicates' is faster than 'normal' but safer than 'unrestricted'
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
    torchEnabled: false,
    // CRITICAL: Only scan QR codes. Ignores barcodes/UPC (Huge speed boost)
    formats: [BarcodeFormat.qrCode],
    returnImage: false, // Saves processing power
  );

  final TextEditingController textController = TextEditingController();
  bool isScanCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF5),
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    // --- SCANNER AREA ---
                    AspectRatio(
                      aspectRatio: 1.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            MobileScanner(
                              controller: scannerController,
                              // --- PERFORMANCE FIX 2: SIMPLER LOGIC ---
                              onDetect: (capture) {
                                if (isScanCompleted) return;

                                final List<Barcode> barcodes = capture.barcodes;
                                for (final barcode in barcodes) {
                                  // Ensure code is valid before triggering logic
                                  if (barcode.rawValue != null &&
                                      barcode.rawValue!.isNotEmpty) {
                                    setState(() {
                                      isScanCompleted = true;
                                    });

                                    // Give user immediate haptic/visual feedback (optional)
                                    // HapticFeedback.mediumImpact();

                                    // Complete the order
                                    controller.completeOrder(barcode.rawValue!);
                                    break;
                                  }
                                }
                              },
                            ),
                            // Scanning Frame Overlay
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.5),
                                  width: 4,
                                ),
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            // Optional: Center Red Line to help user aim
                            Container(
                              height: 2,
                              width: 200,
                              color: Colors.red.withOpacity(0.6),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'OR',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Enter pickup code manually',
                      style: TextStyle(fontSize: 18, color: Colors.black87),
                    ),
                    const SizedBox(height: 20),

                    _buildCodeInput(),
                    const SizedBox(height: 20),
                    _buildSubmitButton(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 10, right: 20, bottom: 20),
      decoration: const BoxDecoration(
        color: Color(0xFF5A7D60),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Get.back(),
              ),
              const Expanded(
                child: Text(
                  'DUKAN SATHI',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    letterSpacing: 4,
                    fontFamily: "Abel", // Ensure this font is in pubspec
                  ),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const Text(
            'Order Pickup',
            style: TextStyle(color: Colors.white70, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeInput() {
    return TextField(
      controller: textController,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      style: const TextStyle(
        fontSize: 24,
        letterSpacing: 4,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        hintText: '#### - ####',
        hintStyle: TextStyle(
          fontSize: 18,
          letterSpacing: 1,
          color: Colors.grey.shade400,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xFF5A7D60), width: 2),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          FocusScope.of(context).unfocus();
          final code = textController.text.trim();
          if (code.isNotEmpty) {
            controller.completeOrder(code);
          } else {
            Get.snackbar(
              'Input Required',
              'Please enter the pickup code.',
              backgroundColor: Colors.orange,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5A7D60),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        child: const Text('Complete Order'),
      ),
    );
  }

  @override
  void dispose() {
    scannerController.dispose();
    textController.dispose();
    super.dispose();
  }
}
