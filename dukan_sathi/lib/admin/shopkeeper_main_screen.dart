import 'package:flutter/material.dart';
import 'dashboard_page.dart'; // Your existing dashboard
import '../widgets/bottom_navbar.dart';   // Your existing navbar

// Placeholders for the other pages
class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const Scaffold(backgroundColor: Color(0xFFFDFBF5), body: Center(child: Text('Products Screen')));
}

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const Scaffold(backgroundColor: Color(0xFFFDFBF5), body: Center(child: Text('History Screen')));
}

class ShopScreen extends StatelessWidget {
  const ShopScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const Scaffold(backgroundColor: Color(0xFFFDFBF5), body: Center(child: Text('Shop Screen')));
}


class ShopkeeperMainScreen extends StatefulWidget {
  const ShopkeeperMainScreen({Key? key}) : super(key: key);

  @override
  _ShopkeeperMainScreenState createState() => _ShopkeeperMainScreenState();
}

class _ShopkeeperMainScreenState extends State<ShopkeeperMainScreen> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF5),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        // The list of pages that the navbar will switch between
        children: const <Widget>[
          AdminDashboardScreen(),
          ProductsScreen(),
          HistoryScreen(),
          ShopScreen(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Handle Scan button tap
          print("Scan button tapped!");
        },
        backgroundColor: const Color(0xFF5A7D60),
        shape: const CircleBorder(),
        child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 28),
        elevation: 2.0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // Using your custom navbar widget
      bottomNavigationBar: ShopkeeperBottomNav(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

