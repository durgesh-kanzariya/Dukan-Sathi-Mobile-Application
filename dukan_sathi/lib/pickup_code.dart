import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'bottom_nav.dart';

class PickupCode extends StatelessWidget {
  const PickupCode({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF5),
      body: Column(
        // Using MainAxisAlignment.spaceBetween would push footer content down
        // but here we just want to center the main card.
        children: [
          _buildHeader(),

          // Use Expanded and Center to vertically and horizontally center the card
          Expanded(child: Center(child: _buildPickupCard())),
        ],
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }

  /// A responsive header that matches the rest of your app.
  Widget _buildHeader() {
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
                  ),
                ),
              ),
              const SizedBox(width: 48), // Balances the IconButton
            ],
          ),
          const Text(
            'Pickup Code', // Corrected the title for this screen
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w300,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  /// A styled card to display the QR code and pickup number.
  Widget _buildPickupCard() {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(horizontal: 30),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          mainAxisSize:
              MainAxisSize.min, // Card should only be as big as its content
          children: [
            const Text(
              'Show this code to the shopkeeper',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            // Assuming your QR image is in the assets
            Image.asset(
              "assets/imgs/qr_img.png",
              height: 200,
              width: 200,
              errorBuilder: (context, error, stackTrace) {
                // Fallback in case the image fails to load
                return Container(
                  height: 200,
                  width: 200,
                  color: Colors.grey.shade200,
                  child: const Center(child: Text('QR Code')),
                );
              },
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),
            const Text(
              "OR PROVIDE THIS CODE",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // Improved styling for the pickup code
            Text(
              "5867 - 0980",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 8, // Adds spacing between characters
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
