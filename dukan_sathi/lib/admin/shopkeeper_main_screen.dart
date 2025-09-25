import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import '../widgets/bottom_navbar.dart';
import 'products_screen.dart';
import 'history_screen.dart';
import 'shop_screen.dart';
import 'pickup_code_screen.dart'; // <-- 1. IMPORT the new screen

class ShopkeeperMainScreen extends StatefulWidget {
  const ShopkeeperMainScreen({Key? key}) : super(key: key);

  @override
  _ShopkeeperMainScreenState createState() => _ShopkeeperMainScreenState();
}

class _ShopkeeperMainScreenState extends State<ShopkeeperMainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    AdminDashboardScreen(),
    ProductsScreen(),
    HistoryScreen(),
    ShopScreen(),
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      // <-- 2. MODIFY this block
      // Handle the central scan button tap to navigate to the new screen
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
      body: Stack(
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
    );
  }
}
