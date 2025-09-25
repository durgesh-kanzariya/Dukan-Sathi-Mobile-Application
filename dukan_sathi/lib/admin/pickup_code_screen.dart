import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class PickupCodeScreen extends StatefulWidget {
  const PickupCodeScreen({Key? key}) : super(key: key);

  @override
  State<PickupCodeScreen> createState() => _PickupCodeScreenState();
}

class _PickupCodeScreenState extends State<PickupCodeScreen> {
  // Controller for the mobile scanner
  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
  );
  bool isScanCompleted = false; // To prevent multiple dialogs

  // Function to show the success dialog
  void _showSuccessDialog(String code) {
    // Ensure we only show the dialog once per scan session
    if (!isScanCompleted) {
      isScanCompleted = true;

      showDialog(
        context: context,
        barrierDismissible: false, // User must tap button to close
        builder: (context) => AlertDialog(
          title: const Text('Scan Successful'),
          content: Text('Order Code: $code'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                isScanCompleted = false; // Reset for next scan
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Go back from the scan screen
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ).then((_) {
        // After dialog is closed, allow scanning again
        isScanCompleted = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF5),
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
                    // Replaced QRView with MobileScanner
                    AspectRatio(
                      aspectRatio: 1.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        // Using a Stack to create a custom overlay
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            MobileScanner(
                              controller: controller,
                              onDetect: (capture) {
                                final List<Barcode> barcodes = capture.barcodes;
                                if (barcodes.isNotEmpty) {
                                  final String? code = barcodes.first.rawValue;
                                  if (code != null) {
                                    _showSuccessDialog(code);
                                  }
                                }
                              },
                            ),
                            // Custom overlay to mimic the design
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.5),
                                  width: 4,
                                ),
                                borderRadius: BorderRadius.circular(24),
                              ),
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
                      'Enter pickup code',
                      style: TextStyle(fontSize: 18, color: Colors.black87),
                    ),
                    const SizedBox(height: 20),
                    _buildCodeInput(),
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
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              const Expanded(
                child: Text(
                  'DUKAN SATHI',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    letterSpacing: 4,
                    fontFamily: "Abel",
                  ),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const Text(
            'Order details',
            style: TextStyle(color: Colors.white70, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeInput() {
    return TextField(
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 18, letterSpacing: 2),
      decoration: InputDecoration(
        hintText: 'Enter code here',
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

  // Make sure to dispose of the controller
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
