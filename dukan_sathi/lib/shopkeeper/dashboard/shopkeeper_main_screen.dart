// import 'package:flutter/material.dart';
// import 'package:get/get.dart'; // <-- 1. Import Get
// import 'dashboard_page.dart';
// import '../../widgets/bottom_navbar.dart';
// import '../product/products_screen.dart';
// import '../order/history_screen.dart';
// import '../misc/shop_details_screen.dart';
// import '../misc/pickup_code_screen.dart';
// // <-- 2. Import your controllers
// import 'package:dukan_sathi/shopkeeper/order/order_controller.dart';
// import 'package:dukan_sathi/shopkeeper/product/product_controller.dart';

// class ShopkeeperMainScreen extends StatefulWidget {
//   const ShopkeeperMainScreen({Key? key}) : super(key: key);

//   @override
//   _ShopkeeperMainScreenState createState() => _ShopkeeperMainScreenState();
// }

// class _ShopkeeperMainScreenState extends State<ShopkeeperMainScreen> {
//   int _selectedIndex = 0;

//   // --- 3. Put controllers in initState ---
//   // This ensures they are created BEFORE the pages below try to find them.
//   @override
//   void initState() {
//     super.initState();
//     Get.put(OrderController());
//     Get.put(ProductController());
//   }

//   static const List<Widget> _pages = <Widget>[
//     AdminDashboardScreen(),
//     ProductsScreen(),
//     HistoryScreen(),
//     ShopDetailsScreen(),
//   ];

//   void _onItemTapped(int index) {
//     if (index == 2) {
//       // Navigate to Scan screen
//       // This push is correct, as it's an overlay
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const PickupCodeScreen()),
//       );
//     } else {
//       // Switch tabs
//       setState(() {
//         _selectedIndex = index > 2 ? index - 1 : index;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

//     return Scaffold(
//       body: Container(
//         color: const Color.fromARGB(226, 249, 243, 231),
//         child: Stack(
//           children: [
//             // This IndexedStack is what causes the race condition
//             // By putting controllers in initState, we fix it.
//             IndexedStack(index: _selectedIndex, children: _pages),

//             Visibility(
//               visible: !isKeyboardVisible,
//               child: Positioned(
//                 bottom: 0,
//                 left: 0,
//                 right: 0,
//                 child: ShopkeeperBottomNav(
//                   selectedIndex: _selectedIndex,
//                   onItemTapped: _onItemTapped,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:dukan_sathi/shop_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dashboard_page.dart';
import '../../widgets/bottom_navbar.dart';
import '../product/products_screen.dart';
import '../order/history_screen.dart';
import '../misc/shop_details_screen.dart';
import '../misc/pickup_code_screen.dart';
import '../misc/shop_setup_screen.dart';
import 'package:dukan_sathi/shopkeeper/order/order_controller.dart';
import 'package:dukan_sathi/shopkeeper/product/product_controller.dart';
import 'package:dukan_sathi/shop_service.dart';

class ShopkeeperMainScreen extends StatefulWidget {
  const ShopkeeperMainScreen({Key? key}) : super(key: key);

  @override
  _ShopkeeperMainScreenState createState() => _ShopkeeperMainScreenState();
}

class _ShopkeeperMainScreenState extends State<ShopkeeperMainScreen> {
  int _selectedIndex = 0;
  bool _controllersInitialized = false;
  bool _checkingShop = true;
  ShopService? _shopService;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  Future<void> _initializeControllers() async {
    try {
      // Initialize ShopService first
      if (!Get.isRegistered<ShopService>()) {
        await Get.putAsync<ShopService>(() => ShopService().init());
      }

      _shopService = Get.find<ShopService>();

      // Set up listener for shop data changes
      _setupShopListener();

      // Initialize other controllers
      if (!Get.isRegistered<OrderController>()) {
        Get.put(OrderController());
      }

      if (!Get.isRegistered<ProductController>()) {
        Get.put(ProductController());
      }

      if (mounted) {
        setState(() {
          _controllersInitialized = true;
        });
      }

      // Check if shop data is already available
      _checkInitialShopState();
    } catch (e) {
      print("Error initializing controllers: $e");
      if (mounted) {
        setState(() {
          _controllersInitialized = true;
          _checkingShop = false;
        });
      }
    }
  }

  void _setupShopListener() {
    // Listen to shop data changes
    ever(_shopService!.currentShop, (Shop? shop) {
      print(
        "🛍️ ShopListener: Shop data updated - ${shop?.shopName ?? 'null'}",
      );
      if (mounted) {
        setState(() {
          _checkingShop = false;
        });
      }
    });

    // Also listen to loading state
    ever(_shopService!.isLoading, (bool loading) {
      print("🛍️ ShopListener: Loading state - $loading");
      if (!loading && mounted) {
        setState(() {
          _checkingShop = false;
        });
      }
    });
  }

  void _checkInitialShopState() {
    // If shop data is already available, update state immediately
    if (_shopService!.currentShop.value != null) {
      print(
        "🛍️ InitialShopCheck: Shop already available - ${_shopService!.currentShop.value!.shopName}",
      );
      if (mounted) {
        setState(() {
          _checkingShop = false;
        });
      }
    }

    // Also set a timeout to prevent infinite loading
    Future.delayed(Duration(seconds: 10), () {
      if (_checkingShop && mounted) {
        print("🛍️ Timeout: Forcing _checkingShop to false");
        setState(() {
          _checkingShop = false;
        });
      }
    });
  }

  static final List<Widget> _pages = <Widget>[
    const AdminDashboardScreen(),
    const ProductsScreen(),
    const HistoryScreen(),
    const ShopDetailsScreen(),
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
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    // Show loading while controllers are initializing or checking shop
    if (!_controllersInitialized || _shopService == null || _checkingShop) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(226, 249, 243, 231),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Color(0xFF5A7D60)),
              SizedBox(height: 20),
              Text(
                "Setting up your shop...",
                style: TextStyle(color: Color(0xFF5A7D60), fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    // If user has no shop, show setup screen
    if (_shopService!.currentShop.value == null) {
      print("🛍️ Build: No shop found, showing ShopSetupScreen");
      return const ShopSetupScreen();
    }

    // Otherwise show normal dashboard
    print(
      "🛍️ Build: Shop found, showing dashboard - ${_shopService!.currentShop.value!.shopName}",
    );
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(226, 249, 243, 231),
        child: Stack(
          children: [
            IndexedStack(index: _selectedIndex, children: _pages),

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
