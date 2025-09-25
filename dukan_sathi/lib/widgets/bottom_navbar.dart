// import 'package:flutter/material.dart';
// // In a real app, you would import your actual pages here.
// // For now, these are just placeholder widgets.

// class ShopkeeperBottomNav extends StatefulWidget {
//   const ShopkeeperBottomNav({Key? key}) : super(key: key);

//   @override
//   State<ShopkeeperBottomNav> createState() => _ShopkeeperBottomNavState();
// }

// class _ShopkeeperBottomNavState extends State<ShopkeeperBottomNav> {
//   int _selectedIndex = 0; // To track the currently selected item

//   // This would be replaced with your actual navigation logic
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//       // TODO: Add navigation logic here, e.g., using a PageController or Navigator
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // This widget uses a Scaffold's built-in properties for the correct layout
//     return BottomAppBar(
//       shape: const CircularNotchedRectangle(),
//       notchMargin: 8.0,
//       color: const Color(0xFF5A7D60),
//       child: SizedBox(
//         height: 60,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: <Widget>[
//             _buildNavItem(
//               icon: Icons.list_alt,
//               label: 'Orders',
//               index: 0,
//             ),
//             _buildNavItem(
//               icon: Icons.inventory_2_outlined,
//               label: 'Product',
//               index: 1,
//             ),
//             const SizedBox(width: 40), // The space for the floating action button
//             _buildNavItem(
//               icon: Icons.history,
//               label: 'History',
//               index: 2,
//             ),
//             _buildNavItem(
//               icon: Icons.store_outlined,
//               label: 'Shop',
//               index: 3,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Helper widget to build each navigation item
//   Widget _buildNavItem({
//     required IconData icon,
//     required String label,
//     required int index,
//   }) {
//     final isSelected = _selectedIndex == index;
//     final color = isSelected ? Colors.white : Colors.white.withOpacity(0.7);

//     return InkWell(
//       onTap: () => _onItemTapped(index),
//       borderRadius: BorderRadius.circular(20),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 8.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, color: color),
//             const SizedBox(height: 2),
//             Text(
//               label,
//               style: TextStyle(
//                 color: color,
//                 fontSize: 12,
//                 fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

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
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      color: const Color(0xFF5A7D60),
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildNavItem(icon: Icons.list_alt, label: 'Orders', index: 0),
            _buildNavItem(
              icon: Icons.inventory_2_outlined,
              label: 'Product',
              index: 1,
            ),
            const SizedBox(width: 40), // The space for the FAB
            _buildNavItem(icon: Icons.history, label: 'History', index: 2),
            _buildNavItem(icon: Icons.store_outlined, label: 'Shop', index: 3),
          ],
        ),
      ),
    );
  }

  // Helper widget to build each navigation item
  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = selectedIndex == index;
    final color = isSelected ? Colors.white : Colors.white.withOpacity(0.7);

    return InkWell(
      onTap: () => onItemTapped(index),
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 2),
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
