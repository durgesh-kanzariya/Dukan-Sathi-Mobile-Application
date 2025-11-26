import 'package:dukan_sathi/customer/discover_shop.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/customer/dashboard.dart';
import '/customer/history.dart';
import '/customer/quick_order.dart';
import '/customer/cart_page.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        Container(
          // --- ADJUSTED VALUE ---
          height: 60, // Was 65
          decoration: const BoxDecoration(color: Color(0xFF5A7D60)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              // Home Icon Button
              _buildNavItem(
                icon: Icons.home_outlined,
                label: 'Home',
                onPressed: () {
                  // TODO: Use a state management solution instead of passing credentials
                  Get.offAll(() => Dashboard());
                },
              ),

              // Shops Icon Button
              _buildNavItem(
                icon: Icons.store_outlined,
                label: 'Shops',
                onPressed: () {
                  Get.offAll(
                    () => const DiscoverShop(),
                  ); // Use offAll for root pages
                },
              ),

              // Spacer for the floating cart button
              const SizedBox(width: 60),

              // History Icon Button
              _buildNavItem(
                icon: Icons.history_outlined,
                label: 'History',
                onPressed: () {
                  Get.offAll(() => const History());
                },
              ),

              // Quick list Icon Button
              _buildNavItem(
                icon: Icons.format_list_bulleted,
                label: 'Quick list',
                onPressed: () {
                  Get.offAll(() => const QuickOrder());
                },
              ),
            ],
          ),
        ),

        // Floating Action Button
        Positioned(
          // --- ADJUSTED VALUE ---
          top: -35, // Was -40
          child: GestureDetector(
            onTap: () {
              // Using Get.to so the user can go back from the cart
              Get.to(() => const CardPage());
            },
            child: Container(
              // --- ADJUSTED VALUE ---
              height: 100, // Was 100
              width: 75, // Was 80
              decoration: const BoxDecoration(
                color: Color(0xFF5A7D60),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(300),
                  topRight: Radius.circular(300),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                    // --- ADJUSTED VALUE ---
                    size: 40, // Was 50
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Cart",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  const SizedBox(height: 5), // To push content up slightly
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Helper widget to reduce code duplication for the nav items
  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(30), // for the ripple effect
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, color: Colors.white, size: 28),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
