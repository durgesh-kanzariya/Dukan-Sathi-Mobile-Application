import 'package:flutter/material.dart';

class ShopkeeperBottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const ShopkeeperBottomNav({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 65,
          decoration: const BoxDecoration(color: Color(0xFF5A7D60)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              // Orders Icon
              _buildNavItem(icon: Icons.list_alt, label: 'Orders', index: 0),
              // Product Icon
              _buildNavItem(
                icon: Icons.inventory_2_outlined,
                label: 'Product',
                index: 1,
              ),
              // Spacer for the floating button
              const SizedBox(width: 60),
              // History Icon
              _buildNavItem(
                icon: Icons.history,
                label: 'History',
                index: 3, // Note the index jump
              ),
              // Shop Icon
              _buildNavItem(
                icon: Icons.store_outlined,
                label: 'Shop',
                index: 4, // Note the index jump
              ),
            ],
          ),
        ),

        // Floating Action Button (Scan)
        Positioned(
          top: -30,
          child: GestureDetector(
            onTap: () => onItemTapped(2), // This is the central button's action
            child: Container(
              height: 80,
              width: 80,
              decoration: const BoxDecoration(
                color: Color(0xFF5A7D60),
                shape: BoxShape.circle,
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.qr_code_scanner, color: Colors.white, size: 38),
                  SizedBox(height: 10),
                  // The "Scan" text is removed from here to be positioned separately
                ],
              ),
            ),
          ),
        ),

        // --- ALIGNMENT FIX: Positioned the "Scan" text separately ---
        Positioned(
          bottom: 10, // Adjust this value to perfectly align with other labels
          child: GestureDetector(
            onTap: () => onItemTapped(2),
            child: const Text(
              "Scan",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  // Helper widget to build each navigation item
  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    // Adjust index for selection logic
    final navPageIndex = index > 2 ? index - 1 : index;
    final isSelected = selectedIndex == navPageIndex;
    final color = isSelected ? Colors.white : Colors.white.withOpacity(0.7);

    return InkWell(
      onTap: () => onItemTapped(index),
      borderRadius: BorderRadius.circular(30),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
