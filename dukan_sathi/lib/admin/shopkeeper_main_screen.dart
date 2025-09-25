// import 'package:flutter/material.dart';
// import 'dashboard_page.dart'; // Your dashboard page
// import '../widgets/bottom_navbar.dart'; // Your custom navbar
// import 'products_screen.dart'; // Placeholder
// import 'history_screen.dart'; // Placeholder
// import 'shop_screen.dart'; // Placeholder

// class ShopkeeperMainScreen extends StatefulWidget {
//   const ShopkeeperMainScreen({Key? key}) : super(key: key);

//   @override
//   _ShopkeeperMainScreenState createState() => _ShopkeeperMainScreenState();
// }

// class _ShopkeeperMainScreenState extends State<ShopkeeperMainScreen> {
//   // Using PageController for smooth page transitions
//   final PageController _pageController = PageController();
//   int _selectedIndex = 0;

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   // This function will be called by the navbar when an item is tapped
//   void _onItemTapped(int index) {
//     // The central button has a special purpose, we handle it separately
//     if (index == 2) {
//       print("Cart/Scan button tapped!");
//       // TODO: Add logic for the central button, e.g., show a modal
//       return;
//     }

//     setState(() {
//       _selectedIndex = index;
//       _pageController.jumpToPage(index);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // The body is a Stack to allow the navbar to float on top of the pages
//       body: Stack(
//         children: [
//           PageView(
//             controller: _pageController,
//             onPageChanged: (index) {
//               setState(() {
//                 _selectedIndex = index;
//               });
//             },
//             // The pages that the navbar will control
//             children: const <Widget>[
//               AdminDashboardScreen(),
//               ProductsScreen(),
//               // NOTE: The PageView needs a child for every possible index.
//               // Since the scan button (index 2) doesn't have a page,
//               // we add placeholders. The logic above prevents direct navigation.
//               AdminDashboardScreen(), // Placeholder for index 2
//               HistoryScreen(),
//               ShopScreen(),
//             ],
//           ),
//           // Your custom navigation bar positioned at the bottom
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: ShopkeeperBottomNav(
//               selectedIndex: _selectedIndex,
//               onItemTapped: _onItemTapped,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'dashboard_page.dart'; // Your dashboard page
import '../widgets/bottom_navbar.dart'; // Your custom navbar
import 'products_screen.dart'; // Placeholder
import 'history_screen.dart'; // Placeholder
import 'shop_screen.dart'; // Placeholder

class ShopkeeperMainScreen extends StatefulWidget {
  const ShopkeeperMainScreen({Key? key}) : super(key: key);

  @override
  _ShopkeeperMainScreenState createState() => _ShopkeeperMainScreenState();
}

class _ShopkeeperMainScreenState extends State<ShopkeeperMainScreen> {
  // We use an index to track which page is currently visible
  int _selectedIndex = 0;

  // The list of pages that the navbar will switch between
  static const List<Widget> _pages = <Widget>[
    AdminDashboardScreen(),
    ProductsScreen(),
    // Index 2 is the scan button, which doesn't have a page.
    // The navigation logic will handle this.
    HistoryScreen(),
    ShopScreen(),
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      // Handle the central scan button tap separately
      print("Scan button tapped!");
      // You can add logic here like showing a dialog or new screen
    } else {
      // For other items, we switch the page
      setState(() {
        // We need to adjust the index because the scan button doesn't have a page
        _selectedIndex = index > 2 ? index - 1 : index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The body is a Stack to allow your custom navbar to float on top
      body: Stack(
        children: [
          // This IndexedStack shows only the currently selected page
          IndexedStack(index: _selectedIndex, children: _pages),
          // Your custom navigation bar is positioned at the bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ShopkeeperBottomNav(
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped,
            ),
          ),
        ],
      ),
    );
  }
}
