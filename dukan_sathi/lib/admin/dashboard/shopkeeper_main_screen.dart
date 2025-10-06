import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import '../../widgets/bottom_navbar.dart';
import '../product/products_screen.dart';
import '../order/history_screen.dart';
import '../misc/shop_details_screen.dart';
import '../misc/pickup_code_screen.dart';

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
    ShopDetailsScreen(),
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
    // --- 1. CHECK IF KEYBOARD IS VISIBLE ---
    // We check the 'viewInsets' which tells us about system UI like the keyboard.
    // If the bottom inset is greater than 0, the keyboard is visible.
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      body: Container(
        color: const Color(0xFFFDFBF5),
        child: Stack(
          children: [
            IndexedStack(index: _selectedIndex, children: _pages),

            // --- 2. CONDITIONALLY SHOW THE NAVBAR ---
            // The Visibility widget will hide its child when 'visible' is false.
            // So, when the keyboard is visible, the navbar will be hidden.
            Visibility(
              visible: !isKeyboardVisible,
              child: Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: ShopkeeperBottomNav(
                  selectedIndex: _selectedIndex,
                  onItemTapped: _onItemTapped,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
 