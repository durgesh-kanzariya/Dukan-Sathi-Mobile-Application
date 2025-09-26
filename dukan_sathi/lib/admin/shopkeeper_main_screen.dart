import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import '../widgets/bottom_navbar.dart';
import 'products_screen.dart';
import 'history_screen.dart';
import 'shop_details_screen.dart'; // CHANGE 1: Import the new shop details screen
import 'pickup_code_screen.dart';

class ShopkeeperMainScreen extends StatefulWidget {
  const ShopkeeperMainScreen({Key? key}) : super(key: key);

  @override
  _ShopkeeperMainScreenState createState() => _ShopkeeperMainScreenState();
}

class _ShopkeeperMainScreenState extends State<ShopkeeperMainScreen> {
  int _selectedIndex = 0;

  // CHANGE 2: Replace the placeholder ShopScreen with the new ShopDetailsScreen
  static const List<Widget> _pages = <Widget>[
    AdminDashboardScreen(),
    ProductsScreen(),
    HistoryScreen(),
    ShopDetailsScreen(), // The new screen is now part of the main navigation
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PickupCodeScreen()),
      );
    } else {
      setState(() {
        _selectedIndex = index > 2 ? index - 1 : index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The body is now wrapped in a Container to ensure the background color is consistent
      body: Container(
        color: const Color(0xFFFDFBF5),
        child: Stack(
          children: [
            IndexedStack(index: _selectedIndex, children: _pages),
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
      ),
    );
  }
}
